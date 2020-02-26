MIDIClient.init;
MIDIIn.connectAll;

o = Server.default.options;
o.outDevice_("ASIO : ASIO4ALL v2");

(
MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	["note on", vel, nn].postln;
	~notes[nn] = Synth.new(
		\tone,
		[
		\freq, nn.midicps,
		\amp, vel.linexp(1, 127, 0.01, 0.3),
		\gate, 1,
		// new notew, check current bent position first, remap.
		\bend, ~bend.linlin(0, 16383, -2, 2),
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
	arg freq=440, amp=0.3, gate=0, bend=0;
	var sig, env;
	sig = LFTri.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

x = Synth.new(\tone, [\gate, 1]);
x.set(\gate, 0);

~notes = Array.newClear(128);

(
MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	['bend', val, chan, src].postln;  // [ bend, 11888, 0, 1 ]
	~bend = val;
	// also update any notes currently in ~notes
	~notes.do{arg synth; synth.set(\bend, val.linlin(0, 16383, -2, 2))};
}, chan: 0);
)



