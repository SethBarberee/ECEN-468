// A)
If wait(SC_ZERO_TIME) is not used, customer2 will most likely always be first based on the later questions in simulation. One customer would be always served while the other might not even be filled.

If wait(SC_ZERO_TIME) is used, the ordering of customer1 and customer2 running could vary each simulation.

// B)
If tank_full.notify() is used, this will force whatever customer is waiting to immediately act, and this might end up with a loop of only one customer being helped.

If tank_full.notify(SC_ZERO_TIME) is used, this allows both customers to queue and receive both events.

////////////////////////////////////////////////////////////
#include <systemc>


SC_MODULE(gas_station){
    sc_event request1, request2, tank_full;
    SC_CTOR(gas_station){
        SC_METHOD(attendant); sensitive << request1 << request2;
        SC_THREAD(customer1); sensitive << tank_full;
        SC_THREAD(customer2); 
    }
    void attendant;
    void customer1;
    void customer2;
}

///////////////////////////////////////////////////////////////

// C)

void gas_station::customer2(){
   while(true){
       wait(SC_ZERO_TIME); tank2 = 0;
       do {
           request2.notify(SC_ZERO_TIME);
           wait(tank_full);
       } while (tank2 == 0);
   } 
}

///////////////////////////////////////////////////////////////

// D)

SC_MODULE(gas_station){
    sc_event request1, request2, tank_full;
    SC_CTOR(gas_station){
        SC_THREAD(attendant);
        SC_THREAD(customer1); sensitive << tank_full;
        SC_THREAD(customer2); 
    }
    void attendant;
    void customer1;
    void customer2;
}

void gas_station::attendant(){
    while(true){
        wait(request1 | request2); // listen for request1 or request2
        tank_full.notify(SC_ZERO_TIME); // notify tank full when done
    }
}
