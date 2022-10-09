module IDEXreg(
           clk_i,
           rst_n,
           PC_in_ID,
           PC_out_EX,
           RegWrite_ID,
           RegWrite_EX,
           MemtoReg_ID,
           MemtoReg_EX,
           MemRead_ID,
           MemRead_EX,
           MemWrite_ID,
           MemWrite_EX,
           Branch_ID,
           Branch_EX,
           BranchType_ID,
           BranchType_EX,
           ALUOp_ID,
           ALUOp_EX,
           ALUSrc_ID,
           ALUSrc_EX,
           Jump_ID,
           Jump_EX,
           RegDst_ID,
           RegDst_EX,
           rsdata_ID,
           rsdata_EX,
           rtdata_ID,
           rtdata_EX,
           ZeroFilled_ID,
           ZeroFilled_EX,
           SignExtend_ID,
           SignExtend_EX,
           rsaddr_ID,
           rsaddr_EX,
           rtaddr_ID,
           rtaddr_EX,
           rdaddr_ID,
           rdaddr_EX,
           funct_ID,
           funct_EX,
           IDEXflush
       );
input clk_i;
input rst_n;
input [15:0] PC_in_ID;
input RegWrite_ID;
input    MemtoReg_ID;
input     MemRead_ID;
input   MemWrite_ID;
input     Branch_ID;
input     BranchType_ID;
input  [1:0] ALUOp_ID;
input   ALUSrc_ID;
input   Jump_ID;
input    RegDst_ID;
input [15:0]   rsdata_ID;
input  [15:0]  rtdata_ID;
input [15:0]    ZeroFilled_ID;
input [15:0]    SignExtend_ID;
input [2:0]    rsaddr_ID;
input [2:0]    rtaddr_ID;
input [2:0]    rdaddr_ID;
input [3:0]   funct_ID;
input   IDEXflush;


output reg [15:0] PC_out_EX;
output reg RegWrite_EX;
output  reg   MemtoReg_EX;
output   reg   MemRead_EX;
output  reg  MemWrite_EX;
output  reg    Branch_EX;
output  reg    BranchType_EX;
output reg  [1:0] ALUOp_EX;
output  reg  ALUSrc_EX;
output  reg  Jump_EX;
output reg    RegDst_EX;
output reg  [15:0]   rsdata_EX;
output reg  [15:0]  rtdata_EX;
output  reg [15:0]    ZeroFilled_EX;
output reg [15:0]    SignExtend_EX;
output reg [2:0]    rsaddr_EX;
output reg [2:0]    rtaddr_EX;
output reg [2:0]    rdaddr_EX;
output reg [3:0]   funct_EX;



always@(posedge clk_i or negedge rst_n)
begin
    if(!rst_n | IDEXflush)
    begin
        PC_out_EX <= 16'b0;
        RegWrite_EX <= 1'b0;
        MemtoReg_EX <= 1'b0;
        MemRead_EX <= 1'b0;
        MemWrite_EX <= 1'b0;
        Branch_EX <= 1'b0;
        BranchType_EX <= 1'b0;
        ALUOp_EX <= 2'b0;
        ALUSrc_EX <= 1'b0;
        Jump_EX <= 1'b0;
        RegDst_EX <= 1'b0;
        rsdata_EX <= 16'b0;
        rtdata_EX <= 16'b0;
        ZeroFilled_EX <= 16'b0;
        SignExtend_EX <= 16'b0;
        rsaddr_EX <= 3'b0;
        rtaddr_EX <= 3'b0;
        rdaddr_EX <= 3'b0;
        funct_EX <= 4'b0;
    end

    else
    begin
        PC_out_EX <= PC_in_ID;
        RegWrite_EX <= RegWrite_ID;
        MemtoReg_EX <= MemtoReg_ID;
        MemRead_EX <= MemRead_ID;
        MemWrite_EX <=  MemWrite_ID;
        Branch_EX <= Branch_ID;
        BranchType_EX <= BranchType_ID;
        ALUOp_EX <= ALUOp_ID;
        ALUSrc_EX <= ALUSrc_ID;
        Jump_EX <= Jump_ID;
        RegDst_EX <= RegDst_ID;
        rsdata_EX <= rsdata_ID;
        rtdata_EX <= rtdata_ID;
        ZeroFilled_EX <= ZeroFilled_ID;
        SignExtend_EX <= SignExtend_ID;
        rsaddr_EX <= rsaddr_ID;
        rtaddr_EX <= rtaddr_ID;
        rdaddr_EX <= rdaddr_ID;
        funct_EX <= funct_ID;
    end
end

endmodule
