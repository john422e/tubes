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

"/osc1, i" => string osc1Address;
"/osc2, i" => string osc2Address;


// send
while( true )
{
    xmit1.startMsg(osc1Address, 1);
    <<< 1, "ON" >>>;
    2::second => now;
    xmit1.startMsg(osc1Address, 0);
    <<< 1, "OFF" >>>;
    2::second => now;
    xmit2.startMsg(osc1Address, 1);
    <<< 3, "ON" >>>;
    2::second => now;
    xmit2.startMsg(osc1Address, 0);
    <<< 3, "OFF" >>>;
    2::second => now;
}