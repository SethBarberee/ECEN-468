//===========================================
// Function : Arbiter.h 
//===========================================
#include "systemc.h"

#define NUMUNIT   4

SC_MODULE (Arbiter) {
  sc_in < bool > BREQ3, BREQ2, BREQ1, BREQ0;
  sc_out < bool > BGNT3, BGNT2, BGNT1, BGNT0;

  sc_uint < 4 >             IntGrant;

  void Function_Arbiter();

  // ----- Constructor for the SC_MODULE -----
  SC_CTOR(Arbiter) {
    SC_METHOD(Function_Arbiter);
    sensitive << BREQ1 << BREQ2 << BREQ0 << BREQ3;

    }
};

