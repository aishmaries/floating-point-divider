// Integer divider module using radix-2 non restoring integer division

module int_divider #(
    parameter BW = 32
) (
    input logic signed [BW-1:0] in0,
    input logic signed [BW-1:0] in1,
    output logic signed [BW-1:0] out
);

    logic signed [BW:0] divisor;
    logic signed [BW:0] remainder;
    logic signed [BW:0] quotient;
    logic done = 1'b0;

    always_comb begin
        //divisor = {1'b0, in1[BW-2:0]};
        divisor = in1[BW-1] ? -{{1'b1}, in1} : {{1'b0}, in1};
        remainder = {{in0[BW-1]}, in0};
        quotient = '0;

        for(int i = BW - 1; i >= 0; i--)begin
            if(remainder == '0) begin
                if(!done) begin //replacement for a break
                    quotient = {~quotient[BW-1], quotient[BW-2:0], 1'b1};
                end
                quotient[i] = 1'b0;
                quotient = quotient;
                remainder = '0;
                done = 1'b1;
            end else begin
                if(remainder < 0) begin
                    quotient[i] = 1'b0;
                    remainder = remainder + (divisor << i);
                end
                else begin
                    quotient[i] = 1'b1;
                    remainder = remainder - (divisor << i);
                end
            end
        end
        
        

        if(!done) begin

            quotient = {~quotient[BW-1], quotient[BW-2:0], 1'b1}; //probably the mistake

            if(!in0[BW-1] && remainder < 0) begin
                remainder = remainder + divisor;
                quotient = quotient - 1'b1;
            end
            else if(in0[BW-1] && remainder > 0) begin
                remainder = remainder - divisor;
                quotient = quotient + 1'b1;
            end
            else begin
                remainder = remainder;
            end
        end
        
        if(in1[BW-1]) begin
            out = ~(quotient[BW-1:0]) + 1;
        end
        else begin
            out = quotient;
        end
    end

endmodule