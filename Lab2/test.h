#include "systemc.h"

#define WORD_SIZE         8 

//#define _DEBUG_

SC_MODULE(test){
	// Input/Output Signal
	sc_out < bool > Load_XMT_datareg;
	sc_out < bool > Byte_ready;
	sc_out < bool > T_byte;
	sc_out < bool > rst_b;
	sc_out < sc_uint<WORD_SIZE> >   Data_Bus;

	sc_in  < bool > Serial_out;

	sc_in  < bool >	clk;

	// Internal Variable
        int i;

	// Function Declaration
	void do_test();

	// Constructor
	SC_CTOR(test) {
          	SC_CTHREAD(do_test, clk.neg());	// falling edge of the clk
          	//SC_CTHREAD(do_test, clk);     // rising or falling edge of the clk
		
		// Initialize output signals
		Load_XMT_datareg.initialize(0);
		Byte_ready.initialize(0);
		T_byte.initialize(0);
		rst_b.initialize(0);
		Data_Bus.initialize(0x00);
	}
};
