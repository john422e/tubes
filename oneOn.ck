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

360 => int timeLength;
timeLength::second => dur duration;

// send
while( true )
{
    send(xmit1, osc1, 1);
    duration => now;
}