//===========================================
// Function : Canny Edge Detector
//===========================================
#include "Canny_Edge.h"
#include "test.h"

int sc_main (int argc, char* argv[]) {
	// In/Out Signals
 	sc_signal	< sc_uint<3> >		AddrRegRow;
  	sc_signal 	< sc_uint<3> >		AddrRegCol;
  	sc_signal 	< bool > 		bWE	;
  	sc_signal 	< bool > 		bCE	;
  	sc_signal 	< sc_uint<DATA_WIDTH> >	InData	;
  	sc_signal 	< sc_uint<DATA_WIDTH> > OutData ;

  	sc_signal	< sc_uint<3> >		OPMode	;	
	sc_signal	< bool >		bOPEnable;
	sc_signal	< sc_uint<4> >		dReadReg;
	sc_signal	< sc_uint<4> >		dWriteReg;

  	sc_signal 	< bool > 		rst_b	;

	// Clock Generation
	sc_clock clk("clk", 1, SC_NS);
	
	// Connect the DUT
	Canny_Edge Canny_Edge_01("Canny_Edge_01");
		Canny_Edge_01.AddrRegRow(AddrRegRow);
		Canny_Edge_01.AddrRegCol(AddrRegCol);
		Canny_Edge_01.bWE(bWE);
		Canny_Edge_01.bCE(bCE);
		Canny_Edge_01.InData(InData);
		Canny_Edge_01.OutData(OutData);
		Canny_Edge_01.OPMode(OPMode);
		Canny_Edge_01.bOPEnable(bOPEnable);
		Canny_Edge_01.dReadReg(dReadReg);
		Canny_Edge_01.dWriteReg(dWriteReg);
		Canny_Edge_01.rst_b(rst_b);
		Canny_Edge_01.clk(clk);

	test TST("TST");
	TST(AddrRegRow, AddrRegCol, bWE, bCE, InData, OutData, OPMode, bOPEnable, dReadReg, dWriteReg, clk, rst_b);
/*
	// Open VCD file
	sc_trace_file *wf = sc_create_vcd_trace_file("wave");

	// Dump the desired signals
	sc_trace(wf, rst_b, "rst_b");
	sc_trace(wf, AddrRegRow, "AddrRegRow");
        sc_trace(wf, AddrRegCol, "AddrRegCol");
	sc_trace(wf, InData, "InData");
	sc_trace(wf, OutData, "OutData");
	sc_trace(wf, bWE, "bWE");
	sc_trace(wf, bCE, "bCE");
	sc_trace(wf, clk, "clk");
	sc_trace(wf, OPMode, "OPMode");
	sc_trace(wf, bOPEnable, "bOPEnable");
	sc_trace(wf, dReadReg, "dReadReg");
	sc_trace(wf, dWriteReg, "dWriteReg");
*/	
	// Time to simulate
	// Simulate until it meets sc_stop() if sc_start(-1) or sc_start()
	//sc_start(1000, SC_NS);	// Simulate for 1000ns
	TST.LoadBMPFile();
	sc_start();

	// Close the dump file
//	sc_close_vcd_trace_file(wf);
	
	return 0;	// Terminate simulation
}
