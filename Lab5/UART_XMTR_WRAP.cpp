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
                        sc_bv <32> full_address = AddressBus.read();
                        DataToUART.write(DataBus.read());
                        sc_logic logic = full_address[0] & "0x1";
                        // Bit 0 is Load_XMT_datareg
                        //cout << "Load_XMT_datareg: " << logic.to_bool() << endl;
                        Load_XMT_datareg.write(logic.to_bool());
                        // Bit 1 is Byte_ready
                        logic = full_address[1] & "0x1";
                        //cout << "Byte_ready: " << logic.to_bool() << endl;
                        Byte_ready.write(logic.to_bool());
                        // Bit 2 is T_byte
                        logic = full_address[2] & "0x1";
                        //cout << "T_Byte: " << logic.to_bool() << endl;
                        T_byte.write(logic.to_bool());
                        cout << endl;
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
