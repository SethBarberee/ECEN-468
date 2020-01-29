/* 
Consider the shift register example on page 11 of Lecture 6. Please write SystemC code to model this shift register and ensure that your code always simulates correctly despite the random execution order at each simulated time moment.
  */

// 1) Write your code without using sc_signal.
SC_MODULE(shift_register){
    
    sc_bit Q1;
    sc_bit Q2;
    sc_bit Q3;
    sc_bit Q4;
    sc_in<sc_bit> Data;

    void update(){
        // TODO no gurantee on order... how to fix this
        // Slides suggest a 2-deep FIFO
        Q4 = Q3;
        Q3 = Q2;
        Q2 = Q1;
        Q1 = Data.read();
    }

    SC_CTOR(gas_station){
        SC_METHOD(update); sensitive << Data;
    }
    void update;
}

// 2) Write your code using sc_signal
SC_MODULE(shift_register){
    sc_signal<sc_bit> Q1;
    sc_signal<sc_bit> Q2;
    sc_signal<sc_bit> Q3;
    sc_signal<sc_bit> Q4;

    sc_in<sc_bit> Data;

    void update(){
        Q1.write(Data.read()); // Q1 will be Data
        Q2.write(Q1.read()); // Q2 will be what Q1 was previously
        Q3.write(Q2.read()); // Q2 will be what Q1 was previously 
        Q4.write(Q3.read()); // Q2 will be what Q1 was previously 
    }

    SC_CTOR(gas_station){
        SC_METHOD(update); sensitive << Data;
    }
    void update;
}
