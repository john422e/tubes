// receiver.ck
// tubes instrument, John Eagle, May 2020

// osc
OscRecv recv;
10002 => recv.port;
// start listening
recv.isten();

recv.event("/osc1, i") @=> OscEvent oe;

// sound chains
Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.95 => n1.gain;
0.95 => n2.gain;

int noteState;

while( true ) {
    //e1.keyOn();
    //1::second => now;
    //e1.keyOff();
    //1::second => now;
    oe => now;
    while( oe.nextMsg() != 0 ) {
        oe.getInt() => noteState;
        <<< noteState >>>;
        // On
        if( noteState == 1 ) e1.keyOn();
        // Off
        if( noteState == 0 ) e1.keyOff();        
    }
}