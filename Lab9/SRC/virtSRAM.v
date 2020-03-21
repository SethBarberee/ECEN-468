module SRAM (InData, OutData, Address, bCE, bWE);

parameter AddressSize = 18;		// 2^18 = 256K
parameter WordSize = 8;			// 8 bits

input [AddressSize-1:0] Address;
input [WordSize-1:0] InData;
input bCE, bWE;

output [WordSize-1:0] OutData;

//reg [WordSize-1:0] Mem [0:1<<Address];
reg [WordSize-1:0] OutData;

// Function Write
always @(bCE or bWE or Address or InData)
  if (!bCE && !bWE)
    OutData <= InData;
endmodule

