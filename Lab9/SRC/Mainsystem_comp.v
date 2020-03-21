`include "Arbiter.v"
`include "virtSRAM.v"
`include "UART_XMTR.v"
`include "WRAP_SRAM.v"
`include "WRAP_UART.v"

module MAINSYSTEM(Serial_out, clk, Breq, Bgnt, DataBus, AddressBus, ControlBus, bReset);

parameter 		AddressSize = 18;	// 2^18 = 256K
parameter 		WordSize = 8;		// 32 bits

// Inputs & Outputs
output 			Serial_out;
input 			clk;
input 			bReset;

output 			Bgnt;
reg			Bgnt;
input			Breq;

inout [7:0]		DataBus;
inout [31:0]		AddressBus;
inout			ControlBus;

// Internal wires
wire [AddressSize-1:0] 	Address;
wire [WordSize-1:0] 	InData;
wire 			bCE, bWE;
wire [WordSize-1:0] 	OutData;
wire [2:0] 		Breqn;
wire [2:0] 		Bgntn;

wire [WordSize-1:0] 	DataToUART;
wire 			Load_XMT_datareg, Byte_ready, T_byte;

always @(Bgntn)
	Bgnt = Bgntn[2];

assign Breqn[2] = Breq;

// Connect DUT (Design Under Test)
// You should make sure that the order of the signals match to your sub-modules.
SRAM       SRAM_01(InData, OutData, Address, bCE, bWE);
WRAP_SRAM  WRAP_SRAM_01(DataBus, AddressBus, ControlBus, InData, OutData, Address, bCE, bWE, Breqn[0], Bgntn[0], clk, bReset);

UART_XMTR  UART_XMTR_01(Serial_out, DataToUART, Load_XMT_datareg, Byte_ready, T_byte, clk, bReset);
WRAP_UART  WRAP_UART_01(DataBus, AddressBus, ControlBus, DataToUART, Load_XMT_datareg, Byte_ready, T_byte, Breqn[1], Bgntn[1], clk, bReset);

Arbiter    Arbiter_01(Breqn, Bgntn);

endmodule
