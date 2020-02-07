// 1) Rewrite the SystemC code to use dynamic processes for sig_ctrl and reg_sig
// TODO use sc_spawn for each of them
//
// Random ideas for this homework:
// TODO maybe I have to spawn back and forth instead of waits?

SC_MODULE(signals){
    SC_CTOR(signals){
        SC_THREAD(run);
    }
    sc_event sigs_off, red_on;
    sc_event red_is_on, red_is_off;
    void sig_ctrl();
    void reg_sig();
}

void signals::run(){
    sc_spawn( sc_bind(&sig_ctrl));
    sc_spawn( sc_bind(&red_sig));
}


void signals::sig_ctrl(){
    enum directions {RED=‘R’, OFF=‘F’}; char dir;
    bool did_red = false;
    wait(SC_ZERO_TIME);
    while(true){ cin >> dir;
        switch(dir){
            case RED: sigs_off.notify(); red_on.notify();
              wait(red_is_on); did_red = true;
              break;
            case OFF: sigs_off.notify();
              if(did_red) wait(red_is_off);
                did_red = false;
              break;

        }
    }
}

void signals::red_sig(){
    while(true){
        wait(red_on); wait(3, SC_MS);
        cout << "Red light is turned on!" << endl;
        red_is_on.notify();
        wait(sigs_off); wait(10, SC_MS);
        cout << "Red light is turned off." << endl;
        red_is_off.notify();
    }
}
