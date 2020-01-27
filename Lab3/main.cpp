#include "UART_XMTR_WRAP.h"
#include "UART_XMTR.h"
#include "SRAM.cpp"
#include "SRAM_WRAP.h"
#include "Arbiter.h"
#include "test.h"

int sc_main (int argc, char* argv[]) {

	// Input/Output Signal ---------------------------------

	// Wrapper(Decoder) - Arbiter
	sc_signal < bool >		BREQ2, BREQ1, BREQ0;
	sc_signal < bool >	      BGNT2, BGNT1, BGNT0;

	// Wrapper(Decoder) of SRAM - SRAM
	sc_signal_rv < WORD_SIZE >	DataToSRAM;
	sc_signal_rv < WORD_SIZE >	DataFromSRAM;
	sc_signal_rv < WORD_SIZE >	DataToUART;
	sc_signal_rv < ADDR_SIZE >	AddrToSRAM;
	sc_signal < bool > 		bCE, bWE;
	
	// Wrapper(Decoder) of UART - UART
	sc_signal < bool >		Load_XMT_datareg;
	sc_signal < bool > 		Byte_ready;
	sc_signal < bool >		T_byte;

	// UART - Test-Bench
	sc_signal < bool >		Serial_out;

	// Test-Bench - Wrapper
	sc_signal_rv < 1 >		ControlBus;
	sc_signal_rv < 8 >	      DataBus;
	sc_signal_rv < 32 >	      AddressBus;

	sc_signal < bool > 		rst_b;
	sc_clock clk("clk", 1, SC_NS);

	// Report Handler
	sc_report_handler::set_actions(SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_DO_NOTHING);
	sc_report_handler::set_actions(SC_ID_LOGIC_Z_TO_BOOL_, SC_DO_NOTHING);

	// Connect your UART_XMTR module
        UART_XMTR UART_01("TEST UART");
        UART_01(Load_XMT_datareg, Byte_ready, T_byte, rst_b, 
                DataToUART, Serial_out, clk);

	// Connect your UART_XMTR_WRAP module
        UART_XMTR_WRAP uart_wrap_01("UART_WRAP");
        uart_wrap_01(T_byte, Byte_ready, Load_XMT_datareg, DataToUART, 
                ControlBus, DataBus, AddressBus, BREQ1, BGNT1, rst_b, clk);

	// Connect your SRAM module
        SRAM SRAM_01("SRAM");
        SRAM_01(AddrToSRAM, bWE, bCE, DataToSRAM, DataFromSRAM);
	
	// Connect your SRAM_WRAP module
        SRAM_WRAP sram_wrap_01("SRAM WRAP");
        sram_wrap_01(AddrToSRAM, bWE, bCE, DataToSRAM, ControlBus, DataBus, AddressBus,
                BREQ0, BGNT0, rst_b, clk);
    
	// Connect your Arbiter module
        Arbiter ARBITER_01("ARBITER");
        ARBITER_01(BREQ2, BREQ1, BREQ0, BGNT2, BGNT1, BGNT0);

	// Connect your Test-Bench module
        test TEST_01("TESTBENCH");
        TEST_01(clk, rst_b, Serial_out, BREQ2, BGNT2, DataBus,
                AddressBus, ControlBus);

	// Open VCD file
	sc_trace_file *wf = sc_create_vcd_trace_file("wave");

	// Dump the desired signals
	sc_trace(wf, rst_b, "rst_b");
	sc_trace(wf, clk, "clk");
	
	sc_trace(wf, Load_XMT_datareg, "Load_XMT_datareg");
	sc_trace(wf, Byte_ready, "Byte_ready");
	sc_trace(wf, T_byte, "T_byte");
	sc_trace(wf, DataToUART, "DataToUART");
	sc_trace(wf, Serial_out, "Serial_out");

	sc_trace(wf, DataToSRAM, "DataToSRAM");
	sc_trace(wf, DataFromSRAM, "DataFromSRAM");
	sc_trace(wf, AddrToSRAM, "AddrToSRAM");
	sc_trace(wf, bCE, "bCE");
	sc_trace(wf, bWE, "bWE");

	sc_trace(wf, BREQ0, "BREQ0");
	sc_trace(wf, BREQ1, "BREQ1");
	sc_trace(wf, BREQ2, "BREQ2");
	sc_trace(wf, BGNT0, "BGNT0");
	sc_trace(wf, BGNT1, "BGNT1");
	sc_trace(wf, BGNT2, "BGNT2");
	
	sc_trace(wf, DataBus, "DataBus");
	sc_trace(wf, AddressBus, "AddressBus");
	sc_trace(wf, ControlBus, "ControlBus");

	// Time to simulate
	// Simulate until it meets sc_stop() if sc_start(-1) or sc_start()
	//sc_start(1000, SC_NS);	// Simulate for 1000ns
	sc_start();

	// Close the dump file
	sc_close_vcd_trace_file(wf);
	
	return 0;	// Terminate simulation
}
