module tb_int_divider;

localparam int BW = 32;

logic [BW-1:0] in0;
logic [BW-1:0] in1;
logic [BW-1:0] quotient;
logic [BW-1:0] remainder;

int_divider_alt #(
    .BW(BW)
) dut (
    .numerator(in0),
    .denominator(in1),
    .quotient(quotient),
    .remainder(remainder)
);

int pass_count = 0;
int fail_count = 0;

task automatic run_test(input logic [BW-1:0] a_in, input logic [BW-1:0] b_in,
                        input logic [BW-1:0] exp_q, input logic [BW-1:0] exp_r,
                        input string label);
  in0 = a_in;
  in1 = b_in;
  #1; // combinational settle time

  if (quotient === exp_q && remainder === exp_r) begin
    $display("PASS [%s]: in0=%0d in1=%0d -> q=%0d r=%0d (expected q=%0d r=%0d)",
             label, a_in, b_in, quotient, remainder, exp_q, exp_r);
    pass_count++;
  end else begin
    $display("FAIL [%s]: in0=%0d in1=%0d -> q=%0d r=%0d (expected q=%0d r=%0d)",
             label, a_in, b_in, quotient, remainder, exp_q, exp_r);
    fail_count++;
  end
endtask

initial begin
  // ---- Zero numerator ----
  run_test(0, 1,            0, 0, "0/1");
  run_test(0, 2,            0, 0, "0/2");
  run_test(0, 12345,        0, 0, "0/12345");
  run_test(0, 32'hFFFF_FFFF, 0, 0, "0/MAX");

  // ---- Divide by one ----
  run_test(1,             1, 1,             0, "1/1");
  run_test(42,            1, 42,            0, "42/1");
  run_test(32'hFFFF_FFFF, 1, 32'hFFFF_FFFF, 0, "MAX/1");

  // ---- Divide by self ----
  run_test(7,             7,             1, 0, "7/7");
  run_test(32'hFFFF_FFFF, 32'hFFFF_FFFF, 1, 0, "MAX/MAX");

  // ---- Numerator < denominator ----
  run_test(3,             5,             0, 3,             "3/5");
  run_test(32'hFFFF_FFFE, 32'hFFFF_FFFF, 0, 32'hFFFF_FFFE, "(MAX-1)/MAX");
  run_test(1,             32'hFFFF_FFFF, 0, 1,             "1/MAX");

  // ---- Exact division ----
  run_test(100,           10, 10,            0, "100/10");
  run_test(144,           12, 12,            0, "144/12");
  run_test(32'h8000_0000, 2,  32'h4000_0000, 0, "2^31/2");

  // ---- Non-zero remainder ----
  run_test(10,            3,  3,             1, "10/3");
  run_test(100,           7,  14,            2, "100/7");
  run_test(32'hFFFF_FFFF, 10, 32'h1999_9999, 5, "MAX/10");
  run_test(32'hFFFF_FFFF, 3,  32'h5555_5555, 0, "MAX/3");

  // ---- Powers of two ----
  for (int i = 0; i < BW; i++) begin
    logic [BW-1:0] p;
    p = 1 << i;
    run_test(32'hFFFF_FFFF, p, 32'hFFFF_FFFF >> i, p - 1, $sformatf("MAX/2^%0d", i));
    run_test(p, 3, p / 3, p % 3, $sformatf("2^%0d/3", i));
  end

  // ---- MSB / boundary values ----
  run_test(32'h8000_0000, 32'h8000_0000, 1, 0,             "2^31/2^31");
  run_test(32'h8000_0000, 32'h7FFF_FFFF, 1, 1,             "2^31/(2^31-1)");
  run_test(32'hFFFF_FFFF, 32'h8000_0000, 1, 32'h7FFF_FFFF, "MAX/2^31");
  run_test(32'hFFFF_FFFF, 32'h7FFF_FFFF, 2, 1,             "MAX/(2^31-1)");

//   // ---- Random: full-range denominator ----
//   for (int i = 0; i < N_RANDOM; i++) begin
//     logic [BW-1:0] n, d;
//     n = $urandom;
//     d = $urandom;
//     if (d == 0) d = 1;
//     run_test(n, d, n / d, n % d, $sformatf("rand_full_%0d", i));
//   end

//   // ---- Random: small denominator ----
//   for (int i = 0; i < N_RANDOM; i++) begin
//     logic [BW-1:0] n, d;
//     n = $urandom;
//     d = ($urandom % 256) + 1;
//     run_test(n, d, n / d, n % d, $sformatf("rand_small_%0d", i));
//   end

  $display("==================================");
  $display("PASSED: %0d  FAILED: %0d", pass_count, fail_count);
  if (fail_count == 0) $display("ALL TESTS PASSED");
  $display("==================================");
  $finish;
end



endmodule