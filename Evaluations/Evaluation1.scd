//StartUp
(
o = Server.default.options;
o.numOutputBusChannels;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
o.numOutputBusChannels = 8;
s.boot;
)

(
~surround = Bus.audio(s,8);
~surround.index;
o.numOutputBusChannels = ~surround.index+8;
)
(
//10^24 kg, pitch, relation, inversed
~massMercury = 261.63; //C4
~massVenus = 220; //A3
~massEarth = 196; //G3
~massMars = 246.94; //B3

//orbital period, 1 month per second
~orbitMercury = 0.137888899;
~orbitVenus = 0.1109850384;
~orbitEarth = 0.08333330167;
~orbitMars = 0.02;

//hours, vibrato (Pan)
~rotationMercury = 2.356817478;
~rotationVenus = 0.5; //-
~rotationEarth = 3;
~rotationMars = 2.99967462;
~rotationSun = 2.732212581;

~rotationdayMercury = 0.5;
~rotationdayVenus = 1.345877197;
~rotationdayEarth = 3;
~rotationdayMars = 2.997796885;

~gravityMercury = 0.378;
~gravityVenus = 0.907;
~gravityEarth = 1;
~gravityMars = 0.377;
)

(
SynthDef("sunlow", {
	arg freq,amp, reverb, rate;
	var sig, resfreq;
	sig = (Saw.ar(freq) + Saw.ar(freq*2))/2;
	resfreq = SinOsc.kr(rate) * 200 + 400;
	sig = RLPF.ar(sig, resfreq, 0.1);
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	Out.ar(3, sig);
}).add;
)


(
//Synth.new(\wind, [\amp, 0.0]);
~sun = Synth.new(\sunlow, [
		\freq, 50,
		\rate, ~rotationSun,
		\reverb, 0.4,
		\pan, -1,
		\out, 3,
]);
)

//VarSaw, SyncSaw
(
SynthDef("mod", {
	arg freq, rate, pan=0, reverb, amp=0.7, out=0;
	var sig, resfreq, env;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[1,1000,1],[1,-1]),
		doneAction:2
	);
	sig = (Saw.ar(freq) + SinOsc.ar(freq/2,0,0.5))/2;
	resfreq = SinOsc.kr(rate) * 200 + 400;
	sig = RLPF.ar(sig, resfreq, 0.3);
	sig = sig * amp * env;
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	sig = Pan2.ar(sig,pan,0.4);
	//sig = Splay.ar(sig,0,0.5,pan);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	Out.ar(out, sig);
}).add;
)
//TEST 1: 1 Planet/Öra

(
//Synth.new(\wind, [\amp, 0.0]);
~mercuryCenter = Synth.new(\mod, [
		\freq, ~massMercury,
		\rate, ~rotationMercury,
		\pan, 0,
		\reverb, 0.5,
]);
)


//1.2
(
//Synth.new(\wind, [\amp, 0.0]);
~mercury = Synth.new(\mod, [
		\freq, ~massMercury,
		\rate, ~rotationMercury,
		\pan, 1,
		\reverb, 0.5,
]);
)

(
//Synth.new(\wind, [\amp, 0.2]);
~earth = Synth.new(\mod, [
		\freq, ~massEarth,
		\rate, ~rotationEarth,
		\pan, -1, //-1
		\reverb, 0.5,
]);
)

//Pre-test 2

(
SynthDef("surroundmod", {
	arg freq, rate, pan, reverb, amp=0.3;
	var sig, resfreq, env;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[1,1000,1],[1,-1]),
		doneAction:2
	);
	sig = Saw.ar(freq);
	resfreq = SinOsc.kr(rate) * 200 + 500;
	sig = RLPF.ar(sig, resfreq,0.5);
	sig = sig * amp * env;
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	//sig = Splay.ar(sig,0,0.5,pan);
	sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.2,3,0);
	//Out.ar(0, sig);
	Out.ar(~surround, sig);

	Out.ar(2, In.ar(~surround.index, 1));
	Out.ar(1, In.ar(~surround.index+1, 1));
	Out.ar(5, In.ar(~surround.index+2, 1));
	Out.ar(7, In.ar(~surround.index+3, 1));
	Out.ar(6, In.ar(~surround.index+4, 1));
	Out.ar(4, In.ar(~surround.index+5, 1));
	Out.ar(0, In.ar(~surround.index+6, 1));
}).add;
)



//TEST 2: Surround
(
//Synth.new(\wind, [\amp, 0.0]);
~mercury = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~rotationdayMercury,
		\pan, ~orbitMercury,
		\reverb, 0.4,
]);
)

(
//Synth.new(\wind, [\amp, 0.2]);
~earth = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~rotationdayEarth,
		\pan, ~orbitEarth,
		\reverb, 0.5,
]);
)

(
//Synth.new(\wind, [\amp, 0.8]);
~venus = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~rotationdayVenus,
		\pan, ~orbitVenus,
		\reverb, 0.5,
]);
)

(
//Synth.new(\wind, [\amp, 0.8]);
~mars = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~rotationdayMars,
		\pan, ~orbitMars,
		\reverb, 0.5,
]);
)



//TEST 3: Gravity
(
{
    var t, sf;
	//sf = K2A.ar(LFPulse.kr(0.5).poll > 0.5) > 0;

	sf = LFPulse.ar(0.1,0.99).poll;
    t = TBall.ar(sf, ~gravityMercury,0,0.01);
    Ringz.ar(t * 5, ~massMercury, 0.5)!2;
}.play;
)

(
{
    var t, sf;
   // sf = K2A.ar(MouseX.kr > 0..5) > 0;
	sf = LFPulse.ar(0.1,0.99);
    t = TBall.ar(sf, ~gravityEarth);
    Ringz.ar(t * 5, ~massMercury, 0.5)!2;
}.play;
)

(
{
    var t, sf;
    //sf = K2A.ar(MouseX.kr > 0.5) > 0;
	sf = LFPulse.ar(0.1,0.99);
    t = TBall.ar(sf, ~gravityVenus);
	Ringz.ar(t * 5, ~massMercury, 0.5)!2;
}.play;
)




//Test 4: Wind
(
SynthDef.new(\wind, {
	arg amp;
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[1,1000,1],[1,-1]),
		doneAction:2
	);
	sig = BrownNoise.ar(amp);
	sig = LPF.ar(sig, Vibrato.kr(1000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, 20);
	sig = sig * env;
	sig = FreeVerb.ar(sig, 0.54, 1.0, 1.0);
	sig = Pan2.ar(sig,0);
	Out.ar(0,sig);
}).add;
)


(
Synth.new(\wind, [\amp, 0.06]);
~earth = Synth.new(\mod, [
		\freq, ~massEarth,
		\rate, ~rotationEarth,
		\pan, 0, //-1
		\reverb, 0.5,
]);
)
