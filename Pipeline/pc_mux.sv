module PC_MUX
(
    input  logic [31:0] pc_out,        
    input  logic [31:0] opr_res,    
    input  logic        br_taken,
    input  logic is_JAL,
    input logic is_JALR,     
    output logic [31:0] pc_in 
);

    always_comb
    begin
        
        if (br_taken || is_JAL) 
            pc_in = opr_res;      // If branch is taken, use ALU output (branch target)

        else if(is_JALR)
            pc_in = (opr_res & ~32'b1);
        else 
            pc_in = pc_out + 32'd4;   // If branch is not taken, use PC + 4
    end

endmodule
