module WRAP_SRAM (DataBus, AddressBus, ControlBus, InData, OutData, Address, bCE, bWE, Breq, Bgnt, clk, bReset);

parameter 			AddressSize = 18;	// 2^18 = 256K
parameter 			WordSize = 8;		// 32 bits

output [AddressSize-1:0] 	Address;
reg [AddressSize-1:0] 		Address;
output [WordSize-1:0] 		InData;
reg [WordSize-1:0] 		InData;
output 				bCE, bWE;
reg 				bCE, bWE;
output 				Breq;
reg       			Breq;

input [WordSize-1:0] 		OutData;
input				Bgnt;
input 				bReset;
input 				clk;

inout [7:0]			DataBus;
inout [31:0]			AddressBus;
inout				ControlBus;

// Internal signal
reg			IntEnable;
reg [3:0]   		cnt;
			
assign ControlBus = IntEnable? 1'b0 : 1'bz;
// You need to assign DataBus here using continuous assign statement.
//..
assign DataBus = IntEnable? OutData : 7'bz;

always @(posedge clk)
begin
	   if(IntEnable==1'b1)				// Bus free
	   begin
		   if(AddressBus[31:28] == 4'b0001)	// Address Decoding Matching
		   begin
			// Insert your code here
			// ..
			// ..
                        Address => AddressBus[17:0];
                        InData => DataBus;
                        bCE => AddressBus[19];
                        bWE => AddressBus[18];
		   end
	   end
end

always @(posedge clk)
begin
   if(bReset==1'b0)
   begin
		IntEnable <= 1'b0;
		Breq <= 1'b0;
		cnt <= 0;
   end
   else
   begin
      if(IntEnable==1'b0)
	   begin
		   if(Bgnt==1'b1)
		   begin
			   IntEnable <= 1'b1;
			   Breq <= 1'b0;
			   cnt <= 1;
		   end
		   else if(AddressBus[31:28] == 4'b0001)
		   begin
			   IntEnable <= 1'b0;
			   Breq <= 1'b1;
		   end
		   else
		   begin
			   IntEnable <= 1'b0;
			   Breq <= 1'b0;
		   end
	   end
	   else if(AddressBus[31:28] != 4'b0001)
	   begin	
		      IntEnable <= 1'b0;
		      Breq <= 1'b0;
		      cnt <= 0;
	   end
	end
end
endmodule

