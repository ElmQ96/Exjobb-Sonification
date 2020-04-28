
/*SynthDef(\rings, {
	arg type=0,freq=400, dev=1.02, rate=1, pan=0, lagpan=0, gate=0, amp=0.1, amp2=1.0;
	var sig, temp, env;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	amp = SinOsc.kr([0.07,0.1,0.2,0.02,0.06,0.2,0.2]).range(0.1);
	sig = SinOsc.ar([164.81,164.81*1.5,164.81*2,164.81*3,164.81*4,164.81*5;]);
	//sig = (BPF.ar(sig, 1000, 0.01) * 20);
	sig = sig * amp;
	//sig = Splay.ar(sig) * 0.5;

	amp2 = Lag.kr(amp2, ~poslagTime);

	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;*/

//Resonating Sin (Rings)
(
SynthDef.new(\multi, {
	var sig,amp;
	amp = SinOsc.kr([0.7,0.1,0.2,0.02,0.6]).range(0.1);
	sig = SinOsc.ar([~massSaturn,~massSaturn*1.5,~massSaturn*2,~massSaturn*3,~massSaturn*4]);
	//sig = (BPF.ar(sig, 1000, 0.01) * 20);
	sig = sig * amp;
	//sig = Splay.ar(sig) * 0.5;
	Out.ar(~surroundBus,sig);
}).play;
)

//Overtone Sin (Rings)
(
SynthDef.new(\iter2,{
	arg freq=200, dev=1.02;
	var temp, sum;
	sum = 0;
	//10 can't be a variable
	5.do{
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