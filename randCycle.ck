// sender.ck
// tubes instrument, John Eagle, May 2020

// ip addresses
"pione.local" => string pione;
"pitwo.local" => string pitwo;

// osc send
OscSend xmit1;
OscSend xmit2;
10002 => int port;

xmit1.setHost( pione, port);
xmit2.setHost( pitwo, port);

"/osc1, i" => string osc1;
"/osc2, i" => string osc2;

fun void send(OscSend xmit, string address, int noteState) {
    xmit.startMsg(address);
    noteState => xmit.addInt;
    <<< address, noteState >>>;
}

fun dur randTime( float min, float max ) {
    Math.random2f(min, max) => float timeVal;
    timeVal::second => dur length;
    return length;
}

fun void onOffrand( OscSend xmit, string address, float onMin, float onMax, float offMin, float offMax ) {
    while( true ) { 
        // on
        send(xmit, address, 1);
        randTime(onMin, onMax) => now;
        // off
        send(xmit, address, 0);
        randTime(offMin, offMax) => now;
    }
}

100 => int timeLength;
timeLength::second => dur duration;

// turn on all loops
spork ~ onOffrand( xmit1, osc1, 1.0, 10.0, 0.25, 4.0 );
spork ~ onOffrand( xmit1, osc2, 1.0, 10.0, 0.25, 4.0 );
spork ~ onOffrand( xmit2, osc1, 1.0, 10.0, 0.25, 4.0 );
spork ~ onOffrand( xmit2, osc2, 1.0, 10.0, 0.25, 4.0 );
duration => now;
