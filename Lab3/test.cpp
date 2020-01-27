#include "test.h"
void test::reset(){
	// Reset
	wait(10);
	DataBus.write("ZZZZZZZZ");
	AddressBus.write(0x00000000);
	wait(2);
	AddressBus.write("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
	wait(10);
}

void test::do_test(){
	wait();

	while(true){
            cout << endl << "@" << sc_time_stamp() << ":: >>>>>>>>>>>> Start Simulation" << endl;
		// Initialize
		wait(10);
		bReset = 1;
		reset();

		// 1. Write to Data '0'(0x30) to SRAM 0x234
		// Write To Memory : MEM, bCE=0, bWE=0, Addr=0x234;
		// (bCE and bWE can be different based on your previous design.)
	  	DataBus.write(0x30);
	  	AddressBus.write(0x10000234);
		cout << endl << "@" << sc_time_stamp() << ":: >>  Write data to SRAM: 0x" << hex << 0x30 << endl;

	  	// Reset
		reset();

		// 2. Read From Memory
		// Write To Memory : MEM, bCE=0, bWE=1, Addr=0x234;
		// (bCE and bWE can be different based on your previous design.)
		AddressBus.write(0x10040234);
		cout << endl << "@" << sc_time_stamp() << ":: >>  Set SRAM to read mode" << endl;

			
		// 3. Read Data from the bus
		wait(10);
		dRcvData = DataBus.read();
            wait(6);
		cout << endl << "@" << sc_time_stamp() << ":: >>  Read data from data bus: 0x" << hex << dRcvData << endl;


		// Reset
		reset();

		// 4. Transmit data which is read from SRAM through UART
		DataBus.write(dRcvData);	AddressBus.write(0x20000001);
		wait(4);
		DataBus.write("ZZZZZZZZ");   	AddressBus.write(0x20000002);
		wait(4);
                					AddressBus.write(0x20000004);

		// Reset
        	reset();
		cout << endl << "@" << sc_time_stamp() << ":: >>>>>>>>>>>> End Simulation" << endl;
		sc_stop();
        }
}
