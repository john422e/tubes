// sender.ck
// tubes instrument, John Eagle, May 2020

// ip addresses
"pione.local" => string pione;
"pitwo.local" => string pitwo;

// osc send
//OscSend xmit1;
//OscSend xmit2;
10002 => int port;

OscOut out[2];
out[0].dest(pione, port);
out[1].dest(pitwo, port);

//xmit1.setHost( pione, port);
//xmit2.setHost( pitwo, port);

"/osc1" => string osc1Address;
"/osc2" => string osc2Address;


// send
while( true )
{
    out[0].start(osc1Address);
    out[0].add(1);
    out[0].send();
    <<< 1, "ON" >>>;
    2::second => now;
    out[0].start(osc1Address);
    out[0].add(0);
    out[0].send();
    <<< 1, "OFF" >>>;
    2::second => now;
    out[1].start(osc1Address);
    out[1].add(1);
    out[1].send();
    <<< 3, "ON" >>>;
    2::second => now;
    out[1].start(osc1Address);
    out[1].add(0);
    <<< out[1].msg() >>>;
    out[1].send();
    <<< 3, "OFF" >>>;
    2::second => now;
}