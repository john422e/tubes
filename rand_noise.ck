Noise n1 => Envelope e1 => dac.chan(0);
Noise n2 => Envelope e2 => dac.chan(1);

0.5 => n1.gain;
0.5 => n2.gain;

<<<<<<< HEAD
fun dur randTime( float max ) {
	Math.random2f(0.25, max) => float timeVal;
=======
fun dur randTime(float max) {
	Math.random2f(0.5, max) => float timeVal;
>>>>>>> 73a457f32bc7c038d70c845a71ac69153aaaa66e
	timeVal::second => dur length;
	return length;
}

while(true) {
<<<<<<< HEAD
	e1.keyOn();
=======
	randTime(2.0) => now;
	e1.keyOn();	
>>>>>>> 73a457f32bc7c038d70c845a71ac69153aaaa66e
	randTime(6.0) => now;
	e1.keyOff();
	randTime(2.0) => now;
	e2.keyOn();
	randTime(6.0) => now;
	e2.keyOff();
<<<<<<< HEAD
	randTime(2.0) => now;
=======
>>>>>>> 73a457f32bc7c038d70c845a71ac69153aaaa66e
}
