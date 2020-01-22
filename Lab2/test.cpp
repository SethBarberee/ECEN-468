#include "test.h"

// Testbench
void test::do_test(){
	wait();

	while(true){
		// Initialize
		rst_b = 0;
		wait(2);
		rst_b = 1;

		// Main Testbench
		for(i=0x41; i<=0x43; i++){
                	Data_Bus.write(i);	// Data_Bus = i;   
                	cout << endl << "@" << sc_time_stamp() << ":: >> START SENDING: 0x" << hex << i << endl;
                	wait(2);
			Load_XMT_datareg.write(1);	wait(2);	Load_XMT_datareg.write(0);	wait(2);
			Byte_ready.write(1);		wait(2);	Byte_ready.write(0);		wait(2);
			T_byte.write(1);		wait(2);	T_byte.write(0);		wait(2);

                	wait(20);
       		}
        	sc_stop();
	}
}
