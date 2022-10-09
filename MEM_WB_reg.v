module MEMWBreg(
           clk_i,
           rst_n,
           RegWrite_MEM,
           RegWrite_WB,
           MemtoReg_MEM,
           MemtoReg_WB,
           RDaddr_MEM,
           RDaddr_WB,
           Mem_Readdata_MEM,
           Mem_Readdata_WB,
           FUResult_MEM,
           FUResult_WB
       );
input clk_i;
input rst_n;
input RegWrite_MEM;
input MemtoReg_MEM;
input [2:0] RDaddr_MEM;
input [15:0] Mem_Readdata_MEM;
input [15:0] FUResult_MEM;


output reg RegWrite_WB;
output reg MemtoReg_WB;
output reg [2:0] RDaddr_WB;
output reg [15:0] Mem_Readdata_WB;
output reg [15:0] FUResult_WB;




always@(posedge clk_i or negedge rst_n)
begin
    if(!rst_n)
    begin
        RegWrite_WB <= 1'b0;
        MemtoReg_WB <= 1'b0;
        RDaddr_WB <= 3'b0;
        Mem_Readdata_WB <= 16'b0;
        FUResult_WB <= 16'b0;

    end

    else
    begin
        RegWrite_WB <= RegWrite_MEM;
        MemtoReg_WB <= MemtoReg_MEM;
        RDaddr_WB <= RDaddr_MEM;
        Mem_Readdata_WB <= Mem_Readdata_MEM;
        FUResult_WB <= FUResult_MEM;

    end

end

endmodule
