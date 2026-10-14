//FP Divider Module - FA26

module fp_divider #(
    parameter MANT = 23,
    parameter EXP  = 8
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
    logic [2*MANT:0] mant_out; //changed

    logic [MANT:0]   sig_0, sig_1;

    //Exponents
    logic [EXP-1:0] exp_0;
    logic [EXP-1:0] exp_1;
    logic [EXP-1:0] exp_out;

    //Intermediate signals
    logic [EXP-1:0] exp_diff;


    localparam int BIAS = (1 << (EXP -1)) - 1;

    localparam NORM = MANT;

    assign sign_a = in0[EXP+MANT];
    assign sign_b = in1[EXP+MANT];

    assign exp_0 = in0[EXP+MANT-1:MANT];
    assign exp_1 = in1[EXP+MANT-1:MANT];

    assign mant_0 = in0[MANT-1:0];
    assign mant_1 = in1[MANT-1:0];

    //changed
    assign sig_0 = {1'b1, mant_0};
    assign sig_1 = {1'b1, mant_1};
    
    always_comb begin

        if(mant_0 == '0 && exp_0 == '0) begin
            sign_out = 1'b0;
            mant_out = '0;
            exp_out = '0;
        end
        else begin
            if(sign_a ^ sign_b) begin
            sign_out = 1'b1;
            end
            else begin
                sign_out = 1'b0;
            end


            if(exp_0 > exp_1) begin
                exp_diff = exp_0 - exp_1;
                exp_out = BIAS + exp_diff;
            end
            else begin
                exp_diff = exp_1 - exp_0;
                exp_out = BIAS - exp_diff;
            end

            //changed
            mant_out = (sig_0 << MANT) / sig_1;
            
            //normalization
            if(mant_out[MANT] == 0) begin
                for(int i = 0; i < MANT; i = i + 1) begin
                    if(mant_out[MANT] == 0)begin
                        mant_out = mant_out << 1;
                        exp_out = exp_out - 1;
                    end
                end
            end
            
        end
    end

        

assign out = {sign_out, exp_out, mant_out[MANT-1:0]};

endmodule