module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Branch_o, BranchType_o, MemToReg_o, MemRead_o, MemWrite_o, Jump_o);

//I/O ports
input	[3-1:0] instr_op_i;


output			RegWrite_o;
output	[2-1:0] ALUOp_o;
output			ALUSrc_o;
output	    	RegDst_o;
output			Branch_o;
output			BranchType_o;
output			MemToReg_o;
output			MemRead_o;
output			MemWrite_o;
output			Jump_o;

//Internal Signals
wire			RegWrite_o;
wire	[2-1:0] ALUOp_o;
wire			ALUSrc_o;
wire	    	RegDst_o;
wire			Branch_o;
wire			BranchType_o;
wire			MemToReg_o;
wire			MemRead_o;
wire			MemWrite_o;
wire			Jump_o;

//Main function
/*your code here*/
reg [1:0] ALUOp;
reg regwrite;
reg alusrc;
reg regdst;
reg branch;
reg branch_type;
reg jump;
reg memread;
reg memwrite;
reg memtoreg;




always@(*)
begin
    case(instr_op_i)

        3'b000:
        begin //R-type
            ALUOp = 2'b10;
            regwrite = 1'b1;
            alusrc = 1'b0;
            regdst = 1'b1;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end

        3'b001:
        begin //I-type addi
            ALUOp = 2'b00;
            regwrite = 1'b1;
            alusrc = 1'b1;
            regdst = 1'b0;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end

        3'b010:
        begin //I-type lui
            ALUOp = 2'b11;
            regwrite = 1'b1;
            alusrc = 1'b0;
            regdst = 1'b0;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end

        3'b011:
        begin //I-type lw
            ALUOp = 2'b00;
            regwrite = 1'b1;
            alusrc = 1'b1;
            regdst = 1'b0;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b1;
            memwrite = 1'b0;
            memtoreg = 1'b1;
        end

        3'b100:
        begin //I-type sw
            ALUOp = 2'b00;
            regwrite = 1'b0;
            alusrc = 1'b1;
            regdst = 1'b0;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b1;
            memtoreg = 1'b0;
        end

        3'b101:
        begin //I-type beq
            ALUOp = 2'b01;
            regwrite = 1'b0;
            alusrc = 1'b0;
            regdst = 1'b0;
            branch = 1'b1;
            branch_type = 1'b0;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end

        3'b110:
        begin //I-type bne
            ALUOp = 2'b01;
            regwrite = 1'b0;
            alusrc = 1'b0;
            regdst = 1'b0;
            branch = 1'b1;
            branch_type = 1'b1;
            jump = 1'b0;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end

        3'b111:
        begin //J-type jump
            ALUOp = 2'b00;
            regwrite = 1'b0;
            alusrc = 1'b0;
            regdst = 1'b0;
            branch = 1'b0;
            branch_type = 1'b0;
            jump = 1'b1;
            memread = 1'b0;
            memwrite = 1'b0;
            memtoreg = 1'b0;
        end
    endcase
end

assign RegWrite_o = regwrite;
assign ALUOp_o = ALUOp;
assign ALUSrc_o = alusrc;
assign RegDst_o = regdst;
assign Branch_o = branch;
assign BranchType_o = branch_type;
assign Jump_o = jump;
assign MemRead_o = memread;
assign MemWrite_o = memwrite;
assign MemToReg_o = memtoreg;

endmodule
