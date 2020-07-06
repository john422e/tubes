// sender.ck, john eagle
// tubes instrument solo for kitty brazelton's 'fire', july 2020

// ip addresses
"pione.local" => string pione;
"pitwo.local" => string pitwo;

// osc send
OscSend xmit1;
OscSend xmit2;
10002 => int port;

xmit1.setHost( pione, port );
xmit2.setHost( pitwo, port );

"/buff1, i" => string buff1;
"/buff2, i" => string buff2;

fun void send( OscSend xmit, string address, int buffState, int loopBack ) {
    xmit.startMsg(address);
    // add buffState (0 or 1, on/off)
    buffState => xmit.addInt;
    // add loopBack (where to loop back to for loop)
    loopBack => xmit.addInt;
    <<< address, buffState, loopBack >>>;
}

360 => int timeLength; // total length in seconds
timeLength::second => dur duration;
45 => int loopBack; // use this later for loop point

// send
while( true )
{
    send(xmit1, buff1, 1, loopBack);
    send(xmit2, buff2, 1, loopBack);
    duration => now;
}