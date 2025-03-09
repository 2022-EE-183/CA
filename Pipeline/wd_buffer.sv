module WD_buffer
(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] fwd_mux_out, // from forwarding mux
    output logic [31:0] WDbuffer_out // to memory stage
);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            WDbuffer_out <= 32'b0;        
        else
            WDbuffer_out <= fwd_mux_out;
    end
endmodule