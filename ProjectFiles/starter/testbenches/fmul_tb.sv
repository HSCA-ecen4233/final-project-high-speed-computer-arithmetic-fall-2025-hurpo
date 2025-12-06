`timescale 1ns/1ps

module tb;

  // DUT inputs
  logic        signA, signB;
  logic [4:0]  expA, expB;
  logic [10:0] mantA, mantB;

  logic        is_zeroA, is_zeroB;
  logic        is_infA,  is_infB;
  logic        is_nanA,  is_nanB;

  // DUT outputs
  logic        signP;
  logic [4:0]  expP;
  logic [12:0] mantP;
  logic        is_zeroP;
  logic        is_infP;
  logic        is_nanP;

  // Instantiate the DUT
  mul_core dut (
    .signA(signA), .signB(signB),
    .expA(expA), .expB(expB),
    .mantA(mantA), .mantB(mantB),

    .is_zeroA(is_zeroA), .is_zeroB(is_zeroB),
    .is_infA(is_infA),   .is_infB(is_infB),
    .is_nanA(is_nanA),   .is_nanB(is_nanB),

    .signP(signP),
    .expP(expP),
    .mantP(mantP),
    .is_zeroP(is_zeroP),
    .is_infP(is_infP),
    .is_nanP(is_nanP)
  );

  task apply(
      input logic sA, sB,
      input logic [4:0] eA, eB,
      input logic [10:0] mA, mB,
      input logic zA, zB,
      input logic iA, iB,
      input logic nA, nB,
      input string label
  );
  begin
      signA = sA;     signB = sB;
      expA  = eA;     expB  = eB;
      mantA = mA;     mantB = mB;

      is_zeroA = zA;  is_zeroB = zB;
      is_infA  = iA;  is_infB  = iB;
      is_nanA  = nA;  is_nanB  = nB;

      #1; // allow combinational logic to settle
      $display("---- %s ----", label);
      $display("signP=%0b expP=%0d mantP=0x%0h  zero=%0b inf=%0b nan=%0b\n",
                signP, expP, mantP, is_zeroP, is_infP, is_nanP);
  end
  endtask

  initial begin
    $display("=== mul_core testbench start ===");

    // 1. Normal × Normal (1.5 × 1.25)
    apply(
      0, 0,
      5'd15, 5'd15,
      11'b1_1000000000,    // mant = 1.5
      11'b1_0100000000,    // mant = 1.25
      0,0,   // zero
      0,0,   // inf
      0,0,   // nan
      "Normal * Normal"
    );

    // 2. Zero × Normal = Zero
    apply(
      0, 1,
      5'd0, 5'd10,
      11'd0, 11'b1_1000000000,
      1,0,   // A=zero
      0,0,
      0,0,
      "Zero * Normal"
    );

    // 3. Infinity × finite = Infinity
    apply(
      0, 0,
      5'h1F, 5'd13,
      11'd0, 11'b1_0010000000,
      0,0,
      1,0,   // A=inf
      0,0,
      "Inf * Finite"
    );

    // 4. Infinity × Zero → NaN
    apply(
      0, 0,
      5'h1F, 5'd0,
      11'd0, 11'd0,
      0,1,   // B is zero
      1,0,   // A is inf
      0,0,
      "Inf * Zero -> NaN"
    );

    // 5. NaN × Anything → NaN
    apply(
      0, 0,
      5'd0, 5'd0,
      11'd0, 11'd0,
      0,0,
      0,0,
      1,0,   // A = NaN
      "NaN * Anything"
    );

    // 6. Sign test: (-1.5) × (+1.5)
    apply(
      1, 0,
      5'd16, 5'd16,
      11'b1_1000000000,
      11'b1_1000000000,
      0,0,
      0,0,
      0,0,
      "Sign handling"
    );

    $display("=== mul_core testbench complete ===");
    $finish;
  end

endmodule
