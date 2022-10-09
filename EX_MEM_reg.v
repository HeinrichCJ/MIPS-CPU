module EXMEMreg(
           clk_i,
           rst_n,
           RegWrite_EX, //Decoder
           RegWrite_MEM,
           MemtoReg_EX,
           MemtoReg_MEM,
           MemRead_EX,
           MemRead_MEM,
           MemWrite_EX,
           MemWrite_MEM,
           RDaddr_EX,
           RDaddr_MEM,
           FUResult_EX,
           FUResult_MEM,
           rtdata_EX,
           rtdata_MEM,
       );
input clk_i;
input rst_n;
input RegWrite_EX;
input MemtoReg_EX;
input MemRead_EX;
input MemWrite_EX;
input [2:0] RDaddr_EX;
input [15:0] FUResult_EX;
input [15:0] rtdata_EX;


output reg RegWrite_MEM;
output reg MemtoReg_MEM;
output reg MemRead_MEM;
output reg MemWrite_MEM;
output reg [2:0] RDaddr_MEM;
output reg [15:0] FUResult_MEM;
output reg [15:0] rtdata_MEM;




always@(posedge clk_i or negedge rst_n)
begin
    if(!rst_n)
    begin
        RegWrite_MEM <= 1'b0;
        MemtoReg_MEM <= 1'b0;
        MemRead_MEM <= 1'b0;
        MemWrite_MEM <= 1'b0;
        RDaddr_MEM <= 3'b0;
        FUResult_MEM <= 16'b0;
        rtdata_MEM <= 16'b0;
    end

    else
    begin
        RegWrite_MEM <= RegWrite_EX;
        MemtoReg_MEM <= MemtoReg_EX;
        MemRead_MEM <= MemRead_EX;
        MemWrite_MEM <= MemWrite_EX;
        RDaddr_MEM <= RDaddr_EX;
        FUResult_MEM <= FUResult_EX;
        rtdata_MEM <= rtdata_EX;
    end

end

endmodule
