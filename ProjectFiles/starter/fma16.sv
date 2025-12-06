module fma16 (input logic [15:0] x, y, z, input logic [2:0] FrOpCtrl,
              input logic [2:0] Frm, output logic [15:0] PostProcRes,
              output logic [15:0] result, output logic [4:0] flags);
   
  assign result = x * y + z;
   
endmodule

module unpack (
  input logic [15:0]  input_val,
  output logic        sign,
  output logic [4:0]  exponent,
  output logic [10:0] mant,
  output logic        is_zero,
  output logic        is_infinite,
  output logic        is_nan
);
  logic [9:0] fraction;
  assign sign = input_val[15];
  assign exponent = input_val[14:10];
  assign fraction = input_val[9:0];

  assign is_zero = (exponent == 5'b00000) && (fraction == 10'b0);
  assign is_infinite = (exponent == 5'b11111) && (fraction == 10'b0);
  assign is_nan = (exponent == 5'b11111) && (fraction != 10'b0);

    always_comb begin
      if (exponent == 5'b00000) begin
        assign mant = 11'b0;
      end else begin
        assign mant = {1'b1, fraction};
      end
    end

endmodule 

module mul_core (
    input  logic        signA,
    input  logic        signB,
    input  logic [4:0]  expA,
    input  logic [4:0]  expB,
    input  logic [10:0] mantA,
    input  logic [10:0] mantB,

    input  logic        is_zeroA,
    input  logic        is_zeroB,
    input  logic        is_infA,
    input  logic        is_infB,
    input  logic        is_nanA,
    input  logic        is_nanB,

    output logic        signP,
    output logic [4:0]  expP,
    output logic [12:0] mantP,
    output logic        is_zeroP,
    output logic        is_infP,
    output logic        is_nanP
);

    logic [21:0] prod_raw;
    logic [21:0] prod_norm;
    logic [6:0]  exp_sum;
    logic [6:0]  exp_norm;

    logic guard, round, sticky;

    always_comb begin



        signP    = signA ^ signB;
        expP     = 5'b0;
        mantP    = 13'b0;
        is_zeroP = 1'b0;
        is_infP  = 1'b0;
        is_nanP  = 1'b0;


        // Special Cases

        if (is_nanA || is_nanB) begin
            is_nanP = 1;
            mantP   = 13'h1000;
        end

        else if ((is_infA && is_zeroB) || (is_infB && is_zeroA)) begin
            is_nanP = 1;
            mantP   = 13'h1000;
        end

        else if (is_infA || is_infB) begin
            is_infP = 1;
            expP    = 5'h1F;   // exponent = 11111
        end

        else if (is_zeroA || is_zeroB) begin
            is_zeroP = 1;
        end


        // Normal Multiply

        else begin

            // Multiply mantissas
            prod_raw = mantA * mantB;

            // Add exponents and subtract bias
            exp_sum = expA + expB - 5'd15;

            // Normalize
            if (prod_raw[21]) begin
                prod_norm = prod_raw;
                exp_norm  = exp_sum;
            end else begin
                prod_norm = prod_raw << 1;
                exp_norm  = exp_sum - 1;
            end

            // Extract mantissa bits
            mantP[12:2] = prod_norm[20:10];

            // Guard, Round, Sticky
            guard  = prod_norm[9];
            round  = prod_norm[8];
            sticky = |prod_norm[7:0];

            mantP[1] = guard;
            mantP[0] = round | sticky;

            // Final exponent
            expP = exp_norm[4:0];
        end
    end

endmodule

module add_core (
    input  logic        Xs,
    input  logic [4:0]  Xe,
    input  logic [10:0] Xm,

    input  logic        Ys,
    input  logic [4:0]  Ye,
    input  logic [10:0] Ym,

    input  logic        X_isZero,
    input  logic        X_isInf,
    input  logic        X_isNaN,

    input  logic        Y_isZero,
    input  logic        Y_isInf,
    input  logic        Y_isNaN,

    output logic        Ws,
    output logic [4:0]  We,
    output logic [10:0] Wm,
    output logic        W_isZero,
    output logic        W_isInf,
    output logic        W_isNaN
);

    logic [4:0] exp_big, exp_small;
    logic [10:0] mant_big, mant_small;
    logic sign_big, sign_small;

    logic [5:0] shift_amt;

    logic [14:0] align_small;
    logic [14:0] align_big;

    logic sticky_small;
    logic subtract;

    logic [14:0] raw_big, raw_small;
    logic [14:0] sum_raw;

    logic [10:0] norm_mant;
    logic [4:0]  norm_exp;
    logic        norm_sign;

    logic guard, round_bit, sticky;

    logic [10:0] rounded_mant;
    logic        round_inc;

    integer i;   // loop counter
    integer shiftL; // left-normalization counter


    always_comb begin

        // Defaults
        Ws = 0; We = 0; Wm = 0;
        W_isZero = 0; W_isInf = 0; W_isNaN = 0;


        if (X_isNaN || Y_isNaN) begin
            W_isNaN = 1;
        end
        else if (X_isInf && Y_isInf && (Xs != Ys)) begin
            W_isNaN = 1;
        end
        else if (X_isInf) begin
            W_isInf = 1;
            Ws = Xs;
        end
        else if (Y_isInf) begin
            W_isInf = 1;
            Ws = Ys;
        end
        else if (X_isZero && Y_isZero) begin
            W_isZero = 1;
            Ws = Xs & Ys;
        end
        else begin

            // Compare exponents
            if (Xe >= Ye) begin
                exp_big   = Xe;
                mant_big  = Xm;
                sign_big  = Xs;

                exp_small = Ye;
                mant_small = Ym;
                sign_small = Ys;
            end else begin
                exp_big   = Ye;
                mant_big  = Ym;
                sign_big  = Ys;

                exp_small = Xe;
                mant_small = Xm;
                sign_small = Xs;
            end

            // Exponent difference
            shift_amt = exp_big - exp_small;

            raw_small = {1'b0, mant_small, 3'd0}; // extend
            raw_big   = {1'b0, mant_big, 3'd0};

            if (shift_amt >= 13) begin
                align_small = 13'b0;
                sticky_small = |raw_small;
            end else begin
                align_small = raw_small >> shift_amt;

                sticky_small = 0;
                for (i = 0; i < shift_amt; i++)
                    sticky_small |= raw_small[i];

                align_small[0] |= sticky_small;
            end

            align_big = raw_big;
            exp_small = exp_small + shift_amt;

            subtract = (sign_big ^ sign_small);

            if (subtract)
                sum_raw = align_big - align_small;
            else
                sum_raw = align_big + align_small;

            if (sum_raw[14]) begin
                // shift right
                norm_mant = {sum_raw[14:4]};
                norm_exp  = exp_small + 1;
                norm_sign = sign_big;

                guard = sum_raw[3];
                round_bit = sum_raw[2];
                sticky = sum_raw[1];
            end
            else if (sum_raw[13]) begin
                // already normalized
                norm_mant = sum_raw[13:3];
                norm_exp  = exp_big;
                norm_sign = sign_big;

                guard = sum_raw[2];
                round_bit = sum_raw[1];
                sticky = sum_raw[0];
            end
  else begin

    shiftL = 0;

    for (i = 13; i >= 0; i = i - 1) begin
        if (sum_raw[i] == 1'b1) begin
            shiftL = 13 - i;
            break;
        end
    end

    norm_mant = sum_raw << shiftL;

    norm_exp = exp_big - shiftL;

    norm_sign = sign_big;

    guard      = norm_mant[2];
    round_bit  = norm_mant[1];
    sticky     = norm_mant[0];

    if (sum_raw == 0) begin
        W_isZero = 1;
        Ws = sign_big;
        We = 0;
        Wm = 0;
        disable normalization_done;
    end
end

normalization_done: begin end

            if (guard && !round_bit && !sticky) begin
              if (norm_mant[0]) begin
                rounded_mant = norm_mant + 1;
              end
            end else if (round_bit | sticky) begin
              rounded_mant = norm_mant + 1;
            end else begin
              rounded_mant = norm_mant;
            end

            Ws = norm_sign;
            We = norm_exp;
            Wm = rounded_mant;

        end
    end

endmodule
