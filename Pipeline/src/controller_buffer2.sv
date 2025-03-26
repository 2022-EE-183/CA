module controller_buffer2
(
    input  logic        clk,
    input  logic        rst,

    input logic rd_enb1,   
    input logic wr_enb1,   
    input logic [1:0] wb_selb1,
    input logic rf_enb1,
    
    output logic rd_enb2,   
    output logic wr_enb2,   
    output logic [1:0] wb_selb2,
    output logic rf_enb2
    );
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst) begin
            rd_enb2 <= 0;
            wr_enb2 <= 0;
            rf_enb2 <= 0;
           
        end else begin
            rd_enb2 <= rd_enb1;         
            wr_enb2 <= wr_enb1;
            rf_enb2 <= rf_enb1;
            wb_selb2 <= wb_selb1;
        end 
    end
endmodule