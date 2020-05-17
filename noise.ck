Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.5 => n1.gain;
0.5 => n2.gain;

2.0 => float timeStep;
timeStep::second => dur timeVal;

while(true) {
	e1.keyOn();
	timeVal => now;
	e1.keyOff();
	timeVal => now;
	e2.keyOn();
	timeVal => now;
	e2.keyOff();
	timeVal => now;
}
