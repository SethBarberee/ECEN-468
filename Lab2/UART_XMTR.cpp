//===========================================
// Function : UART Transmitter
//===========================================
#include "UART_XMTR.h"

  // ----- Code Starts Here ----- 

  void UART_XMTR::Send_bit() {
	switch(IntState)
	{
		case STATE_IDLE:
			// ...
			// Insert your code here
			// ...
			break;
		case STATE_WAITING:
			// ...
			// Insert your code here
			// ...
			break;
		case STATE_SENDING:
			// ...
			// Insert your code here
			// ...
            break;
        default:{
		NextIntState = STATE_IDLE;
        }
	}
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
