(
~gravityMercury = 0.378;
~gravityVenus = 0.907;
~gravityEarth = 1;
~gravityMars = 0.377;

~massMercury = 600;
~massVenus = 278.0141844;
~massEarth = 200;
~massMars = 577.8723404;
)


(
{
    var t, sf;
	//sf = K2A.ar(LFPulse.kr(0.5).poll > 0.5) > 0;
	sf = LFPulse.ar(0.2,0.99).poll;
    t = TBall.ar(sf, ~gravityMercury,0,0.01).poll;
    Ringz.ar(t * 10, ~massMercury, 0.5).poll;
}.play;
)

(
{
    var t, sf;
    //sf = K2A.ar(MouseX.kr > 0.5) > 0;
	sf = LFPulse.ar(0.2,0.99);
    t = TBall.ar(sf, ~gravityVenus);
	Ringz.ar(t * 10, ~massVenus, 0.5)!2;
}.play;
)


(
{
    var t, sf;
   // sf = K2A.ar(MouseX.kr > 0.5) > 0;
	sf = LFPulse.ar(0.2,0.99);
    t = TBall.ar(sf, ~gravityEarth);
    Ringz.ar(t * 10, ~massEarth, 0.5)!2;
}.play;
)


(
{
    var t, sf;
    //sf = K2A.ar(MouseX.kr > 0.5) > 0;
	sf = LFPulse.ar(0.2,0.99);
    t = TBall.ar(sf, ~gravityMars);
    Ringz.ar(t * 10, ~massMars, 0.5)!2;
}.play;
)



t = TBall.ar(sf, 0.5, 0.01);


(
Ndef(\bouncer, {

var bounceperiod, bouncetrigs, amp, fm, mainosc;

bounceperiod = Line.kr(0.3, 0, 3, doneAction: 2);

bouncetrigs = Impulse.kr(bounceperiod.reciprocal.min(30));

amp = EnvGen.ar(Env.perc(0.001, 0.0), bouncetrigs);
amp = Amplitude.ar(amp, 0, bounceperiod) * Line.kr(1, 0.05, 3);

fm =
	SinOsc.ar(120).range(0, Line.ar(1, 0, 3))
		+
	(amp * Line.ar(1, 0, 3).cubed * 130 + 80)
;

mainosc = SinOsc.ar(fm, pi/2);

amp * mainosc;
}).play
)

//Bubbles
(
SynthDef(\bpfsaw,{
	arg atk=2, sus=20, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, pan=0, cfhzmin=0.1, cfhzmax=0.3,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2,
	lsf=200, ldb=0, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(0.01).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.01).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;

10.do{Synth(
		\bpfsaw,
		[
			\freq, 100,
			\amp,0.5,
			\cfmin, 500,
			\cfmax, 50*40,
			\rqmin, 0.008,
			\rqmax, 0.005,
			\cfhzmin, 5, //1
			\cfhzmax, 40, //6
		],
	);
};
)


