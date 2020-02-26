MIDIClient.init;
MIDIIn.connectAll;

o = Server.default.options;
o.outDevice_("ASIO : ASIO4ALL v2");


~notes = Array.newClear(128);


(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	["note on", vel, nn].postln;
	~notes[nn] = Synth.new(
		\poof,
		[
		\freq, nn.midicps*2,
		\amp, vel.linexp(1, 127, 0.2, 3.0),
		\gate, 1,
		// new notew, check current bent position first, remap.
		//\bend, ~bend.linlin(0, 16383, -2, 2),
	]);
});
)


(
MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	["note off", vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
});
)

// sound generator, adjust for bend
(
SynthDef.new(\tone, {
	arg freq=440, amp=0.05, gate=0, bend=0;
	var sig, env;
	sig = LFSaw.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

(
SynthDef(\poof, {
	arg freq=400, pan=0, amp=0.7, out=0;
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[0,1],[0,-4]),
		doneAction:2
	);
	sig = PinkNoise.ar(2);

	sig = Pan2.ar(sig,pan);
	sig = sig * amp * env;
		sig = (BPF.ar(sig, freq, 0.02) * 10); //+ (BPF.ar(sig, freq*2, 0.01) *1) + (BPF.ar(sig, freq*4, 0.01) * 0.5);
	//sig = HPF.ar(sig,200);
	//sig!2;
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.2, gate=0, bend=0;
	var sig, freqCtrl, env;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = VarSaw.ar(freqCtrl* bend.midiratio) * amp * env;
	sig = Splay.ar(sig).sum;
	Out.ar(0, sig);
}).add;
)

(
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0, gate=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;
)

x = Synth.new(\tone, [\gate, 1]);
x.set(\gate, 0);



(
MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	['bend', val, chan, src].postln;  // [ bend, 11888, 0, 1 ]
	~bend = val;
	// also update any notes currently in ~notes
	~notes.do{arg synth; synth.set(\bend, val.linlin(0, 16383, -2, 2))};
}, chan: 0);
)





(
attack = MIDIFunc.cc({
	arg val, control, chan, src;
	[val,control,chan,src].postln

});

(
MIDIFunc.cc({ arg val, control, chan, src;
	[val,control,chan,src].postln
});
)

(
MIDIFunc.cc({ arg val, control, chan, src;
	var freqlvl = linexp(val, 0, 127, 100, 600);
	freqlvl.postln;
		x.set(\freq, freqlvl);
},2);
)



