module WRAP_CANNY (DataBus, AddressBus, ControlBus, AddrRegRow, AddrRegCol, bWE, bCE, InDataToCanny, OutDataFromCanny, OPMode, bOPEnable, dReadReg, dWriteReg, Breq, Bgnt, clk, bReset);

input  [7:0]   OutDataFromCanny;
output [7:0]   InDataToCanny;
output [2:0]   AddrRegRow, AddrRegCol;
output         bWE, bCE;

output [2:0]   OPMode;
output         bOPEnable;
output [3:0]   dReadReg, dWriteReg;

reg    [7:0]   InDataToCanny;
reg    [2:0]   AddrRegRow, AddrRegCol;
reg            bWE, bCE;

reg    [2:0]   OPMode;
reg            bOPEnable;
reg    [3:0]   dReadReg, dWriteReg;

input bReset;

output 			Breq;
reg       Breq;
input			 Bgnt;

inout [7:0]		DataBus;
inout [31:0]		AddressBus;
inout			ControlBus;

input 			clk;

// Internal signal
reg			IntEnable;
reg [3:0]   cnt;
assign ControlBus = IntEnable? 1'b0 : 1'bz;
//assign DataBus = 8'hz;
assign DataBus = IntEnable ? ((AddressBus[31:28] == 4'b0100 && AddressBus[1:0] == 2'b10)? OutDataFromCanny[7:0] : 8'hzz) : 8'hzz;

always @(posedge clk)
begin
	   if(IntEnable)					// Free
	   begin
		   if(AddressBus[31:28] == 4'b0100)	// Address Decoding Matching
		   begin
		      AddrRegRow <= AddressBus[7:5];
		      AddrRegCol <= AddressBus[4:2];
		      bWE <= AddressBus[1];
		      bCE <= AddressBus[0];
		      OPMode <= AddressBus[26:24];
		      bOPEnable <= AddressBus[27];
		      dReadReg <= AddressBus[19:16];
		      dWriteReg <= AddressBus[23:20];
		      
		      if(AddressBus[1:0] == 2'b00)   // Write Mode
		      begin
		          InDataToCanny <= DataBus[7:0];
		      end
		   end
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
		   else if(AddressBus[31:28] == 4'b0100)
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
	   else if(AddressBus[31:28] != 4'b0100)
	   begin	
		      IntEnable <= 1'b0;
		      Breq <= 1'b0;
		      cnt <= 0;
	   end
	end
end
endmodule

