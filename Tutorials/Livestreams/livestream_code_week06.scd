//for more info, see guide file in help doc called "Using MIDI"

MIDIClient.init; //optional

//connect all MIDI devices to SC
//also has the effect of initializing the MIDIClient class
MIDIIn.connectAll;

MIDIFunc.trace(true); //"debug mode"
MIDIFunc.trace(false); //debug mode off

MIDIdef.freeAll; //if you ever want to start fresh and destroy all MIDI responders

(
//ultra basic MIDIdef: respond to note-on messages by posting "hi"
//syntax is similar to SynthDef
MIDIdef.noteOn(\on, {
	"hi".postln;
})
)

(
//less basic: post data for incoming note-on message
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
})
)

(
//similar construction for other types of MIDI messages
//see MIDIdef help file for more info
MIDIdef.cc(\cc, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
})
)

//MIDI doesn't require booting the server, but this is necessary if we want to use MIDI to generate/control sound.
s.boot;

//cleanup
MIDIdef.freeAll;

(
//very bad: each note-on message generates an infinite-length sine wave
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	{SinOsc.ar(1000, 0, 0.2!2)}.play;
});
)

//needs command period
//by default, MIDIdefs are destroyed by command-period
//they can be made permanent via:

(
//very bad: each note-on message generates an infinite-length sine wave
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	{SinOsc.ar(1000, 0, 0.2!2)}.play;
}).permanent_(true);
)

//and destroyed manually/individually via:
MIDIdef(\on).free;

(
//an improvement: apply a percussive envelope with doneAction:2
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	{
		var sig, env;
		sig = SinOsc.ar(1000, 0, 0.2!2);
		env = EnvGen.kr(
			Env.perc,
			doneAction:2
		);
		sig = sig * env;
	}.play;
});
)

//sounds stop themselves, but all have the same freq

(
//another improvement: use note number for sine freq, converting to cycles per sec
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	{
		var sig, env;
		sig = SinOsc.ar(num.midicps, 0, 0.2!2);
		env = EnvGen.kr(
			Env.perc,
			doneAction:2
		);
		sig = sig * env;
	}.play;
});
)

//convert { }.play into SynthDef for more robustness and modularity:
//also change Env.perc --> Env.adsr so notes can be sustained for an indefinite length

(
SynthDef.new(\tone, {
	arg freq=440, amp=0.2, gate=0, out=0;
	var sig, env;
	sig = SinOsc.ar(freq, 0, amp!2);
	env = EnvGen.kr(
		Env.adsr,
		gate,
		doneAction:2
	);
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

//testing
x = Synth(\tone, [\gate, 1]);
x.set(\gate, 0);

//cleanup
MIDIdef.freeAll;

(
//bad: works fine as long as notes do not overlap,
//but will produce stuck notes if multiple notes are simultaneously held down
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~sound = Synth.new(\tone, [
		\freq, num.midicps,
		\amp, 0.2,
		\gate, 1,
		\out, 0
	]);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~sound.set(\gate, 0);
});
)

//////////////////
//solution is to create an Array that can hold all possible notes simultaneously
~notes = Array.fill(128, {nil});

~notes.postcs; //post entirety of things that are unusually long

(
//store the Synth at the array index determined by note number
//and also use num and val conventionally, for freq and amp
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num] = Synth.new(
		\tone, [
			\freq, num.midicps,
			\amp, val.linexp(1,127,0.02,0.3),
			\gate, 1,
			\out, 0
		]
	);
});

//when note-off is received, free the corresponding synth by triggering its release phase
MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);

	//technically optional, but replacing that array item with nil is good housekeeping practice, because it keeps the language/server representations consistent with each other
	~notes[num] = nil;
});
)


///////////////////
//now with vibrato!
~notes = Array.fill(128, {nil}); //reset array
~vibamp = 0; //create global var to represent amount of vibrato

(
SynthDef.new(\tone, {
	arg freq=440, amp=0.2, vibamp=0.3, gate=0, out=0; //add vibamp argument
	var sig, env, vib; //add vib variable for vibrato signal

	//sinusoidal vibrato control signal
	vib = SinOsc.kr(7).bipolar(vibamp);
	vib = vib.midiratio; //converted to freq ratio

	//multiply freq by vib
	sig = SinOsc.ar(freq * vib, 0, amp!2);
	env = EnvGen.kr(
		Env.adsr,
		gate,
		doneAction:2
	);
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

x = Synth(\tone, [\gate, 1])
x.set(\vibamp, 2);
x.set(\vibamp, 0);
x.set(\gate, 0);

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num] = Synth.new(
		\tone, [
			\freq, num.midicps,
			\amp, val.linexp(1,127,0.02,0.3),
			\gate, 1,

			//incorporate global vib variable when new Synths are created
			\vibamp, ~vibamp,
			\out, 0
		]
	);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\vib, {
	arg val, num, chan, src;
	[val, num].postln;

	//update global var
	~vibamp = val.linlin(0,127,0,0.5);

	//modify all existing Synths
	~notes.do({
		arg synth;
		synth.set(\vibamp, ~vibamp);
	});
}, 1) //only respond to cc messages with controller number 1
)



















s.scope;