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
    logic [31:0] imm;

    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] wdata;
    logic reg_wr;

    logic [31:0] mux_out_a;
    logic [31:0] mux_out_b;
    logic [31:0] opr_res;
    logic sel_A;
    logic sel_B;
    logic [3:0] aluop;

    logic [1:0] br_taken;
    logic [2:0] br_type;

    logic [31:0] rdata;
    logic rd_en, wr_en;
    logic [1:0] wb_sel;

    //Instance for Program Counter MUX
    pc_mux pc_mux
    (
        .pc_out   (pc_out),
        .opr_res  (opr_res),
        .br_taken (br_taken),
        .pc_in (pc_in)
    );

    //Instance for Program Counter
    pc pc_inst
    (
        .clk   (clk),
        .rst   (rst),
        .pc_in (pc_in),
        .pc_out (pc_out)
    );

    //Instance for Instruction Memory
    inst_mem imem
    (
        .addr(pc_out),
        .data(inst)
    );

    //Instance for Instruction Decoder, Note that the module of Immediate generator is combined with the decoder
    inst_dec inst_instance
    (
        .inst    (inst),
        .rs1     (rs1),
        .rs2     (rs2),
        .rd      (rd),
        .opcode  (opcode),
        .func3   (func3),
        .imm(imm),
        .func7   (func7)
    );

    //Instance for Register File
    reg_file reg_file_inst
    (
        .raddr1(rs1),
        .raddr2(rs2),
        .waddr(rd),
        .reg_wr(reg_wr),
        .clk(clk),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .wdata(wdata)
    );

    //Instance for ALU MUX A
    alu_mux_a alu_mux_a
    (
        .rdata1(rdata1),
        .pc_out(pc_out),
        .sel_A(sel_A),
        .mux_out_a(mux_out_a)
    );

    //Instance for ALU MUX B
    alu_mux_b alu_mux_b
    (
        .rdata2(rdata2),
        .imm(imm),
        .sel_B(sel_B),
        .mux_out_b(mux_out_b)
    );

    //Instance for ALU
    alu alu_inst
    (
        .opr_a(mux_out_a),
        .opr_b(mux_out_b),
        .aluop(aluop),
        .opr_res(opr_res)
    );

    branch_condition br_cndtn
    (
        .rdata1(rdata1),
        .rdata2(rdata2),
        .br_type(br_type),
        .br_taken(br_taken)
    );

    //Instance for Data Memory
    data_mem data_mem_inst (
        .clk(clk),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .addr(opr_res),
        .wdata(rdata2),
        .rdata(rdata),
        .func3(func3) 
    );

    //Instance for Write Back MUX
    wb_mux wb_mux (
        .opr_res(opr_res),
        .rdata(rdata),
        .wb_sel(wb_sel),
        .wdata(wdata),
        .pc_out(pc_out)
    );

    //Instance for Controller
    controller contr_inst
    (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .reg_wr(reg_wr),
        .aluop(aluop),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .sel_A(sel_A),
        .sel_B(sel_B),
        .wb_sel(wb_sel),
        .br_type(br_type)
    );

endmodule