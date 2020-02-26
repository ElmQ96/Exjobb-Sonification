s.boot;
s.meter;

ServerOptions; //class that enables custom server configurations

s.options.numAudioBusChannels; //total number of audio busses
s.options.numControlBusChannels; //total number of control busses
s.options.numOutputBusChannels; //default number of hardware outputs (2)
s.options.numInputBusChannels; //default number of hardware inputs (2)

//A "bus" is essentially an audio pathway where signals can be written to and read from. Busses allow sound processes to share signals between themselves, e.g. sending a tone blip to be processed by a reverb effect.

//audio bus channels currently look like this
|----------------audio bus channels-----------------------------| (1024)
hardware outs  hardware ins  private busses
xx (2)         xx (2)        xxxxx... (1024 - 4 = 1020 remaining busses)
index 0-1      index 2-3     index 4-1023

s.options.numOutputBusChannels = 8; //change num. of hardware output audio busses
s.options.numInputBusChannels = 8; //change num. of hardware input busses

//reboot for ServerOptions changes to take effect
s.reboot;

s.meter; //can see change reflected on level meters

//audio bus channels currently look like this
|----------------audio bus channels------------------------------| (1024)
hardware outs  hardware ins  private busses
xxxxxxxx (8)   xxxxxxxx (8)  xxxxx... (1024 - 16 = 1008 remaining busses)
index 0-7      index 8-15    index 16-1023

//when you have an effect processing a source signal, it's generally a bad idea to put them both in the same SynthDef, because it becomes impossible to conceptually "separate" these two processes, and every time a new sound is created, it means a new instance of the effect UGen (GVerb) is created. This can be very computationally expensive:
(
SynthDef.new(\bad, {
	arg freq = 400, amp=0.5, env_rate=0.7;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env;
	sig = sig + (GVerb.ar(sig,200,5) * 0.2);
	sig = sig * amp;
	sig = sig!2;
	Out.ar(0, sig);
}).add;
)

//run this several times and the server will crash -- GVerb requires dynamic allocation of memory for signal delay lines, and the server only permits a fixed amount.
Synth(\bad, [\freq, exprand(200,2000), \env_rate, rrand(0.4,1.2), \amp, 0.2]);

//it is possible to raise the dynamic memory allocation ceiling:
s.options.memSize = 2.pow(20);
s.reboot;

//but this is a sloppy solution, and the conceptual problems and inefficiency remain.
s.freeAll;

//the correct solution is to separate these processes into two SynthDefs:
(
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;

SynthDef.new(\reverb, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 2); //the source is stereo (line 64 has !2), so specify 2 channels
	sig = sig + (GVerb.ar(sig, 200, 5) * 0.2); //apply reverb by summing dry + wet
	Out.ar(out, sig); //out to arbitrary bus
}).add;
)

s.plotTree; //scsynth visualization of active processes

//run this first -- arbitrarily choosing bus 57 for reverb to read from
Synth.new(\reverb, [\in, 57, \out, 0]);

(
//now run this -- source outputs to bus 57, and we hear sound with reverb
x = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57
	]);
)

s.scope; //can also see signal if we navigate to bus 57-58 on this GUI, and reverberant application on bus 0-1

s.freeAll;


//now run these two Synth.new lines in the opposite order:
(
x = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57
	]);
)

Synth.new(\reverb, [\in, 57, \out, 0]);

//...and no sound is heard. This is because the default 'target' of Synth.new is the default group on the default server, an the default 'addAction' of Synth.new is 'addToHead' -- so the source goes to the head of the default group, then the reverb goes to the head of the default group -- *upstream* of the source. This is the wrong order for Synths who wish to share signal data.

//There are multiple ways to specify the correct order of execution:

(
//create the synth
Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57,
	]);
)

//add reverb synth to the tail of the default group
~verb = Synth.new(\reverb, [\in, 57, \out, 0], s.defaultGroup, \addToTail);

s.freeAll;
//or, alternatively

//create and name the source synth
(
~source = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57,
	]);
)

//use ~verb as the target for the synth, and 'addBefore'
~verb = Synth.new(\reverb, [\in, 57, \out, 0], ~source, \addAfter);

//note that with two separate SynthDefs, we can free the source without interrupting the reverb tail:
~source.free;

//once faded out, free the reverb synth
~verb.free;

//we can allocate an audio bus like this. Using the Bus class means bus indices are largely managed for us by the server, and we don't need to remember what bus 57 is being used for -- we can give the bus a suitable name:
~reverb_bus = Bus.audio(s, 2);

//create the synths:

(
~source = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, ~reverb_bus,
	]);
)

Synth.new(\reverb, [\in, ~reverb_bus, \out, 0], ~source, \addAfter);

//we can reset the bus index counter with this line:
s.newBusAllocators;

//although doesn't mean the bus is de-allocated -- it's still usable. But it may be overwritten or become inaccessible if we use newBusAllocators and then allocate a new audio bus, because the server will see those bus channels as being "available".

//Groups are extremely handy for organizing the node tree on scsynth:
(
~source_group = Group.new;
~fx_group = Group.new(~source_group, \addAfter)
)

//with two groups in the proper order, we don't have to worry about the ordering of individual Synths, as long as we put them in the correct groups.

~verb = Synth.new(\reverb, [\in, ~reverb_bus, \out, 0], ~fx_group);

(
//run this clump multiple times
Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, ~reverb_bus,
	], ~source_group);
)

//we can set a group in order to relay a set message to all of the nodes inside of it:
~source_group.set(\freq, 1000); //now they've all got the same freq

//we can tell a group to free all of the nodes inside of it:
~source_group.freeAll;

//we can also free the group itself:
~source_group.free;

//freeing a group will also free any nodes inside of it
~fx_group.free;


//a slightly more complex study example using multiple Outs in the source SynthDef, and a delay + reverb effect in parallel -- you can think of these multiple Out UGens like aux sends on an analog mixer -- see lecture video for modifications to configure these effects in series instead of parallel
(
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7,
	reverb_out=0, delay_out=0, spkr_out=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(reverb_out, sig);
	Out.ar(delay_out, sig);
	Out.ar(spkr_out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = GVerb.ar(sig, 200, 5) * 0.3;
	Out.ar(out, sig);
}).add;

SynthDef.new(\delay, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = (sig + CombN.ar(sig, 1, 0.32, 10)) * 0.5;
	Out.ar(out, sig);
}).add;
)

(
s.newBusAllocators;
~reverb_bus = Bus.audio(s,2);
~delay_bus = Bus.audio(s,2);
)

(
~src_grp = Group.new;
~delay_grp = Group.after(~src_grp);
~reverb_grp = Group.after(~delay_grp);
)

(
Synth.new(\reverb, [\in, ~reverb_bus, \out, 0], ~reverb_grp);
Synth.new(\delay, [\in, ~delay_bus, \out, 0], ~delay_grp);
)

(
//can run this multiple times
Synth.new(\source, [
	\reverb_out, ~reverb_bus,
	\delay_out, ~delay_bus,
	\spkr_out, 0,
	\env_rate, 0.1,
	\freq, exprand(200,2000),
	\amp, 0.25
], ~src_grp);
)

~src_grp.freeAll; //stop all source sounds