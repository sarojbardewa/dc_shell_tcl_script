////////////////////////
// This is a simple gate implementation
// Saroj Bardewa
/////////////////////////

module simpleAnd(output logic D,
		 input logic A,B,C,
		 input logic clk, reset);
logic D1,D2,D3;
always_ff@(posedge clk)begin
if(reset)
  D1 <= 0;
else
  D1 <= A&B;
end
/*
always_ff@(posedge clk)begin
if(reset)
  D2 <= 0;
else
  D2 <= (C ^ D1) & (A ^ (B & D1)) ;
end

always_ff@(posedge clk)begin
if(reset)
  D3 <= 0;
else
  D3 <= (C & D1) ^ (A | (~B ^ D1)) ;
end
*/
always_ff@(posedge clk)begin
if(reset)
  D <= 0;
else
  D <= (C ^ D1^A) ^ (A & (B ^ D1 ^C)) ;
end
endmodule

