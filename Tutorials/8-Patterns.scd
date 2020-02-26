s.boot;

(
SynthDef.new(\sine, {
	arg freq=440, atk=0.005,rel=0.3,amp=1,pan=0;
	var sig,env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0,sig);
}).add;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6,0.15,0.15], 4).trace,
	//\dur, Pwhite(0.05,0.5, inf),
	\freq, Pseq([330,247,370,220], 2).round(55).trace,
	\midinote, 33,
	\harmonic, Pexprand(1,80,inf)
	//\freq, Pseq([330,247,370,220].midicps, 2).trace,
	//\midinote, Pseq([330,247,370,220], 2).trace,
	\freq, Pexprand(50,4000,inf),
	\atk, Pwhite(2.0,3.0,inf),
	\rel, Pwhite(5.0,10.0,inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8,0.8,inf),
).play
)

(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05,0.5, inf),
		\midinote, Pseq([30],inf),
		\harmonic, Pexprand(1,20,inf).round,
		\atk, Pwhite(0.01,0.1,inf).trace,
		\rel, Pwhite(5.0,10.0,inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8,0.8,inf),
	);
).play;
)
s.plotTree;
p.stop;


//Buffers.. After 16:10



