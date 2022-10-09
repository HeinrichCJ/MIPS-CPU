module Mux3to1( data0_i, data1_i, data2_i, select_i, data_o );

parameter size = 16;

//I/O ports
input wire	[size-1:0] data0_i;
input wire	[size-1:0] data1_i;
input wire	[size-1:0] data2_i;
input wire	[2-1:0] select_i;
output reg	[size-1:0] data_o;

//Main function
/*your code here*/
always@(*)
begin
    case(select_i)
        2'b00:
            data_o = data0_i;
        2'b01:
            data_o = data1_i;
        2'b10:
            data_o = data2_i;
        default:
            data_o = 16'b0;
    endcase
end
endmodule
