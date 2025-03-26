module processor
(
    input  logic clk,
    input  logic rst
);
    logic [31:0] pc_out;
    logic [31:0] pc_in;
    logic [31:0] inst;

    logic [ 6:0] opcode;
    logic [ 2:0] func3;
    logic [ 6:0] func7;
    logic [ 4:0] rs1;
    logic [ 4:0] rs2;
    logic [ 4:0] rd;

    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] wdata;

    logic [31:0] MUX_output;
    logic [31:0] mux_out_a;
    logic [31:0] opr_res;

    logic [31:0] rdata3;
    logic rd_en,wr_en;
    logic [31:0] wdata2;
    
    logic [2:0] br_type;
    logic        br_taken;
    logic        rf_en;
    logic [3:0] aluop;
    logic [1:0] wb_sel;
    logic        is_I_type;
    logic        is_AUIPC;
    logic        is_LUI;
    logic        is_R_type;
    logic        is_S_type;
    logic        is_Iload_type;
    logic        is_B_type;
    logic        is_JAL;
    logic        is_JALR;

    logic [31:0] imm_to_mux;

    //signals for buffers
    logic [31:0] pcbuffer1_out;
    logic [31:0] pcbuffer2_out;
    logic [31:0] WDbuffer_out;
    logic [31:0] alubuffer1_out;
    logic [31:0] IRbuffer1_out;
    logic [31:0] IRbuffer2_out;

    //signals for controller buffer2
    logic rd_enb2;  
    logic wr_enb2;  
    logic [1:0] wb_selb2;
    logic rf_enb2;

    //signals for forward muxs
    logic [31:0] fwd_mux_b_out;
    logic [31:0] fwd_mux_a_out;
    logic fwd_sela;
    logic fwd_selb;


    pc pc_inst
    (
        .clk   (clk),
        .rst   (rst),
        .pc_in (pc_in),
        .pc_out (pc_out)
    );

    pc_buffer_fetch pc_buffer1
    (
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),            
        .pcbuffer1_out(pcbuffer1_out)
    );

    pc_buffer_decode pc_buffer2 (
        .clk(clk),
        .rst(rst),
        .pcbuffer1_out(pcbuffer1_out),   
        .pcbuffer2_out(pcbuffer2_out)  
    );

    inst_mem imem
    (
        .addr(pc_out),
        .data(inst)
    );

    IR_buffer1 ir_buffer1
    (
        .clk   (clk),
        .rst   (rst),
        .inst  (inst),
        .IRbuffer1_out(IRbuffer1_out)
    );

    IR_buffer2 ir_buffer2
    (
        .clk   (clk),
        .rst   (rst),
        .IRbuffer1_out(IRbuffer1_out),
        .IRbuffer2_out(IRbuffer2_out)
    );


    inst_dec inst_instance
    (
        .inst    (IRbuffer1_out),
        .rs1     (rs1),
        .rs2     (rs2),
        .opcode  (opcode),
        .func3   (func3),
        .func7   (func7)
    );

    immediate_gen imm_gen
    (
        .inst(IRbuffer1_out),
        .imm_to_mux(imm_to_mux),
        .is_AUIPC(is_AUIPC),
        .is_LUI(is_LUI),
        .is_S_type(is_S_type),
        .is_Iload_type(is_Iload_type),
        .is_I_type(is_I_type),
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),
        .is_JALR(is_JALR)
    );

    //Register File
    reg_file reg_file_inst
    (
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .rf_en(rf_enb2),
        .clk(clk),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .wdata(wdata)
    );

    //Controller
    controller contr_inst
    (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .rf_en(rf_en),
        .aluop(aluop),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .wb_sel(wb_sel),
        .is_AUIPC(is_AUIPC),
        .is_LUI(is_LUI),
        .is_R_type(is_R_type),
        .is_S_type(is_S_type),
        .is_Iload_type(is_Iload_type),
        .is_I_type(is_I_type),
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),
        .is_JALR(is_JALR),
        .br_type(br_type)
    );

    controller_buffer2 contb2
    (
        .clk(clk),
        .rst(rst),
        .rd_enb1(rd_en),   
        .wr_enb1(wr_en),   
        .wb_selb1(wb_sel),
        .rf_enb1(rf_en),
        .rd_enb2(rd_enb2),   
        .wr_enb2(wr_enb2),   
        .wb_selb2(wb_selb2),
        .rf_enb2(rf_enb2)
    );


    // ALU Mux for selecting between rdata2 and imm_to_mux)
    MUX_to_ALU alu_mux
    (
        .rdata2(fwd_mux_b_out),
        .imm_to_mux(imm_to_mux),
        .is_R_type(is_R_type),
        .MUX_output(MUX_output)
    );
     MUX_to_ALUa alu_mux_a
    (
        .rdata1(fwd_mux_a_out),      // Register file data 1
        .pc_out(pcbuffer2_out),      // Program Counter output
        .is_LUI(is_LUI),
        .is_AUIPC(is_AUIPC),  
        .is_B_type(is_B_type),
        .is_JAL(is_JAL),   
        .mux_out_a(mux_out_a)  
    );

     PC_MUX pc_mux
    (
        .pc_out   (pc_out),
        .opr_res  (alubuffer1_out),
        .br_taken (br_taken),
        .is_JAL (is_JAL),
        .is_JALR (is_JALR),
        .pc_in (pc_in)
    );

    alu alu_inst
    (
        .opr_a(mux_out_a),
        .opr_b(MUX_output),
        .aluop(aluop),
        .opr_res(opr_res)
    );

    alu_buffer1 Alu_buffer1
    (
        .clk(clk),
        .rst(rst),
        .opr_res(opr_res),          
        .alubuffer1_out(alubuffer1_out)
    );

    branch_condition br_cndtn
    (
        .rdata1(fwd_mux_a_out),
        .rdata2(fwd_mux_b_out),
        .br_type(br_type),
        .br_taken(br_taken)

    );

    // Data Memory
    data_mem data_mem_inst (
        .clk(clk),
        .rd_en(rd_enb2),
        .wr_en(wr_enb2),
        .addr(alubuffer1_out),
        .wdata2(WDbuffer_out),
        .rdata3(rdata3),
        .func3(func3) 
    );

    WD_buffer wd_buffer
    (
        .clk(clk),
        .rst(rst),
        .fwd_mux_out(fwd_mux_b_out),          
        .WDbuffer_out(WDbuffer_out)
    );

    MUX_write_back wb_mux (
        .opr_res(alubuffer1_out),
        .rdata3(rdata3),
        .wb_sel(wb_selb2),
        .wdata(wdata),
        .pc_out(pcbuffer2_out)
    );

    fwd_mux_a fwd_mux_a (
        .rdata1(rdata1),
        .wb_data(wdata),
        .fwd_sela(fwd_sela),
        .out(fwd_mux_a_out)
    );

    fwd_mux_b fwd_mux_b (
        .rdata2(rdata2),
        .wb_data(wdata),
        .fwd_selb(fwd_selb),
        .out(fwd_mux_b_out)
    );

    fwd_unit fwd_unit (
        .IRbuffer1_out(IRbuffer1_out),
        .IRbuffer2_out(IRbuffer2_out),
        .fwd_sela(fwd_sela),
        .fwd_selb(fwd_selb)
    );
endmodule
