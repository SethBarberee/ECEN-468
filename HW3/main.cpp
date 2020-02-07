// 1) Rewrite the SystemC code to use dynamic processes for sig_ctrl and reg_sig
// TODO use sc_spawn for each of them
//
// Random ideas for this homework:
// TODO maybe I have to spawn back and forth instead of waits?

SC_MODULE(signals){
    SC_CTOR(signals){
        SC_THREAD(run);
    }
    void sig_ctrl();
    void reg_sig();
}

void signals::run(){
    sc_spawn( sc_bind(&sig_ctrl));
}


void signals::sig_ctrl(){
    enum directions {RED=‘R’, OFF=‘F’}; char dir;
    bool did_red = false;
    //wait(SC_ZERO_TIME);
    while(true){ cin >> dir;
        switch(dir){
            case RED: 
              // Spawn and wait for it
              sc_proess_handle h = sc_spawn( sc_bind(&red_sig, true));
              wait(h.terminated_event());
              did_red = true;
              break;
            case OFF: 
              // Spawn an wait for it
              sc_proess_handle h = sc_spawn( sc_bind(&red_sig, false));
              wait(h.terminated_event());
              did_red = false;
              break;

        }
    }
}

// We'll use an argument to determine if we need to turn off the light
int signals::red_sig(bool on){
    // On or off?
    if(on){
        wait(3, SC_MS);
        cout << "Red light is turned on!" << endl;
        return 1;
    }
    else {
        wait(10, SC_MS);
        cout << "Red light is turned off." << endl;
        return 0;
    }
}
