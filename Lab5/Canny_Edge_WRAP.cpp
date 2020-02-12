//===========================================
// Function : Canny_Edge_WRAP.cpp
//===========================================
#include "Canny_Edge_WRAP.h"

void Canny_Edge_WRAP::Bus_Control() {
    	uint bControl = ControlBus.read().to_uint();
	uint data = OutDataFromCanny.read().to_uint();

	if(IntEnable){
		ControlBus.write(0);
	}
	else {
		ControlBus.write("Z");
	}
	#if defined (_DEBUG_)
      cout << "@" << sc_time_stamp() << " >> ControlBus: " << bControl << endl;
	#endif
  }

  void  Canny_Edge_WRAP::Function_Canny_Edge_WRAP() {
    	AddrDecoded = AddressBus.read().to_uint() >> 28;
	
	// Signal Parcing
        bool		Canny_bOpEnable = AddressBus.read()[27].to_bool();
	bool		Canny_bWE = AddressBus.read()[1].to_bool();
	bool		Canny_bCE = AddressBus.read()[0].to_bool();

	// You can add something if you need.
	// ...
	// ...
	
	if(!bReset.read()){
		IntEnable = 0;
		Breq.write(0);
	}
	else if(IntEnable){
		if(AddrDecoded == 0x4) {// Address Decoding Matching
			// Insert your code here
			// for AddrRegRow, AddrRegCol, bWE, bCE, OPMode, bOPEnable, dReadReg, dWriteReg
                        // Bit [24 - 26 is OPMode
                        // Bit [20 - 23] is dWriteReg
                        // Bit [16 - 19] is dReadReg
                        // Bit [5 - 7] is AddrRegRow
                        // Bit [2 - 4] is AddrRegCol
                        bOpEnable.write(Canny_bOpEnable);
                        bWE.write(Canny_bWE);
                        bCE.write(Canny_bCE);
	
			if(!Canny_bCE && !Canny_bWE){
				InDataToCanny.write(DataBus.read());
				DataBus.write("ZZZZZZZZ");
			}
			else if(!Canny_bCE && Canny_bWE){
				DataBus.write(OutDataFromCanny.read());
			}
			else {
				DataBus.write("ZZZZZZZZ");
			}
		}
		else {
			IntEnable = 0;
			Breq.write(0);
			DataBus.write("ZZZZZZZZ");
		}
	}
	else {	// !IntEnable
		if(Bgnt) {
			IntEnable = 1;
			Breq.write(0);
		}
		else if(AddrDecoded == 0x4){
			IntEnable = 0;
			Breq.write(1);
		}
		else {
			IntEnable = 0;
			Breq.write(0);
		}
	}
        
	#if defined (_DEBUG_)
      cout << "@" << sc_time_stamp() << " >> IntEnable: " << IntEnable << endl;
	#endif
 }
