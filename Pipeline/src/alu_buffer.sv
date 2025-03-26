module alu_buffer1
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] opr_res,
    output logic [31:0] alubuffer1_out
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            alubuffer1_out <= 32'b0;
        else
            alubuffer1_out <= opr_res;
    end
endmodule