//===========================================
// Function : UART Transmitter
//===========================================
#include "UART_XMTR.h"

  // ----- Code Starts Here ----- 

  void UART_XMTR::Send_bit() {
	switch(IntState)
	{
		case STATE_IDLE:
                        bit_count = 0;
                        if(Load_XMT_datareg.read())
                            XMT_datareg = Data_Bus.read();
                        if(Byte_ready.read()){
                            XMT_shftreg = XMT_datareg;
                            XMT_shftreg = XMT_shftreg << 1;
                            NextIntState = STATE_WAITING;
                        } else {
                            NextIntState = STATE_IDLE; 
                        }
			break;
		case STATE_WAITING:
                        if(T_byte.read()){
                            XMT_shftreg[0] = 0;
                            NextIntState = STATE_SENDING;
                        }
                        else {
                            NextIntState = STATE_WAITING;
                        }
			break;
		case STATE_SENDING:
                        while(bit_count < 9){
                            XMT_shftreg = XMT_shftreg << 1;
                            bit_count++;
                        }
                        NextIntState = STATE_IDLE;
                        XMT_shftreg = 0x1ff;
                        break;
                default:{
                        NextIntState = STATE_IDLE;
                }
	}
        cout << "Sending " << XMT_shftreg[0] << endl;
	Serial_out.write(XMT_shftreg[0]);
  }

  void UART_XMTR::Initialize() {
	if(!rst_b.read()){
		IntState = STATE_IDLE;
		
		XMT_shftreg = 0x1ff;
		bit_count = 0;
	}
	else {
		IntState = NextIntState;
	}
  }
