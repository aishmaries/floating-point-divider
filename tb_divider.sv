
module tb_divider;

localparam int MANT = 23;
localparam int EXP = 8;

localparam int TOTAL = MANT + EXP;

logic [31:0] in0;
logic [31:0] in1;
logic [31:0] out;

int pass_count = 0;
int fail_count = 0;

fp_divider #(
    .MANT(MANT),
    .EXP(EXP)
) dut (
    .in0(in0),
    .in1(in1),
    .out(out)
);

task automatic run_test(input logic [TOTAL:0] a_in, input logic [TOTAL:0] b_in,
                         input logic [TOTAL:0] expected, input string label);
  in0 = a_in;
  in1 = b_in;
  #1; // combinational settle time

  if (out === expected) begin
    $display("PASS [%s]: in0=%h in1=%h -> out=%h (expected %h)", label, a_in, b_in, out, expected);
    pass_count++;
  end else begin
    $display("FAIL [%s]: in0=%h in1=%h -> out=%h (expected %h)", label, a_in, b_in, out, expected);
    fail_count++;
  end
endtask

initial begin
    // --- Basic normal division ---
    run_test(32'h40400000, 32'h40000000, 32'h3FC00000, "3.0 / 2.0 = 1.5");
    run_test(32'h41200000, 32'h40800000, 32'h40200000, "10.0 / 4.0 = 2.5");
    run_test(32'h3F800000, 32'h3F800000, 32'h3F800000, "1.0 / 1.0 = 1.0");

    // --- Division by 1 (identity) ---
    run_test(32'h42F60000, 32'h3F800000, 32'h42F60000, "123.0 / 1.0 = 123.0");
    run_test(32'hC2F60000, 32'h3F800000, 32'hC2F60000, "-123.0 / 1.0 = -123.0");

    // --- Self division = 1.0 ---
    run_test(32'h447A0000, 32'h447A0000, 32'h3F800000, "1000.0 / 1000.0 = 1.0");
    run_test(32'hC47A0000, 32'hC47A0000, 32'h3F800000, "-1000.0 / -1000.0 = 1.0");

    // --- Sign combinations ---
    run_test(32'h40400000, 32'hC0000000, 32'hBFC00000, "3.0 / -2.0 = -1.5");
    run_test(32'hC0400000, 32'h40000000, 32'hBFC00000, "-3.0 / 2.0 = -1.5");
    run_test(32'hC0400000, 32'hC0000000, 32'h3FC00000, "-3.0 / -2.0 = 1.5");

    // --- Zero numerator ---
    run_test(32'h00000000, 32'h40400000, 32'h00000000, "0.0 / 3.0 = 0.0");
    

    // --- Exact powers of two (clean exponent shifts) ---
    run_test(32'h41000000, 32'h40000000, 32'h40800000, "8.0 / 2.0 = 4.0");
    run_test(32'h40000000, 32'h41000000, 32'h3E800000, "2.0 / 8.0 = 0.25");
    run_test(32'h3F800000, 32'h40000000, 32'h3F000000, "1.0 / 2.0 = 0.5");

    // --- Non-exact / repeating quotient (rounding stress) ---
    run_test(32'h40400000, 32'h40400000, 32'h3F800000, "3.0 / 3.0 = 1.0");
    run_test(32'h3F800000, 32'h40400000, 32'h3EAAAAAA, "1.0 / 3.0 = 0.3333333...");
    run_test(32'h40400000, 32'h3F800000, 32'h40400000, "3.0 / 1.0 = 3.0");

    // --- Large / small magnitude ---
    run_test(32'h7F000000, 32'h3F800000, 32'h7F000000, "large / 1.0 = large");
    run_test(32'h7F000000, 32'h41000000, 32'h7D800000, "large / 8.0 = large/8");

    // --- Fractional inputs ---
    run_test(32'h3F000000, 32'h3E800000, 32'h40000000, "0.5 / 0.25 = 2.0");
    run_test(32'h3E800000, 32'h3F000000, 32'h3F000000, "0.25 / 0.5 = 0.5");

    $display("---------------------------------");
    $display("Total: %0d, Pass: %0d, Fail: %0d", pass_count + fail_count, pass_count, fail_count);
    $finish;
end


endmodule



