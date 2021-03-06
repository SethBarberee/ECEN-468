SC_MODULE(iEvent){
    SC_CTOR(iEvent):i(0),j(0){
        cnt.write(0);
        SC_THREAD(proc_B);
        SC_THREAD(proc_A);
    }
    int i, j;
    sc_event event_A;
    sc_signal<int> cnt;
    void proc_A(){
        while ( TRUE ) {
            wait(10, SC_NS);  i++;
            cout << “A occurs” << i << endl;
            event_A.notify();
        }
    }
    void proc_B(){
        while ( TRUE ) {
            cnt.write(j);
            wait(event_A);  
            j++;
            cout << “A at” << j << “ cnt “ << cnt.read() << endl;
        }
    }
}
