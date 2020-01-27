#include "systemc.h"

#define WORD_SIZE         8 

SC_MODULE(test){
	// Input/Output Signal
      sc_in < bool >		clk;
      sc_out < bool >         bReset;
	sc_in < bool > 		Serial_out;

	sc_out < bool >		Breq;
	sc_in < bool >		Bgnt;

	sc_inout_rv < 8 >		DataBus;
	sc_inout_rv < 32 >	AddressBus;
	sc_inout_rv < 1 >		ControlBus;

      int i;
	void do_test();
      sc_lv < WORD_SIZE >     dRcvData;

	void reset();

	// Constructor
	SC_CTOR(test) {
          SC_CTHREAD(do_test, clk.neg());// falling edge of the clk
		// Initialize output signals
		bReset.initialize(0);
		Breq.initialize(0);
			
		DataBus.initialize("ZZZZZZZZ");
		AddressBus.initialize("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
		ControlBus.initialize("Z");
	}
};
