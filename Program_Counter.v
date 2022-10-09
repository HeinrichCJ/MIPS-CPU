module Program_Counter( clk_i, rst_n, pc_in_i, pc_out_o, PC_write );

//I/O ports
input           clk_i;
input	        rst_n;
input  [16-1:0] pc_in_i;
input PC_write;
output [16-1:0] pc_out_o;

//Internal Signals
reg    [16-1:0] pc_out_o;

//Main function
always @(posedge clk_i)
begin
    if(~rst_n)
        pc_out_o <= 0;
    else if (PC_write)
        pc_out_o <= pc_in_i;

    else
    begin
        pc_out_o <= pc_out_o;
    end
end

endmodule
