module Data_Hazard(
           rsaddr_ID,
           rtaddr_ID,
           RDaddr_EX,
           RDaddr_MEM,
           RegWrite_EX,
           RegWrite_MEM,
           DataHazard
       );
input [2:0] rsaddr_ID;
input [2:0] rtaddr_ID;
input [2:0] RDaddr_EX;
input [2:0] RDaddr_MEM;
input RegWrite_EX;
input RegWrite_MEM;

output reg DataHazard;

always@(*)
begin
    if(RegWrite_EX)
    begin
        if(((rsaddr_ID == RDaddr_EX) | | (rtaddr_ID == RDaddr_EX)) && (RDaddr_EX != 3'b0))
        begin
            DataHazard = 1'b1;
        end
        else
        begin
            DataHazard = 1'b0;
        end
    end

    else if (RegWrite_MEM)
    begin
        if(((rsaddr_ID == RDaddr_MEM) | | (rtaddr_ID == RDaddr_MEM)) && (RDaddr_MEM != 3'b0))
        begin
            DataHazard = 1'b1;
        end
        else
        begin
            DataHazard = 1'b0;
        end
    end

    else
    begin
        DataHazard = 1'b0;
    end
end



endmodule
