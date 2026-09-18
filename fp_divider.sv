//FP Divider Module - FA26

module fp_divider #(
    parameter MANT,
    parameter EXP
) (
    input  logic [MANT+EXP:0] in0,
    input  logic [MANT+EXP:0] in1,
    output logic [MANT+EXP:0] out
);
    //Sign bits
    logic sign_a;
    logic sign_b;
    logic sign_out;

    //Mantissas
    logic [MANT-1:0] mant_0;
    logic [MANT-1:0] mant_1;
    logic [MANT-1:0] mant_out;

    //Exponents
    logic [EXP-1:0] exp_0;
    logic [EXP-1:0] exp_1;
    logic [EXP-1:0] exp_out;

    //Intermediate signals
    logic [EXP-1:0] exp_diff;


    localparam int BIAS = (1 << (EXP -1)) - 1;

    assign sign_a = in0[EXP+MANT];
    assign sign_b = in1[EXP+MANT];

    assign exp_0 = in0[EXP+MANT-1:MANT];
    assign exp_1 = in1[EXP+MANT-1:MANT];

    assign mant_0 = in0[MANT-1:0];
    assign mant_1 = in1[MANT-1:0];
    
    always_comb() {

        if(sign_a ^ sign_b) begin
            sign_out = 1'b1;
        end
        else begin
            sign_out = 1'b0;
        end


        if(exp0 > exp1) begin
            exp_diff = exp0 - exp1;
            exp_out = BIAS - exp_diff;
        end
        else begin
            exp_diff = exp1 - exp0;
            exp_out = BIAS + exp_diff;
        end

        mant_out = mant_b / mant_a;
        
        //normalization
        //could use a while loop since the path is too long with for loop,
        //but not sure if while creates a combinational feedback loop
        //may not be neccesary to have a loop
        if(mant_out[MANT] == 0) begin
            for(i = 0; i < MANT; i = i + 1) begin
                if(mant_out[MANT] == 0)begin
                    mant_out = mant_out << 1;
                    exp_out = exp_out - 1;
                end
            end
        end
        
    }
    

endmodule