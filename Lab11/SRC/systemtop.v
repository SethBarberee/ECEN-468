`include "Arbiter.v"
`include "SRAM.v"
`include "UART_XMTR.v"
`include "CannyEdge.v"
`include "WRAP_SRAM.v"
`include "WRAP_UART.v"
`include "WRAP_CANNY.v"

module systemtop(Serial_out, clk, Breq, Bgnt, DataBus, AddressBus, ControlBus, bReset);

parameter AddressSize = 18;		// 2^18 = 256K
parameter WordSize = 8;		// 32 bits

output Serial_out;
input clk;
input bReset;

input Breq;
output Bgnt;

inout [7:0]		DataBus;
inout [31:0]		AddressBus;
inout			ControlBus;

// with Memory
wire [AddressSize-1:0] Address;
wire [WordSize-1:0] InData;
wire bCE, bWE;
wire [WordSize-1:0] OutData;
wire Breq_RAM;

// with Arbiter
wire [3:0] Breqn;
wire [3:0] Bgntn;

// with UART
wire [WordSize-1:0] DataToUART;
wire Load_XMT_datareg, Byte_ready, T_byte;
wire Breq_UART;

// with Canny Edge module
wire [2:0]   AddrRegRow, AddrRegCol;
wire         Canny_bCE, Canny_bWE;
wire [7:0]   DataToCanny, DataFromCanny;
wire [2:0]   OPMode;
wire         bOPEnable;
wire [3:0]   dReadReg, dWriteReg;
wire         Breq_Canny;

assign Breqn = {Breq_Canny, Breq, Breq_UART, Breq_RAM};
assign Bgnt = Bgntn[2];

SRAM       SRAM_01(InData, OutData, Address, bCE, bWE);
WRAP_SRAM  WRAP_SRAM_01(DataBus, AddressBus, ControlBus, InData, OutData, Address, bCE, bWE, Breq_RAM, Bgntn[0], clk, bReset);

UART_XMTR  UART_XMTR_01(Serial_out, DataToUART, Load_XMT_datareg, Byte_ready, T_byte, clk, bReset);
WRAP_UART  WRAP_UART_01(DataBus, AddressBus, ControlBus, DataToUART, Load_XMT_datareg, Byte_ready, T_byte, Breq_UART, Bgntn[1], clk, bReset);

CannyEdge  CannyEdge_01(AddrRegRow, AddrRegCol,	Canny_bWE, Canny_bCE, DataToCanny, DataFromCanny,OPMode, bOPEnable, dReadReg, dWriteReg,	clk, bReset);
WRAP_CANNY WRAP_CANNY_01(DataBus, AddressBus, ControlBus, AddrRegRow, AddrRegCol, Canny_bWE, Canny_bCE, DataToCanny, DataFromCanny, OPMode, bOPEnable, dReadReg, dWriteReg, Breq_Canny, Bgntn[3], clk, bReset);

Arbiter    Arbiter_01(Breqn, Bgntn);
endmodule
