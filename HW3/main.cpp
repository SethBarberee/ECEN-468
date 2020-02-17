// 1) Rewrite the SystemC code to use dynamic processes for sig_ctrl and reg_sig

#define SC_INCLUDE_DYNAMIC_PROCESSES

class signals : public sc_module {
    public:
        SC_HAS_PROCESS(signals);
        signals(sc_module_name nm):sc_module(nm){
            SC_METHOD(run);
        }

        void run(){
            sc_spawn( sc_bind(&signals::sig_ctrl, this));
        }
        void sig_ctrl(){
            enum directions {RED=‘R’, OFF=‘F’}; char dir;
            bool did_red = false;
            //wait(SC_ZERO_TIME);
            while(true){ cin >> dir;
                switch(dir){
                    case RED: 
                        // Spawn and wait for it
                        sc_proess_handle h = sc_spawn( sc_bind(&signals::red_sig, this true));
                        wait(h.terminated_event());
                        did_red = true;
                        break;
                    case OFF: 
                        // Spawn an wait for it
                        sc_proess_handle h = sc_spawn( sc_bind(&signals::red_sig, this, false));
                        wait(h.terminated_event());
                        did_red = false;
                        break;

                }
            }
        }
        // We'll use an argument to determine if we need to turn off the light
        int red_sig(bool on){
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
}
