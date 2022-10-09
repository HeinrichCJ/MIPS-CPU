module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports
input	signed [15:0]  aluSrc1;
input	signed [15:0]  aluSrc2;
input	[4-1:0] ALU_operation_i;

output	[15:0]  result;
output		    zero;
output		    overflow;

//Internal Signals
wire		    zero;
wire            overflow;
wire    [16-1:0]result;

//Main function
/*your code here*/
reg [15:0] result_1;
always@(*)
begin
    case(ALU_operation_i)

        4'b0010:
        begin
            result_1 = aluSrc1 + aluSrc2;
        end
        4'b0110:
        begin
            result_1 = aluSrc1 - aluSrc2;
        end
        4'b0000:
        begin
            result_1 = aluSrc1 & aluSrc2;
        end
        4'b0001:
        begin
            result_1 = aluSrc1 | aluSrc2;
        end
        4'b1100:
        begin
            result_1 = ~(aluSrc1 | aluSrc2);
        end
        4'b0111:
        begin
            result_1 = (aluSrc1 < aluSrc2)? 16'b1:16'b0;
        end

        default:
        begin
            result_1 = 16'b0;
        end

    endcase
end
assign result = result_1;
assign zero = (result == 16'b0)? 1'b1 : 1'b0;
assign overflow = (aluSrc1[15] & aluSrc2[15] & ~result[15]) | (~aluSrc1[15] & ~aluSrc2[15] & result[15]);

endmodule
