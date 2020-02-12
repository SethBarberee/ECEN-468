//===========================================
// Function : Asynchronous SSRAM 
//===========================================
#include "systemc.h"

#define DATA_WIDTH        8 
#define ADDR_WIDTH        18 
#define SRAM_DEPTH         1 << ADDR_WIDTH

SC_MODULE (SRAM) {
  // ----- Declare Input/Output ports -----
    sc_in_rv < ADDR_WIDTH > 	Addr ;
    sc_in < bool > 			bWE;
    sc_in < bool > 			bCE;
    sc_in_rv < DATA_WIDTH  > 	InData;
    sc_out_rv < DATA_WIDTH  >	OutData;

  // ----- Internal variables -----
  // ...
  sc_uint <DATA_WIDTH> internal_memory[SRAM_DEPTH]; // 2D bit vector of our data
  uint data, adr; // we'll use this to store where we are read/write from

  // ----- Code Starts Here ----- 
  // Memory Write Block 
  // Write Operation : When we_b = 0, ce_b = 0
  void function_write(){
      if(!(bWE.read()) && !(bCE.read())){
          data = InData.read().to_uint();
          adr = Addr.read().to_uint();
          cout << "Writing " << InData.read() << " to location " << adr << endl;
          internal_memory[adr] = data;
      }
  }

  // Memory Read Block 
  // Read Operation : When we_b = 1, ce_b = 0
  void function_read(){
      if((bWE.read()) && !(bCE.read())){
          adr = Addr.read().to_uint();
          cout << "Reading " << internal_memory[adr] << " from " << adr << endl; 
          OutData.write(internal_memory[adr]);
      }
  }


  // ----- Constructor for the SC_MODULE -----
  // sensitivity list
  SC_CTOR(SRAM) {
    SC_METHOD(function_write);
        // recompute if bWE/bCE/Addr/InData change
	sensitive << bWE << bCE << Addr << InData;
    SC_METHOD(function_read);
        // recompute if bWE/bCE/Addr change
	sensitive << bWE << bCE << Addr;
  }
};

