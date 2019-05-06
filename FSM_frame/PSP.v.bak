module PSP(ireset, iclk, opsp, opsp_byte);
input ireset;
input iclk;
output [31:0] opsp;
output [7:0] opsp_byte;

reg [31:0] rshift_reg;
assign opsp =  rshift_reg;
assign opsp_byte =  rshift_reg[7:0];
wire next_bit;
assign next_bit = 
   rshift_reg[31] ^
   rshift_reg[30] ^
   rshift_reg[29] ^
   rshift_reg[27] ^
   rshift_reg[25] ^
   rshift_reg[ 0];

always @(posedge iclk or posedge ireset)
  if(ireset)
     rshift_reg <= 32'h00000001;
  else
     rshift_reg <= { next_bit,  rshift_reg[31:1] };

endmodule