//===========================================
// Function : SRAM_WRAP.cpp
//===========================================
#include "SRAM_WRAP.h"

// ----- Code Starts Here ----- 
void SRAM_WRAP::Bus_Control() {
	sc_uint <4> Adr = AddressBus.read().to_uint() >> 28;
	sc_uint <1> bWRITE = (AddressBus.read().to_uint() >> 18) & 0x1;
 
	uint data = OutData.read().to_uint();
	uint adr = AddressBus.read().to_uint();
	
	if(IntEnable){
		ControlBus.write(0);
	}
	else {
		ControlBus.write("Z");
	}

	if(IntEnable){
	 	if(Adr == 0x1 && bWRITE ==1)
			DataBus.write(data);
		else
			DataBus.write("ZZZZZZZZ");
	}
	else {
		DataBus.write("ZZZZZZZZ");
	}
}

void SRAM_WRAP::Function_SRAM_WRAP() {
	AddrDecoded = AddressBus.read().to_uint() >> 28; 

	if(!bReset.read()){
		IntEnable = 0;
		Breq.write(0);
	}
	else if(IntEnable){
		if(AddrDecoded == 0x1) {// Address Decoding Matching
                        sc_bv<20> logic = AddressBus.read() << 12;
                        // Bit 19 is CE_b
                        CE_b.write(logic.get_bit(19));
                        // Bit 18 is WE_b
                        WE_b.write(logic.get_bit(18));
                        // Bits [17:0] is Addr
                        sc_uint<18> data_to_write = logic.to_uint() << 2;
                        Addr.write(data_to_write);
                        OutData.write(DataBus.read().to_uint());
		}
		else {
			IntEnable = 0;
			Breq.write(0);
		}
	}
	else {	// !IntEnable
		if(Bgnt) {
			IntEnable = 1;
			Breq.write(0);
		}
		else if(AddrDecoded == 0x1){
			IntEnable = 0;
			Breq.write(1);
		}
		else {
			IntEnable = 0;
			Breq.write(0);
		}
	}
 }