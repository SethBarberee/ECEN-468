module SRAM (InData, OutData, Address, bCE, bWE);

parameter AddressSize = 18;		// 2^18 = 256K
parameter WordSize = 8;			// 8 bits

// Port Declaration
input [AddressSize - 1: 0] Address;
input [WordSize - 1: 0] InData;
output [WordSize - 1: 0] OutData;
input bCE;
input bWE;

// Internal Variable
reg [WordSize - 1: 0] internal_memory [(1 << AddressSize) - 1 : 0];
reg [WordSize - 1: 0] OutData;

// Function Read
always @(bCE or bWE or Address)
begin
	if(bWE && !bCE)
        // read from storage
        OutData <= internal_memory[Address];
end

// Function Write
always @(bCE or bWE or Address or InData)
begin
	if(!bWE && !bCE)
        // write to storage
        internal_memory[Address] <= InData;
end

endmodule

