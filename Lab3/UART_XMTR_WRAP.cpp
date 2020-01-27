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
                        sc_bv<3> logic = AddressBus.read() << 12;
                        // Bit 2 is T_byte
                        T_byte.write(logic.get_bit(2));
                        // Bit 1 is Byte_ready
                        Byte_ready.write(logic.get_bit(1));
                        // Bit 0 is Load_XMT_datareg
                        Byte_ready.write(logic.get_bit(0));
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
