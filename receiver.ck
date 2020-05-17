// receiver.ck
// tubes instrument, John Eagle, May 2020

// osc
OscIn in;
OscMsg msg;

10002 => in.port;
in.listenAll;

// sound chains
Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.95 => n1.gain;
0.95 => n2.gain;

int noteState;

while( true ) {
    e1.keyOn();
    1::second => now;
    e1.keyOff();
    1::second => now;
    in => now;
    while( in.recv(msg) ) {
        // osc num
        if( msg.address == "/osc1" ) {
            <<< msg >>>;
            msg.getInt(0) => noteState;
            // On
            if( noteState == 1 ) e1.keyOn();
            // Off
            if( noteState == 0 ) e1.keyOff();
        }
        
    }
}