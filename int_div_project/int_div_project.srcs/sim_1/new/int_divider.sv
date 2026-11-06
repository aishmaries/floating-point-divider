`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2026 09:26:34 PM
// Design Name: 
// Module Name: int_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module int_divider(
    input [31:0] in0,
    input [31:0] in1,
    input clk,
    output [31:0] quotient,
    output [31:0] remainder
    );
    logic [31:0] in0_tmp;
    logic [31:0] in1_tmp;
    logic [31:0] quotient_tmp;
    logic [31:0] remainder_tmp;
    
    int_divider_alt u0(
        .numerator(in0_tmp),
        .denominator(in1_tmp),
        .quotient(quotient_tmp),
        .remainder(remainder_tmp)
    );
    
    always_ff @(posedge clk) begin
        in0_tmp <= in0;
        in1_tmp <= in1;
        quotient_tmp <= quotient;
        remainder_tmp <= remainder;
    end
    
    
endmodule
