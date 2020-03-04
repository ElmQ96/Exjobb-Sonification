(
o = Server.default.options;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
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
SynthDef.new(\reverb, {
	arg in, out=0, amp = 0.1;
	var sig, reverbed;
	sig = In.ar(~surroundBus.index,7);
	sig = FreeVerb.ar(sig,0.8,1.0,1.0);
	//4.do({ sig = AllpassC.ar(sig, 0.6, { Rand(0.001,0.6) }, 6)});
	sig = {AllpassN.ar(sig, 0.2, Rand(0.001,0.6), 0.3)}!7;
	//sig = AllpassN.ar(sig, 0.2, {Rand(0.001,0.6)}!7, 0.3);
	//(10.do({ sig = AllpassC.ar(sig, 0.2, { Rand(0.001,0.2) }, 0.3)}!7));

	sig = sig * amp;
	Out.ar(~reverbBus,sig);
}).add;


SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=1.0, remix=0.1;

	Out.ar(2, (sigmix*In.ar(~surroundBus.index, 1))   + (remix*In.ar(~reverbBus.index, 1)));
	Out.ar(1, (sigmix*In.ar(~surroundBus.index+1, 1)) + (remix*In.ar(~reverbBus.index+1, 1)));
	Out.ar(5, (sigmix*In.ar(~surroundBus.index+2, 1)) + (remix*In.ar(~reverbBus.index+2, 1)));
	Out.ar(7, (sigmix*In.ar(~surroundBus.index+3, 1)) + (remix*In.ar(~reverbBus.index+3, 1)));
	Out.ar(6, (sigmix*In.ar(~surroundBus.index+4, 1)) + (remix*In.ar(~reverbBus.index+4, 1)));
	Out.ar(4, (sigmix*In.ar(~surroundBus.index+5, 1)) + (remix*In.ar(~reverbBus.index+5, 1)));
	Out.ar(0, (sigmix*In.ar(~surroundBus.index+6, 1)) + (remix*In.ar(~reverbBus.index+6, 1)));
}).add;

SynthDef(\surroundmod, {
	arg freq=200, rate=1, pan=0, gate=0, reverb=0.5, amp=0.3;
	var sig, resfreq, env, reverbed;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0
	);
	sig = Saw.ar(freq);
	resfreq = SinOsc.kr(rate) * 200 + 500;
	sig = RLPF.ar(sig, resfreq,0.5);
	//sig = FreeVerb.ar(sig, reverb, 0.5, 0.8);
	//sig = GVerb.ar(sig, 200, 5);
	//reverbed = sig;
	//4.do({ reverbed = AllpassC.ar(reverbed, 0.6, { Rand(0.001,0.6) }, 6)});
	//sig = reverbed*1.0;
	//LFSaw.kr(pan)
	//Out.ar(0, sig);
	sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.2,3,0);
	sig = sig * amp * env;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef("poof", {
	arg freq=400, rate=1, pan=0, out=0, amp=0.1, gate=0;
	var sig, env, t_gate=0;

	t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		t_gate,
		doneAction:0
	);

	sig = PinkNoise.ar(1);

	sig = (BPF.ar(sig, freq*2, 0.01) * 40); //+ (BPF.ar(sig, freq*, 0.01) *5); //+ (BPF.ar(sig, freq*4, 0.01) * 0.5);
	//sig = HPF.ar(sig,200);
	//sig!2;
	//LFSaw.kr(pan)
	sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.2,3,0);
	sig = sig * amp * env;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\wind, {
	arg amp, gate, pan=0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(0.5,0.0,1.0,1.0),
		gate,
		doneAction:0
	);
	sig = PinkNoise.ar(amp);
	sig = LPF.ar(sig, Vibrato.kr(1000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, 20);
	sig = FreeVerb.ar(sig, 0.50, 1.0, 1.0);
	sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.8,3,0);
	sig = sig * amp * env;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\gravity, {
	arg amp=0.3,freq=200, gravity=1, gate=0, rate, pan=0, out=0;
    var t, sf, env, sig, t_gate;
	env = EnvGen.kr(
		Env.adsr(0.05,0.0,1.0,0.5),
		gate,
		doneAction:0
	);
	//sf = K2A.ar(LFPulse.kr(0.5).poll > 0.5) > 0;
	sf = LFPulse.ar(rate/2,0.9999);
    t = TBall.ar(sf, gravity,0,0.01);
    sig = Ringz.ar(t * 5, freq, 0.5);
	sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.8,3,0);
	sig = sig * amp * env;
	Out.ar(~surroundBus, sig);
}).add;

)


/*(
SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=0.0, remix=0.0;
	Out.ar(2, 1*In.ar(~reverbBus.index, 1));
	Out.ar(1, 1*In.ar(~reverbBus.index+1, 1));
	Out.ar(5, 1*In.ar(~reverbBus.index+2, 1));
	Out.ar(7, 1*In.ar(~reverbBus.index+3, 1));
	Out.ar(6, 1*In.ar(~reverbBus.index+4, 1));
	Out.ar(4, 1*In.ar(~reverbBus.index+5, 1));
	Out.ar(0, 1*In.ar(~reverbBus.index+6, 1));
}).add;
)
~reroute = Synth.new(\reroute, [\bus,~surroundBus]);
*/

/*Out.ar(2, In.ar(~surroundBus.index, 1));
Out.ar(1, In.ar(~surroundBus.index+1, 1));
Out.ar(5, In.ar(~surroundBus.index+2, 1));
Out.ar(7, In.ar(~surroundBus.index+3, 1));
Out.ar(6, In.ar(~surroundBus.index+4, 1));
Out.ar(4, In.ar(~surroundBus.index+5, 1));
Out.ar(0, In.ar(~surroundBus.index+6, 1));*/

(
SynthDef("mod", {
	arg freq, rate, pan=0,gate=0, reverb, amp=0.7, out=0;
	var sig, resfreq, env, reverbed;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,2.0),
		gate,
		doneAction:0
	);
	sig = (Saw.ar(freq) + SinOsc.ar(freq*2,0,0.2) + SinOsc.ar(freq*4,0,0.1))/3;
	resfreq = SinOsc.kr(rate) * 200 + 400;
	sig = RLPF.ar(sig, resfreq, 0.2);
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	//reverbed = sig;
	//1.do({ reverbed = AllpassC.ar(reverbed, 0.1, { Rand(0.001,0.6) }.dup, 6)});
	//sig = sig + (reverbed*0.5);
	sig = Pan2.ar(sig,pan,0.4);
	//sig = Splay.ar(sig,0,0.5,pan);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	sig = sig * amp * env;
	Out.ar(0, sig);
}).add;
)
