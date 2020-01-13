#include "systemc.h"
#include "RAM.cpp"

//#define DATA_WIDTH        8 
//#define ADDR_WIDTH        18 
//#define RAM_DEPTH         1 << ADDR_WIDTH

int sc_main (int argc, char* argv[]) {

	// Declare Input/Output Signals
  	sc_signal < sc_uint<ADDR_WIDTH> > 	tAddr ;
  	sc_signal < bool > 			tbWE;
  	sc_signal < bool > 			tbCE;
  	sc_signal < sc_uint<DATA_WIDTH> > 	tInData;
  	sc_signal < sc_uint<DATA_WIDTH> > 	tOutData;
  	
	int i = 0;
	
	// Connect the DUT(Design Under Test)
	RAM RAM_01("SIMULATION_RAM");
		RAM_01.InData(tInData);
        	RAM_01.Addr(tAddr);
		RAM_01.bCE(tbCE);
		RAM_01.bWE(tbWE);
		RAM_01.OutData(tOutData);

	// Open VCD(Value Change Dump) file
	sc_trace_file *wf = sc_create_vcd_trace_file("VCD_RAM");

	// Dump the desired signals
	sc_trace(wf, tInData, "strInData");
        sc_trace(wf, tAddr, "strAddr");
	sc_trace(wf, tbCE, "strbCE");
	sc_trace(wf, tbWE, "strbWE");
	sc_trace(wf, tOutData, "strOutData");

	// Initialize all variables
	tbCE.write(1);
	tbWE.write(1);
	sc_start(5);

	// Write data to cells (address from 61 to 64)
        for(i=61; i<64; i++){
          	tbCE.write(0);
          	tbWE.write(0);
          	tInData.write(i);
          	tAddr.write(i);
		cout << "@" << sc_time_stamp() << ":: Write mode" << endl;
		sc_start(5);
        }

	// Set to Idle mode
	tbCE.write(1);
	tbWE.write(1);
    	tInData.write(0);
	cout << "@" << sc_time_stamp() << ":: Set to Idle mode" << endl;
	sc_start(5);

	// Read data from cells (address from 61 to 64)
	for(i=61; i<64; i++){
          	tbCE.write(0);
		tbWE.write(1);
        	tAddr.write(i);
		cout << "@" << sc_time_stamp() << ":: Read mode" << endl;
		sc_start(5);
        }
	
	// Close trace file
	sc_close_vcd_trace_file(wf);
	
	return 0;	// Terminate simulation
}
