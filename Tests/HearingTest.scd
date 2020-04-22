(//10^24 kg, pitch, relation, inversed
~massMercury = 600;
~massVenus = 278.0141844;
~massEarth = 200;
~massMars = 577.8723404;

//days,
~orbitMercury = 1;
~orbitVenus = 0.7946076795;
~orbitEarth = 0.5835058431;
~orbitMars = 0.1;

//hours, vibrato (Pan)
~rotationMercury = 2.356817478;
~rotationVenus = 0.3; //-
~rotationEarth = 3;
~rotationMars = 2.99967462;
~rotationSun = 2.732212581;

~gravityMercury = 0.378;
~gravityVenus = 0.907;
~gravityEarth = 1;
~gravityMars = 0.377;
)

(
{
	var sig;
	sig = PinkNoise.ar(1.0!2);
	sig = BPF.ar(sig, ~massMercury,0.02) *2;
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, ~massVenus,0.02);
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig, ~massEarth,0.02);
}.play;
)



(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[0.01,1],[0,-4]),
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, ~massMercury, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play
)

(
~massMercury = 261.63;//C4
~massVenus = 220.00;//A3
~massEarth = 196.00;//G3
~massMars = 246.94;//B3
~massJupiter = 65.41;//C2
~massSaturn = 73.42;//D2
~massUranus = 82.41;//E2
~massNeptune = 87.31;//F2
)
196
(
{
	var sig;
	sig = LFSaw.ar(~massMercury,0,0.1)!2;
}.play;
)

(
{
	var sig;
	sig = LFSaw.ar(~massVenus,0,0.1)!2;
}.play;
)

(
{
	var sig;
	sig = LFSaw.ar(~massEarth,0,0.1)!2;
}.play;
)

(
{
	var sig;
	sig = LFSaw.ar(~massMars,0,0.1)!2;
}.play;
)


(
{
	var sig;
	sig = LFSaw.ar(261.63,0,0.1)!2;
}.play;
)


(
{
	var sig;
	sig = LFSaw.ar(65.41,0,0.1)!2;
}.play;
)



//hours, vibrato (Pan)
~rotationMercury = 2.356817478;
~rotationVenus = 0.3; //-
~rotationEarth = 3;
~rotationMars = 2.99967462;
~rotationSun = 2.732212581;

(
SynthDef("mod", {
	arg freq, rate, pan=0, reverb, amp=0.5, out=0;
	var sig, resfreq, env;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[1,1000,1],[1,-1]),
		doneAction:2
	);
	sig = Saw.ar(400); //+ SinOsc.ar(freq/2,0,0.5))/2;
	resfreq = SinOsc.kr(0.25) * 200 + 400;
	sig = RLPF.ar(sig, resfreq, 0.3);
	sig = sig * amp * env;
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	sig = Pan2.ar(sig,LFPulse.kr(0.125,0.0).range(-1,1),0.4);
	//sig = Splay.ar(sig,0,0.5,pan);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	Out.ar(0, sig);
}).play;
)


(
SynthDef("mod", {
	arg freq, rate, pan=0, reverb, amp=0.7, out=0;
	var sig, resfreq, env;

	sig = BrownNoise.ar(1); //+ SinOsc.ar(freq/2,0,0.5))/2;
	sig = BPF.ar(sig, XLine.kr(100,500,3), 0.0001 ) *40;
	//sig = sig * amp;
	sig = Pan2.ar(sig,LFPulse.kr(1,0.0).range(-1,1),0.4);
	//sig = Splay.ar(sig,0,0.5,pan);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	Out.ar(0, sig);
}).play;
)

(
SynthDef("mod", {
	arg freq, rate, pan=0, reverb, amp=0.7, out=0;
	var sig, resfreq, env;

	sig = WhiteNoise.ar(1); //+ SinOsc.ar(freq/2,0,0.5))/2;
	sig = BPF.ar(sig, Vibrato.kr(2000,0.5,0.9,0,0,0,0), 0.01 ) *10;
	//sig = sig * amp;
	sig = Pan2.ar(sig,LFPulse.kr(0.25,0).range(-1,1),0.4);
	//sig = Splay.ar(sig,0,0.5,pan);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	Out.ar(0, sig);
}).play;
)

