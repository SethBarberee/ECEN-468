//===========================================
// Function : Asynchronous SRAM 
//===========================================
#include "systemc.h"

#define DATA_WIDTH        8 
#define ADDR_WIDTH        18 
#define RAM_DEPTH         1 << ADDR_WIDTH

SC_MODULE (RAM) {
  // ----- Declare Input/Output ports -----
    sc_in < sc_uint<ADDR_WIDTH> > 	tAddr ;
    sc_in < bool > 			tbWE;
    sc_in < bool > 			tbCE;
    sc_in < sc_uint<DATA_WIDTH> > 	tInData;
    sc_out < sc_uint<DATA_WIDTH> > 	tOutData;

  // ----- Internal variables -----
  // ...
  int internal_memory[RAM_WIDTH, DATA_WIDTH];
  int location_row;

  // ----- Code Starts Here ----- 
 
  void function_decode(){
    unsigned int half = ADDR_WIDTH / 2;
    // top 9 bits
    unsigned int top_half_addr = tAddr.range(0, half);
    location_row = top_half_addr;
    // bottom 9 bits
    unsigned int bottom_half_addr = tAddr.range(half + 1, ADDR_WIDTH);
    location_row = location_row << 9;
    location_row = location_row & bottom_half_addr;
  }

  // Memory Write Block 
  // Write Operation : When we_b = 0, ce_b = 0
  void function_write(){
      if(!(tbWE.read()) && !(tbCE.read())){
          function_decode();
          internal_memory[location_row] = tInData.read();
      }
  }

  // Memory Read Block 
  // Read Operation : When we_b = 1, ce_b = 0
  void function_read(){
      if((tbWE.read()) && !(tbCE.read())){
          function_decode();
          tOutData.write(nternal_memory[location_row]);
      }
  }


  // ----- Constructor for the SC_MODULE -----
  // sensitivity list
  SC_CTOR(RAM) {
    SC_METHOD(function_write);
	sensitive << tbWE << tbCE << tAddr << tInData;
    SC_METHOD(function_read);
	sensitive << tbWE << tbCE << tAddr;
  }
};

