/*
SynthDef

and

Synth
*/


(
//simple detuned saw sound function
x = {
	arg freq=400;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * 0.2;
	sig = Splay.ar(sig).sum;
}.play;
)

x.set(\freq, 160);

x.free;

//three steps to converting sound function into SynthDef:
//1. give it a name (e.g. \myName)
//2. specify audio signal output using Out.ar()
//3. add it to the server (.add)

//function-dot-play is a convenience for quick testing, and also has the effect of secretly adding a SynthDef in the background and instantiating a Synth from that def. making a SynthDef and Synth explicitly is a more formal and robust way of doing this process ourselves.

(
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.2;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * amp;
	sig = Splay.ar(sig).sum;
	Out.ar(0, sig);
}).add;
)

(
Synth.new(\sawtone, [\freq, 1000, \amp, 0.1]);
Synth.new(\sawtone, [\freq, 400, \amp, 0.1]);
Synth.new(\sawtone, [\freq, 250, \amp, 0.1]);
)

//command-period to stop

(
//added argument for output bus
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.2, out=0;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * amp;
	sig = Splay.ar(sig).sum; //summed to mono signal
	Out.ar(out, sig);
}).add;
)

(
//run these lines to change the number of hardware output busses that supercollider "sees"
//make sure to re-add the SynthDef after the server reboots
s.options.numOutputBusChannels = 8;
s.reboot;
)

s.meter; //8 output busses!

Synth.new(\sawtone, [\out, 0]);
Synth.new(\sawtone, [\out, 1]);
Synth.new(\sawtone, [\out, 2]); //no sound unless you actually have a sound card with more than 2 output channels, and more than 2 physical loudspeakers

(
//sum removed, now 2-channel signal output
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.2, out=0;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;
)

//additional signal channels automatically assigned to next-highest busses
Synth.new(\sawtone, [\out, 0]);
Synth.new(\sawtone, [\out, 1]);
Synth.new(\sawtone, [\out, 2]);

(
//added finite-duration envelope with doneAction:2
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.12, rel=2, out=0;
	var sig, freqCtrl, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[2,rel],[2,-2]),
		doneAction:2
	);
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * env * amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;
)

(
//do evaluates its function once for each item in its receiver collection
//do always returns its receiver
x = [49,56,60,65].do({
	"hello".postln;
});
)

(
x = [49,56,60,65].do({
	rrand(1,100).postln;
});
)

(
//can declare an argument to represent each collection item
//optional second argument to represent index counter
x = [49,56,60,65].do({
	arg note, index;
	[note, index].postln;
});
)

(
//each note, one octave up:
x = [49,56,60,65].do({
	arg note, index;
	(note+12).postln;
});
)

(
//use do to create four Synths using these midi note numbers
x = [49,56,60,65].do({
	arg note, index;
	Synth.new(\sawtone, [\freq, note.midicps]);
})
)

(
//envelope modified to be sustaining env with gate
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.12, rel=2, gate=1, out=0;
	var sig, freqCtrl, env;
	env = EnvGen.kr(
		Env.asr(2,1,rel,[2,-2]),
		gate,
		doneAction:2
	);
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * env * amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;
)

(
x = [49,56,60,65].do({
	arg note, index;
	Synth.new(\sawtone, [\freq, note.midicps]);
})
)

//do doesn't return access to the Synths, so we can't easily set their gates to zero
//(command-period)

//instead, use collect, which returns a modified collection of the same size, filled with the results of each function evaluation. in this case, an Array of four Synths is stored in x

(
x = [49,56,60,65].collect({
	arg note, index;
	Synth.new(\sawtone, [\freq, note.midicps]);
})
)

//can manually fade each Synth
x[0].set(\gate, 0);
x[1].set(\gate, 0);
x[2].set(\gate, 0);
x[3].set(\gate, 0);

(
//or,
x = [49,56,60,65].collect({
	arg note, index;
	Synth.new(\sawtone, [\freq, note.midicps]);
})
)

(
//use do to iterate again, and set each gate to zero
//also randomizing release time
x.do({
	arg syn;
	syn.set(\gate, 0, \rel, rrand(2,10));
});
)

//Routines allow wait times between bits of code

(
//doesn't work with regular functions
{
	"hi".postln;
	1.wait;
	"bye".postln;
}.value;
)

(
//works with Routine
Routine.new({
	"hi".postln;
	1.wait;
	"bye".postln;
}).play;
)

(
{
	//alternative syntax to Routine({ }).play
	"hi".postln;
	1.wait;
	"bye".postln;
}.fork;
)

(
//***modified code from what appears in video***:
//declare a var to store Synth, and make sure it is the last line in the function
//this means x will be an Array of Synths, but we don't have to begin with a 1 second wait time
Routine.new({
	x = [49,56,60,65].collect({
		arg note, index;
		var syn;
		syn = Synth.new(\sawtone, [\freq, note.midicps]);
		1.wait;
		syn; //last line so that synths are stored in x, rather than wait times
	});
}).play;
)

(
//fade synths in reverse order
Routine.new({
	x.reverse.do({
		arg syn;
		syn.set(\gate, 0, \rel, 2);
		1.wait;
	});
}).play
)

(
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.25, out=0;
	var sig, freqCtrl, env;
	env = EnvGen.kr(
		Env.perc,
		doneAction:2
	);
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * env * amp;
	sig = Splay.ar(sig);
	Out.ar(out, sig);
}).add;
)

//conditional logic in sclang (language-side)
(
if(
	//flip a coin
	[0,1].choose == 1,

	//if true
	{Synth.new(\sawtone, [\freq, 1000, \amp, 0.1])},

	//if false
	{"no sound".postln;}
);
)

(
//conditional logic doesn't work on scsynth (server-side)
SynthDef.new(\test, {
	arg coin=0;
	var sig, freq;
	if(
		(coin == 0).postln, //coin is a UGen called Control, so this is *always* false
		{freq = 350},
		{freq = 1200}
	);
	sig = SinOsc.ar(freq!2) * EnvGen.kr(Env.perc,doneAction:2) * 0.2;
	Out.ar(0, sig);
}).add;
)

Synth(\test, [\coin, 0]);
Synth(\test, [\coin, 1]); //freq is always 1200

(
SynthDef.new(\test, {
	arg coin=0;
	var sig, freq;
	if(
		(coin > 0).postln, //this operation returns a BinaryOpUGen, which is neither true nor false, so attempting to add this SynthDef returns an error message
		{freq = 350},
		{freq = 1200}
	);
	sig = SinOsc.ar(freq!2) * EnvGen.kr(Env.perc,doneAction:2) * 0.2;
	Out.ar(0, sig);
}).add;
)

(
//Select is the best UGen for approximating if-then behavior
SynthDef.new(\test, {
	arg coin=0;
	var sig, freq;
	freq = Select.kr(coin, [350,1200]);
	sig = SinOsc.ar(freq!2) * EnvGen.kr(Env.perc,doneAction:2) * 0.2;
	Out.ar(0, sig);
}).add;
)

Synth(\test, [\coin, 0]);
Synth(\test, [\coin, 1]);


(
//can use if statements inside of argument arrays when calling a Synth
Synth.new(
	\test,
	[
		\coin,
		[0,1].choose.postln;
	]
);
)

//rrand works fine if range crosses or includes zero
rrand(-100,100);

//exprand does not: min and max must have same sign (both positive or both negative)
exprand(-100,100);

{SinOsc.ar(100, 0, exprand(0.01,0.5)!2) * EnvGen.kr(Env.perc,doneAction:2)}.play; //works

{SinOsc.ar(100, 0, exprand(0,0.5)!2) * EnvGen.kr(Env.perc,doneAction:2)}.play; //fails with error message, cannot multiply a number by nan (exprand failures inside SynthDefs will not always be silent, so be careful!)