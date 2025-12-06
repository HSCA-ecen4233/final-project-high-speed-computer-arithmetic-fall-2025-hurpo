`timescale 1ns/1ps

module tb;

  // ---------------------------
  // DUT inputs
  // ---------------------------
  logic        Xs, Ys;
  logic [4:0]  Xe, Ye;
  logic [10:0] Xm, Ym;

  logic        X_isZero, X_isInf, X_isNaN;
  logic        Y_isZero, Y_isInf, Y_isNaN;

  // ---------------------------
  // DUT outputs
  // ---------------------------
  logic        Ws;
  logic [4:0]  We;
  logic [10:0] Wm;
  logic        W_isZero, W_isInf, W_isNaN;

  // ---------------------------
  // Instantiate the DUT
  // ---------------------------
  add_core dut (
    .Xs(Xs), .Xe(Xe), .Xm(Xm),
    .Ys(Ys), .Ye(Ye), .Ym(Ym),
    .X_isZero(X_isZero), .X_isInf(X_isInf), .X_isNaN(X_isNaN),
    .Y_isZero(Y_isZero), .Y_isInf(Y_isInf), .Y_isNaN(Y_isNaN),
    .Ws(Ws), .We(We), .Wm(Wm),
    .W_isZero(W_isZero), .W_isInf(W_isInf), .W_isNaN(W_isNaN)
  );

  // ---------------------------
  // Task to apply one test vector
  // ---------------------------
  task apply(
      input logic sX, sY,
      input logic [4:0] eX, eY,
      input logic [10:0] mX, mY,
      input logic zX, zY,
      input logic iX, iY,
      input logic nX, nY,
      input string label
  );
  begin
      Xs = sX;  Ys = sY;
      Xe = eX;  Ye = eY;
      Xm = mX;  Ym = mY;

      X_isZero = zX;  Y_isZero = zY;
      X_isInf  = iX;  Y_isInf  = iY;
      X_isNaN  = nX;  Y_isNaN  = nY;

      #1; // allow combinational logic to settle
      $display("---- %s ----", label);
      $display("Xs=%0b Xe=%0d Xm=0x%0h  |  Ys=%0b Ye=%0d Ym=0x%0h", 
                Xs, Xe, Xm, Ys, Ye, Ym);
      $display("Special: X Z=%0b Inf=%0b NaN=%0b | Y Z=%0b Inf=%0b NaN=%0b",
                X_isZero, X_isInf, X_isNaN,
                Y_isZero, Y_isInf, Y_isNaN);
      $display("=> W: Ws=%0b We=%0d Wm=0x%0h  Zero=%0b Inf=%0b NaN=%0b\n",
                Ws, We, Wm, W_isZero, W_isInf, W_isNaN);
  end
  endtask

  // ---------------------------
  // Test stimulus
  // ---------------------------
  initial begin
      $display("=== add_core testbench start ===");
      $dumpfile("add_core_tb.vcd");
      $dumpvars(0, tb);

      // 1. Normal add: 1.5 + 0.5
      apply(
        0, 0,
        5'd15, 5'd14,
        11'b1_1000000000, 11'b1_0000000000,
        0,0,   // zero
        0,0,   // inf
        0,0,   // nan
        "Normal + Normal"
        // Ws=0 We=10000, Wm=10000000000
      );

      //
      apply(
        0, 0,
        5'd15, 5'd12,
        11'b1_1000000000, 11'b1_0000000101,
        0,0,   // zero
        0,0,   // inf
        0,0,   // nan
        "Normal + Normal"
        // Ws=0, We=01111, Wm=1_1010000001
      );

      // 2. Subtraction (different signs)
      apply(
        0, 1,
        5'd16, 5'd16,
        11'b1_1000000000, 11'b1_0100000000,
        0,0,
        0,0,
        0,0,
        "Subtraction (+ -)"
        // Ws=1, We=01111, Wm=1_1000000000
      );

      // 3. Zero + number
      apply(
        0, 0,
        5'd0, 5'd12,
        11'd0, 11'b1_1000000000,
        1,0,
        0,0,
        0,0,
        "Zero + Normal"
      );

      // 4. Infinity + number
      apply(
        0, 0,
        5'd0, 5'd12,
        11'd0, 11'b1_1000000000,
        0,0,
        1,0,
        0,0,
        "Infinity + Normal"
      );

      // 5. +INF + -INF -> NaN
      apply(
        0, 1,
        5'd0, 5'd0,
        11'd0, 11'd0,
        0,0,
        1,1,
        0,0,
        "+INF + -INF"
      );

      // 6. NaN input
      apply(
        0,0,
        5'd0,5'd0,
        11'd0,11'd0,
        0,0,
        0,0,
        1,0,
        "NaN input"
      );

      $display("=== add_core testbench complete ===");
      $finish;
  end

endmodule
