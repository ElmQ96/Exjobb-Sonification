SynthDef.new(\wind, {
	arg amp=0.1, amp2=1.0, rate=0.45, gate, pan=0;
	var sig, env, lfo;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);
	sig = PinkNoise.ar(amp);
	sig = LPF.ar(sig, Vibrato.kr(1000,rate,rate,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,rate,rate,rateVariation:0.7,depthVariation:0.3));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, 100);
	lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, 100, 20000/8);
	sig = BRF.ar(sig, lfo, 1);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.8,3,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),0.8,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;


(
{
	var sig, env, lfo, lfo2;
sig = PinkNoise.ar(1)!2;
lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, 100, 20000/8);
lfo2 = LinExp.ar(LFTri.ar(0.1), -0.5, 1, 100, 20000/8);
sig = BRF.ar(sig, lfo+ lfo2, 1);
sig = BRF.ar(sig, lfo2, 1);}.play
)