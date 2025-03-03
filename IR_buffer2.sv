module IR_buffer2
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] IRbuffer1_out,
    output logic [31:0] IRbuffer2_out
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            IRbuffer2_out <= 32'b0;
        else
            IRbuffer2_out <= IRbuffer1_out;
    end
endmodule