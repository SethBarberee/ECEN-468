#include "UART_XMTR_WRAP.h"
#include "UART_XMTR.h"
#include "SRAM.cpp"
#include "SRAM_WRAP.h"
#include "Canny_Edge.h"
#include "Canny_Edge_WRAP.h"
#include "Arbiter.h"
#include "test.h"

int sc_main (int argc, char* argv[]) {
	// Input/Output Signal
      sc_signal < bool >		BREQ3, BREQ2, BREQ1, BREQ0;
      sc_signal < bool >	      BGNT3, BGNT2, BGNT1, BGNT0;

      sc_signal_rv < WORD_SIZE >	DataToSRAM;
	sc_signal_rv < WORD_SIZE >	DataFromSRAM;
	sc_signal_rv < WORD_SIZE >	DataToUART;
	sc_signal_rv < ADDR_SIZE >	AddrToSRAM;
	sc_signal < bool > 		bCE, bWE;
	
	sc_signal < bool >		Load_XMT_datareg;
	sc_signal < bool > 		Byte_ready;
	sc_signal < bool >		T_byte;

	sc_signal < bool >		Serial_out;

	sc_signal < sc_uint < 3 > >	AddrRegRow;
	sc_signal < sc_uint < 3 > >	AddrRegCol;
	sc_signal < bool >		Canny_bWE;
	sc_signal < bool > 		Canny_bCE;
	sc_signal < sc_uint < WORD_SIZE > >	CannyInData;
	sc_signal < sc_uint < WORD_SIZE > >	CannyOutData;
	sc_signal < sc_uint < 3 > >	OPMode;
	sc_signal < bool > 		bOPEnable;
	sc_signal < sc_uint < 4 > >	dReadReg;
	sc_signal < sc_uint < 4 > >	dWriteReg;
 
	sc_signal_rv < 1 >		ControlBus;
	sc_signal_rv < 8 >	      DataBus;
	sc_signal_rv < 32 >	      AddressBus;

  	sc_signal < bool > 		rst_b;
	sc_clock clk("clk", 1, SC_NS);

	//sc_report_handler::set_actions(SC_WARNING, SC_DO_NOTHING);	
	sc_report_handler::set_actions(SC_ID_VECTOR_CONTAINS_LOGIC_VALUE_, SC_DO_NOTHING);
	sc_report_handler::set_actions(SC_ID_LOGIC_Z_TO_BOOL_, SC_DO_NOTHING);

	// Connect the DUT
	UART_XMTR UART_XMTR_01("UART_XMTR_01");
		UART_XMTR_01.Data_Bus(DataToUART);
		UART_XMTR_01.Load_XMT_datareg(Load_XMT_datareg);
		UART_XMTR_01.Byte_ready(Byte_ready);
		UART_XMTR_01.T_byte(T_byte);
		UART_XMTR_01.rst_b(rst_b);
		UART_XMTR_01.Serial_out(Serial_out);
		UART_XMTR_01.clk(clk);
	
	UART_XMTR_WRAP UART_XMTR_WRAP_01("UART_XMTR_WRAP_01");
		UART_XMTR_WRAP_01.DataBus(DataBus);
		UART_XMTR_WRAP_01.AddressBus(AddressBus);
		UART_XMTR_WRAP_01.ControlBus(ControlBus);
		UART_XMTR_WRAP_01.DataToUART(DataToUART);
		UART_XMTR_WRAP_01.Load_XMT_datareg(Load_XMT_datareg);
		UART_XMTR_WRAP_01.Byte_ready(Byte_ready);
		UART_XMTR_WRAP_01.T_byte(T_byte);
		UART_XMTR_WRAP_01.Breq(BREQ1);
		UART_XMTR_WRAP_01.Bgnt(BGNT1);
		UART_XMTR_WRAP_01.clk(clk);
		UART_XMTR_WRAP_01.bReset(rst_b);
	
	SRAM SRAM_01("SRAM_01");
		SRAM_01.InData(DataToSRAM);
		SRAM_01.OutData(DataFromSRAM);
		SRAM_01.Addr(AddrToSRAM);
		SRAM_01.bCE(bCE);
		SRAM_01.bWE(bWE);

	SRAM_WRAP SRAM_WRAP_01("SRAM_WRAP_01");
		SRAM_WRAP_01.DataBus(DataBus);
		SRAM_WRAP_01.AddressBus(AddressBus);
		SRAM_WRAP_01.ControlBus(ControlBus);
		SRAM_WRAP_01.InData(DataToSRAM);
		SRAM_WRAP_01.OutData(DataFromSRAM);
		SRAM_WRAP_01.Addr(AddrToSRAM);
		SRAM_WRAP_01.CE_b(bCE);
		SRAM_WRAP_01.WE_b(bWE);
		SRAM_WRAP_01.Breq(BREQ0);
		SRAM_WRAP_01.Bgnt(BGNT0);
		SRAM_WRAP_01.clk(clk);
		SRAM_WRAP_01.bReset(rst_b);

	Canny_Edge Canny_Edge_01("Canny_Edge_01");
		Canny_Edge_01.AddrRegRow(AddrRegRow);
		Canny_Edge_01.AddrRegCol(AddrRegCol);
		Canny_Edge_01.bWE(Canny_bWE);
		Canny_Edge_01.bCE(Canny_bCE);
		Canny_Edge_01.InData(CannyInData);
		Canny_Edge_01.OutData(CannyOutData);
		Canny_Edge_01.OPMode(OPMode);
		Canny_Edge_01.bOPEnable(bOPEnable);
		Canny_Edge_01.dReadReg(dReadReg);
		Canny_Edge_01.dWriteReg(dWriteReg);
		Canny_Edge_01.clk(clk);
		Canny_Edge_01.rst_b(rst_b);

	Canny_Edge_WRAP Canny_Edge_WRAP_01("Canny_Edge_WRAP_01");
		Canny_Edge_WRAP_01.DataBus(DataBus);
		Canny_Edge_WRAP_01.AddressBus(AddressBus);
		Canny_Edge_WRAP_01.ControlBus(ControlBus);
		Canny_Edge_WRAP_01.AddrRegRow(AddrRegRow);
		Canny_Edge_WRAP_01.AddrRegCol(AddrRegCol);
		Canny_Edge_WRAP_01.bWE(Canny_bWE);
		Canny_Edge_WRAP_01.bCE(Canny_bCE);
		Canny_Edge_WRAP_01.InDataToCanny(CannyInData);
		Canny_Edge_WRAP_01.OutDataFromCanny(CannyOutData);
		Canny_Edge_WRAP_01.OPMode(OPMode);
		Canny_Edge_WRAP_01.bOPEnable(bOPEnable);
		Canny_Edge_WRAP_01.dReadReg(dReadReg);
		Canny_Edge_WRAP_01.dWriteReg(dWriteReg);
		Canny_Edge_WRAP_01.Breq(BREQ3);
		Canny_Edge_WRAP_01.Bgnt(BGNT3);
		Canny_Edge_WRAP_01.clk(clk);
		Canny_Edge_WRAP_01.bReset(rst_b);
	
	Arbiter Arbiter_01("Arbiter_01");
                Arbiter_01.BREQ0(BREQ0);
                Arbiter_01.BREQ1(BREQ1);
                Arbiter_01.BREQ2(BREQ2);
                Arbiter_01.BREQ3(BREQ3);
                Arbiter_01.BGNT0(BGNT0);
                Arbiter_01.BGNT1(BGNT1);
                Arbiter_01.BGNT2(BGNT2);
                Arbiter_01.BGNT3(BGNT3);

	test TST("TST");
	        TST(clk, rst_b, Serial_out, BREQ2, BGNT2, DataBus, AddressBus, ControlBus); 

        
	// Open VCD file
	sc_trace_file *wf = sc_create_vcd_trace_file("wave");

	// Dump the desired signals
	// Add only signals you want to trace
	sc_trace(wf, rst_b, "rst_b");

	// Time to simulate
	TST.LoadBMPFile();
	sc_start();

	// Close the dump file
	sc_close_vcd_trace_file(wf);
	
	return 0;	// Terminate simulation
}
