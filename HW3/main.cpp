// 1) Rewrite the SystemC code to use dynamic processes for sig_ctrl and reg_sig

SC_MODULE(signals){
    SC_CTOR(signals){
        SC_THREAD(sig_ctrl);
        SC_THREAD(red_sig);
    }
    sc_event sigs_off, red_on;
    sc_event red_is_on, red_is_off;
    void sig_ctrl();
    void reg_sig();
}


