module SRAM (Address, InData, OutData, bCE, bWE);

parameter AddressSize = 18;		// 2^18 = 256K
parameter WordSize = 8;			// 8 bits

// Port Declaration
// ...
// ...

// Internal Variable
// ...

// Function Read
always @(bCE or bWE or Address)
begin
	// ...
end

// Function Write
always @(bCE or bWE or Address or InData)
begin
	// ...
end

endmodule

