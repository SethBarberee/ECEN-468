module WRAP_UART (DataBus, AddressBus, ControlBus, InData, Load_XMT_datareg, Byte_ready, T_byte, Breq, Bgnt, clk, bReset);

parameter 		WordSize = 8;		// 32 bits

output 			Load_XMT_datareg, Byte_ready, T_byte;
output [WordSize-1:0] 	InData;

reg 			Load_XMT_datareg, Byte_ready, T_byte;
reg [WordSize-1:0] 	InData;
input 			bReset;

output 			Breq;
reg       		Breq;
input			Bgnt;

inout [7:0]		DataBus;
inout [31:0]		AddressBus;
inout			ControlBus;

input 			clk;

// Internal signal
reg			IntEnable;
reg [3:0]   		cnt;

assign ControlBus = IntEnable ? 1'b0 : 1'bz;

always @(posedge clk)
begin
	   if(IntEnable)				// Bus Free
	   begin
		   if(AddressBus[31:28] == 4'b0010)	// Address Decoding Matching
		   begin
			// Insert your code here
			// ...
			// ...
	        	T_byte <= AddressBus[2];
			Byte_ready <= AddressBus[1];
			Load_XMT_datareg <= AddressBus[0];
			InData <= DataBus;
		   end
	   end
	else
	begin
	        	T_byte <= 1'b0;
			Byte_ready <= 1'b0;
			Load_XMT_datareg <= 1'b0;
			InData <= 8'h00;
	end
end

always @(posedge clk)
begin
   if(!bReset)
   begin
		IntEnable <= 1'b0;
		Breq <= 1'b0;
		cnt <= 0;
   end
   else
   begin
      if(!IntEnable)
	   begin
		   if(Bgnt)
		   begin
			   IntEnable <= 1'b1;
			   Breq <= 1'b0;
			   cnt <= 1;
		   end
		   else if(AddressBus[31:28] == 4'b0010)
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
	   else if(AddressBus[31:28] != 4'b0010)
	   begin	
		      IntEnable <= 1'b0;
		      Breq <= 1'b0;
		      cnt <= 0;
	   end
	end
end
endmodule

