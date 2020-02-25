#include "systemc.h"
#include "RAM.cpp"
#include <scv.h>

class Pkt_constraint : virtual public scv_constraint_base
{
	public:
	scv_smart_ptr<sc_uint<ADDR_WIDTH> > sAddr;
	scv_smart_ptr<sc_uint<DATA_WIDTH> > sInData;
	scv_smart_ptr<sc_uint<DATA_WIDTH> > sOutData;

	SCV_CONSTRAINT_CTOR(Pkt_constraint) {
		// define constraints
                SCV_SOFT_CONSTRAINT( sAddr() < 10);
                SCV_SOFT_CONSTRAINT( sInData() > 80);
	}
};

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

	Pkt_constraint cPkt("Pkt_Test");
        cPkt.sOutData->disable_randomization();
        

        // Verification I
        cout << "------------------- Beginning of Verification I" << endl;
        for(i=0; i<5; i++){
          // Set writing mode
	  // ...
            tbCE.write(0);
            tbWE.write(0);
          
          // Generate values of tInData & tAddr using "cPkt"
	  // ...
            cPkt.next();
            tInData.write( cPkt.sInData->read());
            tAddr.write(cPkt.sAddr->read());
	        sc_start(5);
          // Set reading mode
	  // ...
            tbCE.write(0);
            tbWE.write(1);
	sc_start(5);
          // Data read from tOutData to sOutData
            *cPkt.sOutData = tOutData.read();
          // Print statistics
	  // ...
            cout << "Statistics" << endl;
            cPkt.print();
            //cout << "InData: " << cPkt.sInData << endl; 
            //cout << "Addr: " << cPkt.sAddr << endl; 
            //cout << "OutData: " << cPkt.sOutData << endl; 
        }
        cout << "------------------- End of Verification I" << endl << endl;
        
        // Verification II
        cout << "------------------- Beginning of Verification II" << endl;        
        for(i=0; i<5; i++){
          // Set writing mode
	  // ...
            tbCE.write(0);
            tbWE.write(0);

          // Set range distribution
          // InData with 5% from 80 to 99 and 95% from 100 to 120
            typedef pair <sc_uint<DATA_WIDTH>, sc_uint<DATA_WIDTH> > field_dist;
            scv_bag<field_dist> intBag;
          // add to the bag
          intBag.add( pair<sc_uint<DATA_WIDTH>, sc_uint<DATA_WIDTH> >(80, 99), 5);
          intBag.add( pair<sc_uint<DATA_WIDTH>, sc_uint<DATA_WIDTH> >(100, 120), 95);
          
          cPkt.sInData->set_mode(intBag);
          
	  // Generate values of tInData  using "cPkt"
	  // ...
          cPkt.sInData->next();
          tInData.write(cPkt.sInData->read());
          tAddr.write(cPkt.sAddr->read());
	        sc_start(5);
          // Set reading mode
          tbCE.write(0);
          tbWE.write(1);
	        sc_start(5);
          // Data read
            *cPkt.sOutData = tOutData.read();
          // Print statistics
	  // ...
            cout << "Statistics" << endl;
            cPkt.print();
            //cout << "InData: " << cPkt.sInData << endl; 
            //cout << "Addr: " << cPkt.sAddr << endl; 
            //cout << "OutData: " << cPkt.sOutData << endl; 
        }
        cout << "------------------- End of Verification II" << endl;
        
	// Close trace file
	sc_close_vcd_trace_file(wf);
	
	return 0;	// Terminate simulation
}
