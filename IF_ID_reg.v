module IFIDreg (
           clk_i,
           rst_n,
           IFIDwrite_i,
           next_PC_i,
           next_PC_o,
           instr_i,
           IFIDflush_i,
           opcode_o, // instr[15:13]
           rsaddr_ID, // instr[12:10]
           rtaddr_ID, // instr[9:7]
           rdaddr_ID, // instr[6:4]
           funct_ID // instr[3:0]
       );

input clk_i;
input rst_n;
input regwrite;

input [15:0] next_PC_i;
input [15:0] instr_i;


input IFIDwrite_i;
input IFIDflush_i;

output reg [15:0] next_PC_o;
output reg [2:0] opcode_o;
output reg [2:0] rsaddr_ID;
output reg [2:0] rtaddr_ID;
output reg [2:0] rdaddr_ID;
output reg [3:0] funct_ID;


always@(posedge clk_i or negedge rst_n)
begin

    if(!rst_n | IFIDflush_i)
    begin
        next_PC_o <= 16'b0;
        opcode_o <= 3'b0;
        rsaddr_ID <= 3'b0;
        rtaddr_ID <= 3'b0;
        rdaddr_ID <= 3'b0;
        funct_ID <= 4'b0;
    end

    else if(IFIDwrite_i)
    begin
        next_PC_o <= next_PC_i;
        opcode_o <= instr_i[15:13];
        rsaddr_ID <= instr_i[12:10];
        rtaddr_ID <= instr_i[9:7];
        rdaddr_ID <= instr_i[6:4];
        funct_ID <= instr_i[3:0];
    end

    else
    begin
        next_PC_o <= next_PC_o;
        opcode_o <= opcode_o;
        rsaddr_ID <= rsaddr_ID;
        rtaddr_ID <= rtaddr_ID;
        rdaddr_ID <= rdaddr_ID;
        funct_ID <= funct_ID;
    end

end


endmodule
