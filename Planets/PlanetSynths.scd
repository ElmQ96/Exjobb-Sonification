(
o = Server.default.options;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
//o.outDevice_("ASIO : Focusrite(USB Audio)");
//s.options.memSize = 65536;
o.numOutputBusChannels = 8;
o.numOutputBusChannels;
s.reboot;
)
(
~surroundBus = Bus.audio(s,8);
~reverbBus = Bus.audio(s,8);
o.numOutputBusChannels = ~reverbBus.index+8;
~reverbBus.index;
~surroundBus.index;
)

(
~autOrbit = 0;
~panlagTime = 1;
~poslagTime = 1;

SynthDef.new(\reverb, {
	arg in, out=0, amp = 0.4;
	var sig, reverbed;
	sig = In.ar(~surroundBus.index,7);
	sig = FreeVerb.ar(sig,0.8,1.0,1.0);
	sig = {AllpassN.ar(sig, 0.2, Rand(0.001,0.6), 0.3)}!7;
	sig = sig * amp;
	Out.ar(~reverbBus,sig);
}).add;

SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=1.0, remix=0.1, lfemix=0.5;
	Out.ar(2, (sigmix*In.ar(~surroundBus.index, 1))   + (remix*In.ar(~reverbBus.index, 1)));
	Out.ar(1, (sigmix*In.ar(~surroundBus.index+1, 1)) + (remix*In.ar(~reverbBus.index+1, 1)));
	Out.ar(5, (sigmix*In.ar(~surroundBus.index+2, 1)) + (remix*In.ar(~reverbBus.index+2, 1)));
	Out.ar(7, (sigmix*In.ar(~surroundBus.index+3, 1)) + (remix*In.ar(~reverbBus.index+3, 1)));
	Out.ar(6, (sigmix*In.ar(~surroundBus.index+4, 1)) + (remix*In.ar(~reverbBus.index+4, 1)));
	Out.ar(4, (sigmix*In.ar(~surroundBus.index+5, 1)) + (remix*In.ar(~reverbBus.index+5, 1)));
	Out.ar(0, (sigmix*In.ar(~surroundBus.index+6, 1)) + (remix*In.ar(~reverbBus.index+6, 1)));
	Out.ar(3, lfemix*(Mix.new(In.ar(~surroundBus.index, 7))));
}).add;

SynthDef(\surroundmod, {
	arg type=0,freq=200, rate=1, pan=0, lagpan=0, gate=0, isMagnetic=0, amp=0.3, amp2=1.0;
	var sig, sig2, resfreq, env, reverbed,  lfo, input, snd;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	sig = Select.ar(type,
		[LFSaw.ar(Vibrato.kr(freq,rate,0.01)),
		 LFPulse.ar(Vibrato.kr(freq,rate,0.01),0,0.4)]);

	sig2 = SinOsc.ar(freq/2,0,0.5);

	resfreq = SinOsc.kr(rate) * 200 + 400;
	sig = RLPF.ar(sig, resfreq,0.5);

	lfo = LinExp.ar(Vibrato.ar(0.5,0.1,1.0,0,0,0.5,0.5), -1, 1, freq*3, 20000/4);
	sig = Select.ar(isMagnetic,
		[sig, sig + HPF.ar(BPF.ar(sig, lfo, 0.1)*2,freq*3)]);

	sig = (sig + sig2)/2;

	/*snd = BAllPass.ar(sig, [1, 2, 4, 8] * lfo, 0.5);
	snd = Mix.ar(snd);
	snd = snd + (sig * -1 * 3);
	sig = Mix.ar(snd);*/

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);

	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef("sinpoof", {
	arg freq=400, rate=1, pan=0, out=0, amp=1.0, amp2=1.0, gate=0;
	var sig,sig2, env, env2, t_gate=0,oscillator1, oscillator2, resfreq;

	env = EnvGen.kr(
		Env.adsr(0.01,0.0,0.3,0.1),
		gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig2 = (BPF.ar(sig, freq, 0.01) * 1);
	sig = (BPF.ar(sig, Vibrato.kr(freq*2,rate,0.01), 0.005) * 40);

	sig = 1-abs(SinOsc.kr(rate/2)) * sig;

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan/2),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan/2),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef("suspoof", {
	arg freq=400, rate=1, pan=0, out=0, amp=0.5, amp2=1.0, gate=0;
	var sig,sig2, env, env2, t_gate=0,oscillator1, oscillator2;

	t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		t_gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = PinkNoise.ar(1);
	sig2 = (BPF.ar(sig, freq/2, 0.01) * 40);
	sig = (BPF.ar(sig, freq*2, 0.01) * 40);

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan/2),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan/2),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;


SynthDef("percpoof", {
	arg freq=400, rate=1, pan=0, out=0, amp=0.4, amp2=1.0, gate=0;
	var sig, env, t_gate=0;

	t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		//Env.adsr(0.05,0.5,0.3,0.5),
		Env.perc(0.01,0.5),
		t_gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, freq*2, 0.003) * 20); //+ (BPF.ar(sig, freq*, 0.01) *5);

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\wind, {
	arg amp=0.1, amp2=1.0, rate=0.45, gate, pan=0, gust=1, atmos=40;
	var sig, env, lfo;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	sig = PinkNoise.ar(amp);
	sig = LPF.ar(sig, Vibrato.kr(1000*gust,rate,rate,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,rate,rate,rateVariation:0.7,depthVariation:0.3).lag(0.5));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, atmos);

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\gravity, {
	arg amp=1.5, amp2=1.0, freq=200, gravity=1, gate=0, rate, pan=0, out=0;
    var t, sf, env, sig, t_gate, lfo;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	//sf = K2A.ar(LFPulse.kr(0.5).poll > 0.5) > 0;
	sf = LFPulse.ar(rate,0.0);
    t = TBall.ar(sf, gravity,0,0.01);
    sig = Ringz.ar(t * 5, freq, 0.5);
	/*lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, 100, 20000/8);
	sig = BRF.ar(sig, lfo, 1);*/

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\fry, {
	arg amp=0.1, amp2=1.0, freq=440, rate=1, lowtemp=20, hightemp=200, gate, pan=0;
	var sig, env, newrate;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	newrate = SinOsc.kr(rate).range(lowtemp,hightemp);
	sig = Dust.ar(newrate, 0.7); //rate: 5-1000
	//sig = LPF.ar(sig,SinOsc.kr(rate).range(4000,6000));

	if(~autOrbit == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);});

	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\rings, {
	arg type=0,freq=200, rate=1, pan=0, lagpan=0, gate=0, isMagnetic=0, amp=0.3, amp2=1.0;
	var sig, sig2, resfreq, env, reverbed,  lfo, input, snd;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	sig = LFSaw.ar(Vibrato.kr(freq,rate,0.01));

	amp2 = Lag.kr(amp2, ~poslagTime);

	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

)

//Resonating Sin
(
SynthDef.new(\multi, {
	var sig,amp;
	amp = SinOsc.kr([0.7,0.1,0.2,0.02,0.6]).range(0.1);
	sig = SinOsc.ar([300,500,700,900,1100]);
	//sig = (BPF.ar(sig, 1000, 0.01) * 20);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0,sig);
}).play;
)

//Overtone Sin
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

{ Crackle.ar(MouseX.kr(1,2), 0.5) }.play;

{ Dust.ar(MouseX.kr(0,400).poll, 0.5)!2 }.play;

{SinOsc.ar(~massMars/2,0,0.5)}.play;

(
{
    var t, sf;
    sf = K2A.ar(MouseX.kr > 0.5) > 0;
    t = TBall.ar(sf, 0.5, 0,0.01);
    Ringz.ar(t * 10, 1200, 0.1)!2;
}.play;
)

