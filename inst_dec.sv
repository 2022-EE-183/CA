module inst_dec
(
    input  logic [31:0] inst,
    output logic [ 6:0] opcode,
    output logic [ 2:0] func3,
    output logic [ 6:0] func7,
    output logic [ 4:0] rs1,
    output logic [ 4:0] rs2,
    output logic [ 4:0] rd
);
    // Assign the opcode fields
    assign opcode = inst[6 : 0];

    assign is_R_type = (opcode == 7'b0110011); 
    assign is_I_type = (opcode == 7'b0010011); 
    assign is_Iload_type = (opcode == 7'b0000011); 
    assign is_S_type = (opcode == 7'b0100011); 
    assign is_LUI = (opcode == 7'b0110111); 
    assign is_AUIPC = (opcode == 7'b0010111); 
    assign is_B_type = (opcode == 7'b1100011); 
    assign is_JAL = (opcode == 7'b1101111);   
    assign is_JALR = (opcode == 7'b1100111);

    // Assigning registers based on instruction type
    assign rs1    = (is_R_type || is_I_type || is_Iload_type || is_B_type || is_JALR || is_S_type) ? inst[19:15] : 5'b0; // rs1 is present in R, I, Iload types
    assign rs2    = (is_R_type || is_S_type || is_B_type) ? inst[24:20] : 5'b0; // rs2 is present in R and S types
    assign rd     = (is_R_type || is_I_type || is_Iload_type || is_LUI || is_AUIPC || is_JAL || is_JALR) ? inst[11:7] : 5'b0; // rd is present in R, I, Iload, LUI, AUIPC

    // Extract func7 for R-type instructions
    assign func7 = is_R_type ? inst[31:25] : 7'b0;  
    assign func3 = (is_R_type || is_I_type || is_Iload_type || is_JALR || is_B_type || is_S_type) ? inst[14:12] : 3'b0;
   
endmodule