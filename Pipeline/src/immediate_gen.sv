module immediate_gen
(
    input  logic [31:0] inst,
    input  logic        is_LUI, 
    input  logic        is_AUIPC,
    input  logic        is_I_type,
    input  logic        is_S_type,
    input  logic        is_Iload_type,
    input  logic        is_B_type,
    input  logic        is_JAL,
    input  logic        is_JALR,
    output logic [31:0] imm_to_mux
);
    logic [11:0] immediate;
    logic [19:0] imm_20;

    assign immediate = is_S_type ? {inst[31:25], inst[11:7]} : is_B_type ? {inst[31],inst[7],inst[30:25], inst[11:8]} : (is_I_type || is_Iload_type || is_JALR) ? inst[31:20] : 12'b0;

    assign imm_20 = is_JAL ? {inst[31],inst[19:12],inst[20],inst[30:21]} : (is_LUI || is_AUIPC) ? inst[31:12] : 20'b0;

    always_comb begin
        if (is_I_type || is_Iload_type || is_JALR || is_S_type || is_B_type) begin
            if (is_B_type) begin
            imm_to_mux = {{19{immediate[11]}}, immediate, 1'b0}; 
            end 
            else begin
            imm_to_mux = {{20{immediate[11]}}, immediate};
            end
        end
        else if (is_JAL) begin
            imm_to_mux = {{11{imm_20[19]}}, imm_20, 1'b0};
        end
        else if (is_LUI || is_AUIPC) begin
            imm_to_mux = {imm_20, 12'b0};
        end
        else begin
            imm_to_mux = 32'b0;  
        end
    end

endmodule