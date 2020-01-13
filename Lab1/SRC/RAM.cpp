//===========================================
// Function : Asynchronous SRAM 
//===========================================
#include "systemc.h"

#define DATA_WIDTH        8 
#define ADDR_WIDTH        18 
#define RAM_DEPTH         1 << ADDR_WIDTH

SC_MODULE (RAM) {
  // ----- Declare Input/Output ports -----
  // ...
  // ...

  // ----- Internal variables -----
  // ...

  // ----- Code Starts Here ----- 
  // Memory Write Block 
  // Write Operation : When we_b = 0, ce_b = 0
  // ...

  // Memory Read Block 
  // Read Operation : When we_b = 1, ce_b = 0
  // ...

  // ----- Constructor for the SC_MODULE -----
  // sensitivity list
  SC_CTOR(RAM) {
    // ...
	// ...
  }
};

