module Shifter( result, leftRight, sftSrc );

//I/O ports
output	[16-1:0] result;

input			leftRight;
input	[16-1:0] sftSrc ;

//Internal Signals
wire	[16-1:0] result;

//Main function
/*your code here*/
assign result = (leftRight)? {sftSrc[14:0], 1'b0} : {1'b0, sftSrc[15:1]};
/*
if leftRight = 1, shift left;
else if leftRight = 0, shift right.
*/
endmodule
