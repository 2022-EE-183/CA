module IR_buffer1
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] inst,// Input from the main IR
    output logic [31:0] IRbuffer1_out// Output to Decode stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            IRbuffer1_out <= 32'b0;
        else
            IRbuffer1_out <= inst;// Pass IR to Decode stage
    end
endmodule