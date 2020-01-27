//===========================================
// Function : UART_XMTR_WRAP.cpp
//===========================================
#include "UART_XMTR_WRAP.h"

// ----- Code Starts Here ----- 
void UART_XMTR_WRAP::Bus_Control() {
	uint bControl = ControlBus.read().to_uint();
	if(IntEnable){
		ControlBus.write(0);
	}
	else {
		ControlBus.write("Z");
	}
}

void UART_XMTR_WRAP::Function_UART_XMTR_WRAP() {
	AddrDecoded = AddressBus.read().to_uint() >> 28;

 
	if(!bReset.read()){
		IntEnable = 0;
		Breq.write(0);
	}else if(IntEnable){
		if(AddrDecoded == 0x2) {// Address Decoding Matching
                        // Bit 2 is T_byte
                        T_byte.write(AddressBus.read() & 0x000d);
                        // Bit 1 is Byte_ready
                        Byte_ready.write(AddressBus.read() & 0x000e);
                        // Bit 0 is Load_XMT_datareg
                        Load_XMT_datareg.write(AddressBus.read() & 0x000f);
                        DataToUART.write(DataBus.read());
		}else {
			IntEnable = 0;
			Breq.write(0);
		}
	}else {	// !IntEnable
		if(Bgnt) {
			IntEnable = 1;
			Breq.write(0);
		}else if(AddrDecoded == 0x2){
			IntEnable = 0;
			Breq.write(1);
		}else {
			IntEnable = 0;
			Breq.write(0);
		}
	}
 }
