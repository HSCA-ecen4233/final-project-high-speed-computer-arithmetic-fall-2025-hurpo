/* verilator lint_off STMTDLY */
module tb;
  // DUT I/O
  logic [15:0] input_val;
  logic        sign;
  logic [4:0]  exponent;
  logic [10:0] mant;
  logic        is_zero;
  logic        is_infinite;
  logic        is_nan;

  // Instantiate DUT
  unpack dut (
    .input_val     (input_val),
    .sign      (sign),
    .exponent  (exponent),
    .mant      (mant),
    .is_zero   (is_zero),
    .is_infinite(is_infinite),
    .is_nan    (is_nan)
  );

  // Stimulus
  initial begin
    $display("=== Starting unpack testbench ===");

    // Normal number: sign=0, exponent=01010, fraction=0101010101
    input_val = 16'b0_01010_0101010101;
    #10;

    // Zero
    input_val = 16'b0_00000_0000000000;
    #10;

    // Infinity
    input_val = 16'b0_11111_0000000000;
    #10;

    // NaN
    input_val = 16'b0_11111_0000000001;
    #10;

    // Negative normal value
    input_val = 16'b1_00110_1111000000;
    #10;

    $display("=== Testbench completed ===");
    $finish;
  end
   
endmodule
