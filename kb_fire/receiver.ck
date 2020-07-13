// receiver.ck, john eagle
// tubes instrument solo for kitty brazelton's 'fire', july 2020

// filepath
me.sourceDir() + "/audio/stove_compressed.wav" => string stove_samp;
me.sourceDir() + "audio/fire_hot_compressed.wav" => string crackle_samp;

// osc
OscIn in;
OscMsg msg;
10002 => in.port;
// start listening
in.listenAll();

// sound chains
Gain master => dac;
SndBuf stove => Envelope e1 => master;
SndBuf crackle => Envelope e2 => master;
Noise n => e1 => master;

10::samp => e1.duration => e2.duration;

1.0 => master.gain;
// read in buffers
stove.read(stove_samp);
crackle.read(crackle_samp);
48000 => int sampleRate;
<<< stove.length(), stove.samples() / sampleRate, "TIME", now >>>;

45 * sampleRate => int loopBack;

0 => int masterState;
int buff1State;
int buff2State;

// set tape heads to end
stove.samples() => stove.pos;
crackle.samples() => crackle.pos;

fun void osc_listener() {
    // MAIN
    while( true ) {
        // wait for an event
        in => now;
        while( in.recv(msg) != 0 ) {
            <<< "RECEIVED", msg.address >>>;
            // MASTER SWITCH
            if( msg.address == "/master" ) {
                <<< "receiver: MASTER", msg.getInt(0) >>>;
                // MASTER on
                if( msg.getInt(0) == 0 ) {
                    0 => buff1State => buff2State => masterState;
                    e1.keyOff();
                    e2.keyOff();
                    stove.samples() => stove.pos;
                    crackle.samples() => crackle.pos;
                }
                // MASTER OFF
                else if( msg.getInt(0) == 1 ) {
                    1 => buff1State => buff2State => masterState;
                    e1.keyOn();
                    e2.keyOn();
                    0 => stove.pos => crackle.pos;
                }
            }
            // stove buffer
            else if( msg.address == "/buff1" ) {
                <<< "receiver: BUFF 1 SWITCH" >>>;
                if( buff1State == 0 ) {
                    <<< "BUFF 1 ON" >>>;
                    0 => stove.pos;
                    e1.keyOn();
                    1 => buff1State;
                }
                else if( buff1State == 1 ) {
                    <<< "BUFF 1 OFF" >>>;
                    e1.keyOff();
                    stove.samples() => stove.pos;
                    0 => buff1State;
                }
            }
            // crackle buffer
            else if( msg.address == "/buff2" ) {
                <<< "receiver: BUFF 2 SWITCH" >>>;
                if( buff2State == 0 ) {
                    <<< "BUFF 2 ON" >>>;
                    0 => crackle.pos;
                    e2.keyOn();
                    1 => buff2State;
                }
                else if( buff2State == 1 ) {
                    <<< "BUFF 2 OFF" >>>;
                    e2.keyOff();
                    crackle.samples() => crackle.pos;
                    0 => buff2State;
                }
            }
        }
    }
}

fun void xfadeLoop( SndBuf s, Envelope e, int loopBack ) {
    e.time() => float fadeTime;
    e.keyOff();
    fadeTime::second => now;
    loopBack => s.pos;
    e.keyOn();
}

spork ~ osc_listener();

// MAIN LOOP
while( true )
{        
   if( stove.pos() == stove.samples() && ( masterState == 1 || buff1State == 1 ) ) {
       spork ~ xfadeLoop( stove, e1, loopBack );
       <<< "LOOPING" >>>;
    }
    else if( crackle.pos() == crackle.samples() && ( masterState == 1 || buff2State == 1) ) {
        spork ~ xfadeLoop( crackle, e2, loopBack );
        <<< "LOOPING" >>>;
    }
    1::second => now;
    <<< "STOVE:", stove.pos(), stove.samples() >>>;
    <<< "CRACKLE:", crackle.pos(), crackle.samples() >>>; 
}


<<< "END" >>>;