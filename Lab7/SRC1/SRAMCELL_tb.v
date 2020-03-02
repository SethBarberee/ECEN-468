// TESTBENCH

`timescale 1ns/10ps
`include "SRAMCELL.v"

module stimulus;

	// Port Declaration
	reg InData, bCS, bWE;
	wire OutData;

	// Connect DUT (Design Under Test)
	SRAMCELL SRAMCELL_01(InData, OutData, bCS, bWE);

	// Initialization
	initial
	begin
		bCS = 1'b1;
		bWE = 1'b1;
		InData = 1'bx;
	end

	// Main Test-bench
	initial
	begin
		// Write Data 1 to SRAM CELL
		#5	InData = 1'b1;	#5	bCS = 1'b0;	bWE = 1'b0;
		// Disable CELL
		#5				bCS = 1'b1;
		// Read Data from SRAM CELL
		#5				bCS = 1'b0;	bWE = 1'b1;
		// Write Data 0 to SRAM CELL
		#5	InData = 1'b0;	#5	bCS = 1'b0;	bWE = 1'b0;
		// Disable CELL
		#5				bCS = 1'b1;
		// Read Data from SRAM CELL
		#5				bCS = 1'b0;	bWE = 1'b1;
		// Disable CELL
		#5				bCS = 1'b1;

		#50	$finish;//$stop;
	end

	// Dump signals to make waveform
	initial
	begin
		$dumpfile ("wave.dump");
		$dumpvars (0, stimulus);
	end
	
	initial
		$monitor($time, "InData:%d / OutData:%d / bCS[%d] / bWE[%d]", InData, OutData, bCS, bWE);

	//initial
	//	$sdf_annotate("SRAMCELL.sdf", SRAMCELL_01);
endmodule
