Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.95 => n1.gain;
0.95 => n2.gain;

fun dur randTime( float min, float, max ) {
	Math.random2f(min, max) => float timeVal;
	timeVal::second => dur length;
	return length;
}

while(true) {
	e1.keyOn();
	randTime(0.25, 2.0) => now;
    
	e1.keyOn();	
	randTime(1.0, 10.0) => now;
	e1.keyOff();
	randTime(2.0) => now;
	e2.keyOn();
	randTime(6.0) => now;
	e2.keyOff();
	randTime(2.0) => now;
}
