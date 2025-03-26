module inst_mem
(
    input  logic [31:0] addr,
    output logic [31:0] data
);

    logic [31:0] mem [100];

    always_comb
    begin
        data=mem[addr[31:2]]; //Creating a word addressible memory (PC +4)
    end

endmodule