// sender.ck, john eagle
// tubes instrument solo for kitty brazelton's 'fire', july 2020

/*
'1' turns pione, buff1 on/off
'2' turns pione, buff2 on/off
'3' turns pitwo, buff1 on/off
'4' turns pitwo, buff2 on/off
master state is in sender.ck, receiver accepts value
individual buff states are stored in receiver.ck, master just sends trigger
*/

// HID setup
Hid hi;
HidMsg msg;
// which keyboard
1 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;
// open keyboard
if( !hi.openKeyboard( device ) ) me.exit();
// else
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// ip addresses
"pione.local" => string pione;
"pitwo.local" => string pitwo;
//"127.0.0.1" => string pione;
//"127.0.0.1" => string pitwo;

// osc send
OscOut xmit1;
OscOut xmit2;
10002 => int port;

// set host, port
xmit1.dest( pione, port );
xmit2.dest( pitwo, port );

"/buff1" => string buff1;
"/buff2" => string buff2;
"/master" => string master;

0 => int masterState;

fun void masterSoundSwitch() {
    if( 0 == masterState ) {
        1 => masterState;
        <<< "MASTER ON", masterState >>>;
    }
    else {
        0 => masterState;
        <<< "sender: MASTER OFF", masterState >>>;
    }
    send( xmit1, master, masterState );
    send( xmit2, master, masterState );
}
fun void ui() {
    // event loop
    while( true )
    {
        // wait for event
        hi => now;
        
        // get message
        while( hi.recv( msg ) )
        {
            // action type
            if( msg.isButtonDown() )
            {
                //<<< msg.key >>>; //"key down:", msg.which, "code", msg.key, "usb key", msg.ascii, "ascii" >>>;
                // master on/off
                if( msg.key == 44 ) {
                    masterSoundSwitch();
                }
                // turn pione buff 1 on/off
                else if( msg.key == 30 ) {
                    <<< "sender: pione buff 1" >>>;
                    send( xmit1, buff1 );
                }
                // turn pione buff 2 on/off
                else if( msg.key == 31 ) {
                    <<< "sender: pione buff 2" >>>;
                    send( xmit1, buff2 );
                }
                // turn pitwo buff 1 on/off
                else if( msg.key == 32 ) {
                    <<< "sender: pitwo buff 1" >>>;
                    send( xmit2, buff1 );
                }
                // turn pitwo buff 2 on/off
                else if( msg.key == 33 ) {
                    <<< "sender: pitwo buff 2" >>>;
                    send( xmit2, buff2 );
                }
            }
        }
    }
}

fun void send( OscOut xmit, string address ) {
    xmit.start(address);
    xmit.send();
}

fun void send( OscOut xmit, string address, int arg ) {
    xmit.start(address);
    arg => xmit.add;
    xmit.send();
}

fun void send( OscOut xmit, string address, int arg1, int arg2 ) {
    xmit.start(address);
    arg1 => xmit.add;
    arg2 => xmit.add;
    xmit.send();
}

360 => int timeLength; // total length in seconds
timeLength::second => dur duration;
//45 => int loopBack; // use this later for loop point

// accept keyboard input
spork ~ ui(); 

// run loop for fixed duration
while( true )
{
    duration => now;
}