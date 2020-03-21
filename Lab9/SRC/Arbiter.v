module Arbiter (BREQn, BGNTn);

parameter 	NumUnit = 3;

input 		[NumUnit-1:0]	BREQn;
output 		[NumUnit-1:0]	BGNTn;

reg 		[NumUnit-1:0]	BGNTn;

always @(BREQn)
begin
	BGNTn[2] <= BREQn[2];				// from TEST-BENCH
	BGNTn[0] <= !BREQn[2] && BREQn[0];		// from SRAM
	BGNTn[1] <= !BREQn[2] && !BREQn[0] && BREQn[1];	// from UART
end
//always @(BREQn)
//    $display("BREQn[2:0]:%b / BGNTn[2:0]: %b", BREQn, BGNTn);
endmodule

