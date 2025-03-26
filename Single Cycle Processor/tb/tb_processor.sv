module tb_processor();
    logic clk;
    logic rst;

    // Processor DUT instantiation
    processor dut
    (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generator
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Reset Generator
    initial begin
        rst = 1;
        #10;
        rst = 0;
        #1000000;
        $finish;
    end

    // Initializing Instruction, Register File, and Data Memories
    initial begin
        $readmemh("instruction_memory", dut.imem.mem);
        $readmemb("register_file", dut.reg_file_inst.reg_mem);
        $readmemb("data_memory", dut.data_mem_inst.mem); // Initialize data memory
       // $display("Data stored at address %h: %h", dut.data_mem_inst.addr, dut.data_mem_inst.mem[dut.data_mem_inst.addr[31:0]]);
    end

    // Dumping the simulation results
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, tb_processor);
    end

endmodule
