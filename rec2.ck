// receiver.ck
// tubes instrument, John Eagle, May 2020

// osc
OscRecv recv;
10002 => recv.port;
// start listening
recv.listen();

recv.event("/osc1, i") @=> OscEvent oe1;
recv.event("/osc2, i") @=> OscEvent oe2;

// sound chains
Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.95 => n1.gain;
0.95 => n2.gain;

int noteState;

while( true ) {
    oe1 => now;
    while( oe1.nextMsg() != 0 ) {
        oe1.getInt() => noteState;
        <<< noteState >>>;
        // On
        if( noteState == 1 ) e1.keyOn();
        // Off
        if( noteState == 0 ) e1.keyOff();        
    }
    oe2 => now;
    while( oe2.nextMsg() != 0 ) {
        oe2.getInt() => noteState;
        <<< noteState >>>;
        // On
        if( noteState == 1 ) e2.keyOn();
        // Off
        if( noteState == 0 ) e2.keyOff();        
    }
}