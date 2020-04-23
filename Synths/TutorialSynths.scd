//Random Synth pad
(
SynthDef.new(\multi, {
	var sig,amp,env;
	env = EnvGen.kr(
		Env.new([0,1,0],[2,8],[1,-1]),
		doneAction:2
	);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0.1);
	sig = SinOsc.ar({ExpRand(50,1000)}!8);
	sig = sig * amp *env;
	//sig = Splay.ar(sig) * 0.5; //stereo
	//SuperCollider handles the multichannel
	Out.ar(0,sig);
}).add;
)
x = Synth.new(\multi);

//Resonating Sin
(
SynthDef.new(\multi, {
	var sig,amp;
	amp = SinOsc.kr([7,1,2,0.2,6]).range(0.1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0,sig);
}).play;
)



//Panning creature
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

//Bubbles
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



//Sin Crazy
(
SynthDef.new(\sineTest, {
	arg noiseHz=8;
	var freq,amp,sig;
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0,sig);
}).add
)
x = Synth.new(\sineTest, [\noiseHz, 32]);
x.set(\noiseHz, 12)

//Arcade Pulse
(
SynthDef.new(\pulseTest, {
	arg  ampHz=4, fund=40, maxPartial=4, width=0.5;
	var amp1,amp2,freq1,freq2,sig1,sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund,fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund,fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1,width,amp1);
	sig2 = Pulse.ar(freq2,width,amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0,sig1);
	Out.ar(1,sig2);
}).add
)
x = Synth.new(\pulseTest);

//Pulse drop
(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,1, doneAction:2);
	freq = XLine.kr(880,110,1,doneAction:2);
	sig = Pulse.ar(freq) * env.dbamp;
}.play
)

//Spacy phone
(
x = {
	arg t_gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play
)

//Gated Sawcrazy
(
x = {
	arg gate = 0;
	var sig, env, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 200, 0.1);
	env = EnvGen.kr(Env.adsr,gate, doneAction:2);
	sig = VarSaw.ar(SinOsc.kr(freq).range(500,1000)) * env;
}.play
)
x.set(\gate,1);


//SawSynth
(
SynthDef.new(\iter, {
	arg freq=40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01,5,1,-2),
		doneAction:2
	);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99,1.02)}!2,
			{Rand(0.0,1.0)}!2, //Ranomizes the phase to avoid pop-in
			{ExpRand(0.005,0.05)}!2
		);
		sum = sum + temp
	};
	sum = sum * 0.05 * env;
	Out.ar(0,sum);
}).add;
)
(
[53,59,63,68].do{
	arg midinote;
	Synth.new(\iter, [\freq,midinote.midicps]);
}
)

//Overtone Sin
(
SynthDef.new(\iter2,{
	arg freq=200, dev=1.02;
	var temp, sum;
	sum = 0;
	//10 can't be a variable
	10.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05,0.2)}!2).range(dev.reciprocal,dev)
		);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!2).exprange(0.01,1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0,sum);
}).add;
)
x = Synth.new(\iter2);

//Blip reverb
(
SynthDef.new(\blip, {
	arg out;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300,1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01,0.2),trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out,sig);
}).play;

SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig,0.5,0.8,0.2);
	Out.ar(out,sig);
}).play;
)
y = Synth.new(\reverb, [\in,6]);
x = Synth(\blip, [\out,6]);




//Geiger Counter
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

//Marimba
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



