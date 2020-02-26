s.boot;

(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, cf=1500, rq=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
(1..6).choose.do{
	Synth(
		\bpfsaw,
		[
			\freq, (Scale.minor.degrees+60).midicps.choose,
			\amp, 0.25,
			\cf, exprand(200,5000),
			\rq, exprand(0.01,0.5),
		]
	);
};
)


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, cf=1500, rq=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\bpfsaw);

10.do{Synth(\bpfsaw, [\amp,0.2])}


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin,cfmax),
		LFNoise1.kr(0.1).exprange(rqmin,rqmax)
	);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 50,
			\amp,0.2,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
		],
	);
};
)


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, pan=0,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin,cfmax),
		LFNoise1.kr(0.1).exprange(rqmin,rqmax)
	);
	sig = Pan2.ar(sig,pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
	//Out.ar(out, sig!2);
}).add;
)

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 50,
			\amp,0.8,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0,1.0),
		],
	);
};
)


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, pan=0,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(0.2).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 50,
			\amp,0.8,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, 1,
		],
	);
};
)
//surround, PanAz is surround in a circle
s.options.numOutputBusChannels_(8);
s.reboot;
s.meter;
s.plotTree;


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, pan=0,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin,cfmax),
		LFNoise1.kr(0.1).exprange(rqmin,rqmax)
	);
	sig = PanAz.ar(8, sig, LFSaw.kr(0.5));
	//LFNoise1.kr(1);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 20,
			\amp,0.5,
			\detune, 1,
			\cfmin, 20*40,
			\cfmax, 20*50,
			\pan, 0.25,
		],
	);
};
)


(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2,
	lsf=200, ldb=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

{SinOsc.ar(LFNoise0.kr(LFNoise0.kr(8).exprange(2,30)).exprange(200,800),0,0.2!2)}.play;

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 50,
			\amp,0.5,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.01,
			\rqmax, 0.05,
			\cfhzmin, 5, //1
			\cfhzmax, 40, //6
		],
	);
};
)

//Beautiful calmness
(
~chords = Pbind(
	\instrument, \bpfsaw,
	\dur, Pwhite(4.5,7.0,inf),
	//\midinote, Pseq([54,61,56],1),
	\midinote, Pxrand([
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63]
	],inf),
	\detune, Pexprand(0.05,0.2,inf),
	\cfmin, 100,
	\cfmax, 1500,
	\rqmin, Pexprand(0.05,0.2,inf),
	\atk, Pwhite(2.0,2.5,inf),
	\rel, Pwhite(6.5,10.0,inf),
	\ldb, 6,
	\amp, 0.5,
	\out, 0,
).play
)

~chords.stop;

//Geiger counter
(
Synth.new(
	\bpfsaw,
	[
		\freq, 8,
		\atk, 0,
		//\rqmin, 0.005,
		//\rqmax, 0.008,
		//\cfmin,880,
		//\cfmax,880,


	]
)
)



(
SynthDef(\reverb, {
	arg in, predelay = 0.1, revtime=1.8, lpf=4500, mix=0.15, amp=1, out=0;
	var dry, wet, temp, sig;
	dry = In.ar(in,2);
	temp = In.ar(in,2);
	wet = 0;
	temp = DelayN.ar(temp, 0.2, predelay);
	16.do{
		temp = AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2,revtime);
		temp = LPF.ar(temp,lpf);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry,wet,mix*2-1,amp);
	Out.ar(out, sig);
}).add;
)

~reverbBus = Bus.audio(s,2);
~reverbSynth = Synth(\reverb, [\in, ~reverbBus])

(
~marimba = Pbind(
	\instrument, \bpfsaw,
	\dur, Pexprand(0.1,1,inf),
	\freq, Pexprand(0.25,9,inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.major.degrees+64).midicps,inf) * Prand([0.5,1,2,4],inf),
	\cfmax, Pkey(\cfmin),
	\amp, 1,
	\out, ~reverbBus,
).play;
)
~marimba.stop;

(
Synth.new(
	\bpfsaw,
	[
		\freq, 8,
		\atk, 0,
		//\rqmin, 0.005,
		//\rqmax, 0.008,
		//\cfmin,880,
		//\cfmax,880,
		\out, ~reverbSynth,
	]
)
)




