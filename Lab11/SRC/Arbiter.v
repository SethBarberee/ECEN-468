module Arbiter (BREQn, BGNTn);

parameter NumUnit = 4;

input [NumUnit-1:0]	BREQn;
output [NumUnit-1:0]	BGNTn;

assign BGNTn[2] = BREQn[2];				// from TEST-BENCH
assign BGNTn[0] = !BREQn[2] && BREQn[0];		// from MEMORY
assign BGNTn[1] = !BREQn[2] && !BREQn[0] && BREQn[1];	// from UART
assign BGNTn[3] = !BREQn[2] && !BREQn[1] && !BREQn[0] && BREQn[3];	// from Canny

//always @(BREQn)
//    $display("BREQn[3:0]:%b / BGNTn[3:0]: %b", BREQn, BGNTn);

endmodule

