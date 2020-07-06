// receiver.ck, john eagle
// tubes instrument solo for kitty brazelton's 'fire', july 2020

// filepath
me.sourceDir() + "audio/fire_hot_compressed.wav" => string filename;

// osc
OscRecv recv;
10002 => recv.port;
// start listening
recv.listen();

"/buff1, i" => string buff1;
"/buff2, i" => string buff2;

recv.event(buff1) @=> OscEvent oe1;
recv.event(buff2) @=> OscEvent oe2;

// sound chains
SndBuf fire => Envelope e => dac;

10::samp => e.duration;

0.95 => fire.gain;
fire.read(filename);
48000 => int sampleRate;
<<< fire.length(), fire.samples() / sampleRate, "TIME", now >>>;

45 * sampleRate => int loopBack;

int buffState;

0 => fire.pos;

e.keyOn();

while( true )
{        
    <<< fire.pos(), fire.samples() >>>;
    1::second => now;
    
    if ( fire.pos() >= fire.samples()-1 ) {
        <<< "END" >>>;
        e.keyOff();
        10::samp => now;
        loopBack => fire.pos;
        5::ms => now;
        e.keyOn();
    }
}