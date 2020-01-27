//===========================================
// Function : Arbiter.h 
//===========================================
#include "systemc.h"

#define NUMUNIT   3

SC_MODULE (Arbiter) {
  sc_in < bool > BREQ2, BREQ1, BREQ0;
  sc_out < bool > BGNT2, BGNT1, BGNT0;

  sc_uint < 3 >             IntGrant;

  void Function_Arbiter();

  // ----- Constructor for the SC_MODULE -----
  // sensitivity list
  SC_CTOR(Arbiter) {
    SC_METHOD(Function_Arbiter);
    sensitive << BREQ1 << BREQ2 << BREQ0;
    }
};

