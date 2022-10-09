module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o);

//I/O ports
input      [4-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;
output     [2-1:0] FURslt_o;

//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
reg [3:0] aluop;
reg [1:0] furslt;

always@(*)
begin
    if(ALUOp_i == 2'b10)
    begin //R-type
        case(funct_i)
            4'b0000:
            begin // add
                aluop = 4'b0010;
                furslt = 2'b00;

            end

            4'b0001:
            begin // sub
                aluop = 4'b0110;
                furslt = 2'b00;

            end

            4'b0010:
            begin // and
                aluop = 4'b0000;
                furslt = 2'b00;

            end

            4'b0011:
            begin // or
                aluop = 4'b0001;
                furslt = 2'b00;

            end

            4'b0100:
            begin // nor
                aluop = 4'b1100;
                furslt = 2'b00;

            end

            4'b0101:
            begin // slt
                aluop = 4'b0111;
                furslt = 2'b00;

            end

            4'b0110:
            begin // sll
                aluop = 4'b1000; //connect the ALU_operation_o[3] to the leftRight
                furslt = 2'b01;

            end

            4'b0111:
            begin // srl
                aluop = 4'b0000;
                furslt = 2'b01;

            end
        endcase
    end

    else if(ALUOp_i == 2'b00)
    begin // addi, lw, sw
        aluop = 4'b0010;
        furslt = 2'b00;

    end

    else if(ALUOp_i == 2'b11)
    begin // lui
        aluop = 4'b0010;
        furslt = 2'b10;

    end

    else
    begin // beq , bne , jump
        aluop = 4'b0110;
        furslt = 2'b00;

    end
end



assign ALU_operation_o = aluop;
assign FURslt_o = furslt;


endmodule
