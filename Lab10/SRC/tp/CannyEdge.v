`timescale 1ns/10ps

`define DATA_WIDTH 8

module CannyEdge(dAddrRegRow, dAddrRegCol, bWE, bCE, InData, OutData,
	OPMode, bOPEnable, dReadReg, dWriteReg,	clk, rst_b);

input 	[2:0]			dAddrRegRow, dAddrRegCol;
input					bWE, bCE;
input 	[`DATA_WIDTH-1:0] InData;
output 	[`DATA_WIDTH-1:0] OutData;
reg     	[`DATA_WIDTH-1:0] OutData;

input 	[2:0]			OPMode;
input 				bOPEnable;
input 	[3:0]			dReadReg, dWriteReg;

input					clk, rst_b;

// Insert your code here
// ...
// ...
// ...

endmodule

