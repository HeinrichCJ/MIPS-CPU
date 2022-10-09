module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [16-1:0] PC_in;
wire [16-1:0] PC_ReadAddress;
wire [16-1:0] PCadder1_sum;
wire [16-1:0] PCadder2_sum;
wire [16-1:0] Instruction;
wire  [3-1:0] RDaddr_EX;
wire [16-1:0] RDdata;
wire [16-1:0] RSdata;
wire [16-1:0] RTdata;



//AC
wire  [4-1:0] ALU_operation;
wire  [2-1:0] FUResult_Select;
wire [16-1:0] FUResult_EX;

//ALU

wire [16-1:0] ALU_src2;
wire Zero;
wire Overflow;
wire [16-1:0] ALU_result;



//branch
wire ZERO;
wire PCSrc;



//shifter
wire [16-1:0] Shifter_result;

//PC
wire [16-1:0] SE_shiftleft1;
wire [16-1:0] PC_branch;
wire [14-1:0] Jump_shiftleft1;
wire [16-1:0] PC_jump;

//module
//MUX 2-to-1 branch
Mux2to1 mux1(
            .data0_i(PCadder1_sum), //PC+2
            .data1_i(PCadder2_sum), // branch addr
            .select_i(PCSrc), //branch taken signal
            .data_o(PC_branch)
        );
//MUX 2-to-1 jump
Mux2to1 mux2(
            .data0_i(PC_branch),
            .data1_i(PC_jump), //jump addr
            .select_i(Jump_EX), //Jump signal
            .data_o(PC_in)
        );
wire PC_write;
Program_Counter PC(
                    .clk_i(clk_i),
                    .rst_n(rst_n),
                    .pc_in_i(PC_in) ,
                    .pc_out_o(PC_ReadAddress),
                    .PC_write(PC_write)
                );
assign PC_write = (DataHazard)? 1'b0 : 1'b1; // If DataHazard, keep the PC value.

// PC+2 next PC address
Adder adder_2(
          .src1_i(PC_ReadAddress),
          .src2_i(16'd2),
          .sum_o(PCadder1_sum)
      );

Instr_Memory IM(
                 .pc_addr_i(PC_ReadAddress),
                 .instr_o(Instruction)
             );

//ID stage signal
wire [15:0] PC_add_2_ID;
wire IFID_flush; // flush IFIDreg
wire IFIDwrite;
wire [2:0] opcode_ID;
wire [2:0] rsaddr_ID;
wire [2:0] rtaddr_ID;
wire [2:0] rdaddr_ID;
wire [3:0] funct_ID;

IFIDreg  IF_IDreg(
             .clk_i(clk_i),
             .rst_n(rst_n),
             .IFIDwrite_i(IFIDwrite),
             .next_PC_i(PCadder1_sum),
             .next_PC_o(PC_add_2_ID),
             .instr_i(Instruction),
             .IFIDflush_i(IFID_flush),
             .opcode_o(opcode_ID), // instr[15:13]
             .rsaddr_ID(rsaddr_ID), // instr[12:10]
             .rtaddr_ID(rtaddr_ID), // instr[9:7]
             .rdaddr_ID(rdaddr_ID), // instr[6:4]
             .funct_ID(funct_ID) // instr[3:0]

         );
assign IFIDwrite = (DataHazard)? 1'b0 : 1'b1; // if Data Hazard, keep IFID regs not changing.
assign IFID_flush = ControlHazard; // If Control Hazard, flush IFID regs.

wire [15:0] rsdata_ID; //Data from RegFile
wire [15:0] rtdata_ID; //Data from RegFile

Reg_File RF(
             .clk_i(clk_i),
             .rst_n(rst_n) ,
             .RSaddr_i(rsaddr_ID) ,
             .RTaddr_i(rtaddr_ID) ,
             .RDaddr_i(RDaddr_WB) ,  //Write Back address [2:0]
             .RDdata_i(RDdata_WB)  , // Write Back Data [15:0]
             .RegWrite_i(RegWrite_WB), //Write Back Signal
             .RSdata_o(rsdata_ID) ,//Data from RegFile
             .RTdata_o(rtdata_ID)//Data from RegFile
         );

wire [6:0] instr_6_0 = {rdaddr_ID, funct_ID};

//Instruction[6:0] sign extend 16bits
wire [16-1:0] SignExtend_ID;
Sign_Extend se(
                .data_i(instr_6_0),
                .data_o(SignExtend_ID)
            );
//Zero Filled
//ZF
wire [16-1:0] ZeroFilled_ID;
Zero_Filled ZF(
                .data_i(instr_6_0),
                .data_o(ZeroFilled_ID)
            );
//Decoder_ID
wire 	        RegDst_ID;
wire 			RegWrite_ID;
wire	[2-1:0] ALUOp_ID;
wire	        ALUSrc_ID;
wire	        Branch_ID;
wire		MemtoReg_ID;
wire		BranchType_ID;
wire		Jump_ID;
wire		MemRead_ID;
wire		MemWrite_ID;
//Decoder

Decoder dec(
            .instr_op_i(opcode_ID),
            .RegWrite_o(RegWrite_ID),
            .MemToReg_o(MemtoReg_ID),
            .MemRead_o(MemRead_ID),
            .MemWrite_o(MemWrite_ID),
            .ALUOp_o(ALUOp_ID),
            .ALUSrc_o(ALUSrc_ID),
            .RegDst_o(RegDst_ID),
            .Branch_o(Branch_ID),
            .BranchType_o(BranchType_ID),
            .Jump_o(Jump_ID)
        );



wire DataHazard;
Data_Hazard DH(
                .rsaddr_ID(rsaddr_ID),
                .rtaddr_ID(rtaddr_ID),
                .RDaddr_EX(RDaddr_EX),
                .RDaddr_MEM(RDaddr_MEM),
                .RegWrite_EX(RegWrite_EX),
                .RegWrite_MEM(RegWrite_MEM),
                .DataHazard(DataHazard)
            );



wire [15:0] PC_out_EX;
wire RegWrite_EX;
wire MemtoReg_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire Branch_EX;
wire BranchType_EX;
wire [1:0] ALUOp_EX;
wire ALUSrc_EX;
wire Jump_EX;
wire RegDst_EX;
wire [15:0] rsdata_EX;
wire [15:0] rtdata_EX;
wire [15:0] ZeroFilled_EX;
wire [15:0] SignExtend_EX;
wire [2:0] rsaddr_EX;
wire [2:0] rtaddr_EX;
wire [2:0] rdaddr_EX;
wire [3:0] funct_EX;
wire IDEXflush;




IDEXreg IDEX_reg(
            .clk_i(clk_i),
            .rst_n(rst_n),
            .PC_in_ID(PC_add_2_ID),
            .PC_out_EX(PC_out_EX),
            .RegWrite_ID(RegWrite_ID),
            .RegWrite_EX(RegWrite_EX),
            .MemtoReg_ID(MemtoReg_ID),
            .MemtoReg_EX(MemtoReg_EX),
            .MemRead_ID(MemRead_ID),
            .MemRead_EX(MemRead_EX),
            .MemWrite_ID(MemWrite_ID),
            .MemWrite_EX(MemWrite_EX),
            .Branch_ID(Branch_ID),
            .Branch_EX(Branch_EX),
            .BranchType_ID(BranchType_ID),
            .BranchType_EX(BranchType_EX),
            .ALUOp_ID(ALUOp_ID),
            .ALUOp_EX(ALUOp_EX),
            .ALUSrc_ID(ALUSrc_ID),
            .ALUSrc_EX(ALUSrc_EX),
            .Jump_ID(Jump_ID),
            .Jump_EX(Jump_EX),
            .RegDst_ID(RegDst_ID),
            .RegDst_EX(RegDst_EX),
            .rsdata_ID(rsdata_ID),
            .rsdata_EX(rsdata_EX),
            .rtdata_ID(rtdata_ID),
            .rtdata_EX(rtdata_EX),
            .ZeroFilled_ID(ZeroFilled_ID),
            .ZeroFilled_EX(ZeroFilled_EX),
            .SignExtend_ID(SignExtend_ID),
            .SignExtend_EX(SignExtend_EX),
            .rsaddr_ID(rsaddr_ID), // instruction [12:10]
            .rsaddr_EX(rsaddr_EX),
            .rtaddr_ID(rtaddr_ID), // instruction [9:7]
            .rtaddr_EX(rtaddr_EX),
            .rdaddr_ID(rdaddr_ID),// instruction [6:4]
            .rdaddr_EX(rdaddr_EX),
            .funct_ID(funct_ID), // instruction [3:0]
            .funct_EX(funct_EX),
            .IDEXflush(IDEXflush)
        );
assign IDEXflush = DataHazard | ControlHazard; // If ControlHazard, flush IDEX.

//ALU Control
ALU_Ctrl AC(
             .funct_i(funct_EX),
             .ALUOp_i(ALUOp_EX),
             .ALU_operation_o(ALU_operation),
             .FURslt_o(FUResult_Select)
         );

assign ZERO = (BranchType_EX)? ~Zero : Zero;
assign PCSrc = Branch_EX & ZERO;

//MUX 2 to 1 before ALU
wire [15:0] ALU_Source2;
Mux2to1 MBALU(
            .data0_i(rtdata_EX),
            .data1_i(SignExtend_EX),
            .select_i(ALUSrc_EX),
            .data_o(ALU_Source2)
        );

//ALU
ALU alu_main(
        .aluSrc1(rsdata_EX),
        .aluSrc2(ALU_Source2),
        .ALU_operation_i(ALU_operation),
        .result(ALU_result),
        .zero(Zero),
        .overflow(Overflow)
    );
//Shifter
Shifter sf(
            .result(Shifter_result),
            .leftRight(ALU_operation[3]),
            .sftSrc(ALU_Source2)
        );

//MUX 3-to-1 FURslt
Mux3to1 mux4(
            .data0_i(ALU_result),
            .data1_i(Shifter_result),
            .data2_i(ZeroFilled_EX),
            .select_i(FUResult_Select),
            .data_o(FUResult_EX)
        );
//jump
wire [12:0] instr_12_0;
assign instr_12_0 = {rsaddr_EX, rtaddr_EX, rdaddr_EX, funct_EX};

Shift_Left_one_extend sl1e(
                          .data_i(instr_12_0),
                          .data_o(Jump_shiftleft1)
                      );
assign PC_jump = {PC_out_EX[15:14], Jump_shiftleft1}; //Jump address


//ins_se_16 sll
Shift_Left_one sl1(
                   .data_i(SignExtend_EX),
                   .data_o(SE_shiftleft1)
               );

//bne, beq address

Adder adder_sl1(
          .src1_i(PC_out_EX),
          .src2_i(SE_shiftleft1),
          .sum_o(PCadder2_sum) //branch_addr
      );

//Rt or Rd?

assign RDaddr_EX = (RegDst_EX)? rdaddr_EX : rtaddr_EX; //Write Register address "RDaddr_EX"

wire ControlHazard;
ControlHazard CH(
                  .PCSrc(PCSrc),
                  .Jump_EX(Jump_EX),
                  .ControlHazard(ControlHazard)
              );


wire RegWrite_MEM;
wire MemtoReg_MEM;
wire MemRead_MEM;
wire MemWrite_MEM;
wire [2:0] RDaddr_MEM;
wire [15:0] FUResult_MEM;
wire [15:0] rtdata_MEM;


EXMEMreg EXMEM_reg(
             .clk_i(clk_i),
             .rst_n(rst_n),
             .RegWrite_EX(RegWrite_EX), //Decoder
             .RegWrite_MEM(RegWrite_MEM),
             .MemtoReg_EX(MemtoReg_EX),
             .MemtoReg_MEM(MemtoReg_MEM),
             .MemRead_EX(MemRead_EX),
             .MemRead_MEM(MemRead_MEM),
             .MemWrite_EX(MemWrite_EX),
             .MemWrite_MEM(MemWrite_MEM),
             .RDaddr_EX(RDaddr_EX),
             .RDaddr_MEM(RDaddr_MEM),
             .FUResult_EX(FUResult_EX),
             .FUResult_MEM(FUResult_MEM),
             .rtdata_EX(rtdata_EX),
             .rtdata_MEM(rtdata_MEM)
         );


Data_Memory DM(
                .clk_i(clk_i),
                .addr_i(FUResult_MEM),
                .data_i(rtdata_MEM),
                .MemRead_i(MemRead_MEM),
                .MemWrite_i(MemWrite_MEM),
                .data_o(Mem_Readdata_MEM)
            );
wire [15:0] Mem_Readdata_MEM;
wire RegWrite_WB;
wire MemtoReg_WB;
wire [2:0] RDaddr_WB;
wire [15:0] Mem_Readdata_WB;
wire [15:0] FUResult_WB;


MEMWBreg MEMWB_reg(
             .clk_i(clk_i),
             .rst_n(rst_n),
             .RegWrite_MEM(RegWrite_MEM),
             .RegWrite_WB(RegWrite_WB),
             .MemtoReg_MEM(MemtoReg_MEM),
             .MemtoReg_WB(MemtoReg_WB),
             .RDaddr_MEM(RDaddr_MEM),
             .RDaddr_WB(RDaddr_WB),
             .Mem_Readdata_MEM(Mem_Readdata_MEM),
             .Mem_Readdata_WB(Mem_Readdata_WB),
             .FUResult_MEM(FUResult_MEM),
             .FUResult_WB(FUResult_WB)
         );

//MUX 2-to-1 RDdata
wire [15:0] RDdata_WB;


Mux2to1 mux5(
            .data0_i(FUResult_WB),
            .data1_i(Mem_Readdata_WB),
            .select_i(MemtoReg_WB),
            .data_o(RDdata_WB)
        );





endmodule

