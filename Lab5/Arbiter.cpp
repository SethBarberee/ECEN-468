//===========================================
// Function : Arbiter.cpp
//===========================================
#include "Arbiter.h"

void Arbiter::Function_Arbiter() {
	IntGrant = 0;

	if(BREQ2.read())	IntGrant = 4;
        else if(BREQ0.read())	IntGrant = 1;
        else if(BREQ1.read())	IntGrant = 2;
        else if(BREQ3.read())	IntGrant = 8;

  	  BGNT3.write(IntGrant>>3);
        BGNT2.write(IntGrant>>2);
        BGNT1.write(IntGrant>>1);
        BGNT0.write(IntGrant>>0);
}

