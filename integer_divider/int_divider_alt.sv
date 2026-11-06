// Integer divider module using radix-2 non restoring integer division

module int_divider_alt #(
    parameter BW = 32
) (
    input logic  [BW-1:0] numerator,
    input logic  [BW-1:0] denominator,
    output logic [BW-1:0] remainder,
    output logic [BW-1:0] quotient
);

    logic signed [2*BW:0] remainder_temp[BW:0];
    logic [BW-1:0] quotient_temp;
    logic signed [2*BW:0] denominator_temp;

    logic [BW-1:0] p;
    logic [BW-1:0] m;
    logic [BW-1:0] q;
    logic signed [2*BW-1:0] r;

    always_comb begin
        remainder_temp[BW] = numerator;
        denominator_temp = denominator << BW;

        for(int i = BW - 1; i >= 0; i--)begin
            if(remainder_temp[i + 1] >= 'sd0) begin
                remainder_temp[i] = (2 * remainder_temp[i+1]) - denominator_temp;
                quotient_temp[i] = 1'b1;
            end
            else begin
                remainder_temp[i] = (2 * remainder_temp[i+1]) + denominator_temp;
                quotient_temp[i] = 1'b0;
            end
        end
        
        p = quotient_temp;
        m = ~quotient_temp;
        q = p - m;

        if(remainder_temp[0] < 'sd0) begin
            quotient = q - 'd1;
            r = remainder_temp[0] + denominator_temp;
        end
        else begin
            quotient = q;
            r = remainder_temp[0];
        end

        remainder = r >> BW;
        
    end
        

endmodule