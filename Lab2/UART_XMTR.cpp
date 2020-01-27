//===========================================
// Function : UART Transmitter
//===========================================
#include "UART_XMTR.h"

  // ----- Code Starts Here ----- 

  void UART_XMTR::Send_bit() {
	switch(IntState)
	{
		case STATE_IDLE:
                        if(Load_XMT_datareg.read())
                            // Get data register ready
                            bit_count = 0;
                            XMT_datareg = Data_Bus.read();
                        if(Byte_ready.read()){
                            // Set shift register equal to data
                            XMT_shftreg = XMT_datareg;
                            // Shift right and set low bit to 1
                            XMT_shftreg = XMT_shftreg << 1;
                            XMT_shftreg[0] = 1;
                            NextIntState = STATE_WAITING;
                        } else {
                            // We need to wait until we have our data byte ready
                            NextIntState = STATE_IDLE; 
                        }
			break;
		case STATE_WAITING:
                        if(T_byte.read()){
                            // We're ready to send so set lower bit to 0 for start
                            XMT_shftreg[0] = 0;
                            NextIntState = STATE_SENDING;
                        }
                        else {
                            // Loop until T_byte is good
                            NextIntState = STATE_WAITING;
                        }
			break;
		case STATE_SENDING:
                        while(bit_count < WORD_SIZE + 1){
                            // Continue to shift right and shift 1 in
                            // Since 1 is our stop bit
                            cout << "Sending " << XMT_shftreg[0] << endl;
                            XMT_shftreg = XMT_shftreg >> 1;
                            XMT_shftreg[WORD_SIZE - 1] = 1;
                            bit_count++;
                        }
                        // Reset back to idle when done
                        NextIntState = STATE_IDLE;
                        XMT_shftreg = 0x1ff;
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
        Send_bit();
	}
  }
