module ControlHazard(
           PCSrc,
           Jump_EX,
           ControlHazard
       );

input PCSrc;
input Jump_EX;

output ControlHazard;

assign ControlHazard = PCSrc | Jump_EX;



endmodule
