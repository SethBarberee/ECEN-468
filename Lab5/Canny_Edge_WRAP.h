//===========================================
// Function : UART_XMTR_WRAP.h 
//===========================================
#include "systemc.h"

#define WORD_SIZE		8	// 8 bits

SC_MODULE (Canny_Edge_WRAP){
  // Inter-connect to Canny_Edge
  sc_out < sc_uint < 3 > >		AddrRegRow;
  sc_out < sc_uint < 3 > >		AddrRegCol;
  sc_out < bool >				bWE;
  sc_out < bool >				bCE;
  sc_out < sc_uint <WORD_SIZE > >	InDataToCanny;
  sc_in < sc_uint <WORD_SIZE > >	OutDataFromCanny;
  
  sc_out < sc_uint < 3 > >	OPMode;
  sc_out < bool >			bOPEnable;
  sc_out < sc_uint < 4 > >	dReadReg;
  sc_out < sc_uint < 4 > >	dWriteReg;

  // to TEST-BENCH
  sc_in < bool >			bReset;
  sc_in	< bool >		clk;

  // Inter-connect to Arbiter
  sc_out < bool >			Breq;
  sc_in	< bool >		Bgnt;

  // Inter-connect to System Bus
  sc_inout_rv < 8 >  		DataBus;
  sc_inout_rv < 32 >		AddressBus;
  sc_inout_rv < 1 > 		ControlBus;

  // Internal Variable
  sc_uint < 1 >               IntEnable;
  sc_uint < 4 >			AddrDecoded;

  // ----- Code Starts Here ----- 
  void Function_Canny_Edge_WRAP();
  void Bus_Control();

  // ----- Constructor for the SC_MODULE -----
  SC_CTOR(Canny_Edge_WRAP) {
    	SC_METHOD(Function_Canny_Edge_WRAP);
    	sensitive << clk.pos() << bReset.neg();

    	SC_METHOD(Bus_Control);
    	sensitive << clk.pos() ;
        
  }
};

