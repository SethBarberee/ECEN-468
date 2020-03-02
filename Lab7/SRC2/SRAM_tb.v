// TESTBENCH

`timescale 1ns/10ps
`include "SRAM.v"
//`include "osu018_stdcells.v"

module stimulus;

   parameter dAddrSize = 18;
   parameter dWordSize = 8;
   
   reg [dAddrSize-1:0] vAddr;
   reg [dWordSize-1:0] vInData;
   wire [dWordSize-1:0] vOutData;
   reg cCE, cWE;

   SRAM SRAM_01(vAddr, vInData, vOutData, cCE, cWE);  // Connect to TOP MODULE

   integer i;

   initial                        // Initial Conditions
   begin
      cCE = 1'b1;		  // Disable chip
      cWE = 1'b1;		  // Disable WRITE
   end

   initial                        // Time variants
   begin
     	for(i=61; i<64; i=i+1)begin
		#10 vAddr = i;		vInData = i;
		#10 cWE = 1'b0;		#2 cCE = 1'b0;		// Enable chip and WRITE
	end
	// Set to Idle Mode
	#2;	cCE = 1'b1;

      	for(i=61; i<64; i=i+1)begin
		#10 vAddr = i;		vInData = 8'hXX;
		#10 cWE = 1'b1;		#2 cCE = 1'b0;		// Enable chip and WRITE
	end
  	
      #300 $finish;			// $stop;		// stop
      end

   initial
   begin
      $dumpfile ("wave.dump");
      $dumpvars (0, stimulus);
   end // initial begin
   
   	initial			// output to text
	begin
      	$monitor($time, " READ[%d] WRITE[%d] ENABLE[%d] / ADDR[%d] = InData:%d / OutData:%d", cWE, ~cWE, ~cCE, vAddr, vInData, vOutData);
	end

   //initial
   //   $sdf_annotate("SRAM.sdf", SRAM_01);

endmodule
