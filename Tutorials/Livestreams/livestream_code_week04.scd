s.boot;

(
{
	//low-pass filter with mouse-controlled cutoff frequency
	var sig;
	sig = PinkNoise.ar(0.25!2);
	sig = LPF.ar(sig, MouseX.kr(30,18000,0).poll);
}.play;
)

//see also HPF, BPF, BRF

//for all filters, freq argument should always be between 20 and 20000
//for BPF, BRF, rq should always be greater than 0 and less than or equal to 1
//failure to follow these guidelines will result in a filter EXPLOSION and your sadness

(
{
	//bandpass filter with center freq = 1 kHz and mouse-controlled rq, also using some rq math for BPF mul argument to compensate for lost amplitude
	var sig, rq;
	rq = MouseX.kr(0.001,1,1);
	sig = PinkNoise.ar(0.5!2);
	//sig = Saw.ar([60,61], 0.2);
	sig = BPF.ar(
		sig,
		1000,
		rq,
		1/rq.sqrt,
	);
}.play;
)

(
{
	//lowpass filter with mouse-controlled cutoff freq, sawtooth source
	var sig, rq;
	rq = MouseX.kr(0.001,1,1);
	//sig = PinkNoise.ar(0.5!2);
	sig = Saw.ar([60,61], 0.2);
	sig = LPF.ar(
		sig,
		MouseX.kr(20,20000,1),
	);
}.play;
)


//server must be booted before buffers can be loaded

//convenience for clearing away any existing buffers in server memory
Buffer.freeAll;

//note that these paths will need to be changed on your computer
//remember you can copy-paste audio files into the SC editor to quickly get their absolute path names

//would be wise to give these more meaningful names, especially if you are using LOTS of audio files
b = Buffer.read(s, "/Users/eli/Desktop/prayer_bowl_roll.aiff");
c = Buffer.read(s, "/Users/eli/Desktop/flute_flutter.aiff");

//simple test play
b.play;
c.play;

//other types of queries on buffer instances
b.bufnum; //unique integer associated with each buffer, auto-assigned by scsynth
b.duration;
b.numChannels;
b.sampleRate;
b.numFrames; //can be loosely considered the same as the number of samples
//technically num frames = num samples / num channels

b.query; //multi-purpose query

(
x = {
	arg t_trig=1;
	var sig;
	sig = PlayBuf.ar(

		1, //number of channels - must be hard-coded integer, cannot be modulated

		//name of buffer instance (alternatively, ~flute.bufnum)
		b,

		//BufRateScale ensures playback rate is interpreted correctly by
		//compensating with buffer/server sample rate ratio
		BufRateScale.kr(b) * 0.5, //0.5 = twice as slow, pitch down one octave

		//what to do when finished? 2 = free Synth
		doneAction:2
	);
	sig = sig!2;
}.play;
)

//see also loop, trigger, and startPos arguments

//instead of a simple function, create a more robust SynthDef

(
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, atk=0.001, rel=1,
	spos=0, pan=0, amp=1, out=0;
	var sig, env;

	//amplitude envelope (optional, not technically required because buffers already have an "end"
	env = EnvGen.kr(
		Env.new([0,1,0],[atk,rel],[1,-1]),
		doneAction:2
	);

	sig = PlayBuf.ar(
		1, //assumes mono audio file - if mixing/matching stereo mono files, the correct thing to do is to make a second, differently-named SynthDef with PlayBuf.ar(2, ...)
		buf,
		BufRateScale.kr(buf) * rate,
		startPos:spos,
	);

	//optional filter UGen here if you're feeling saucy

	sig = Pan2.ar(sig, pan); //mono -> stereo pan
	sig = sig * env * amp; //apply amplitude and envelope
	Out.ar(out, sig);
}).add;
)

(
//simple version
Synth(
	\bufplay,
	[
		\buf, b,
		\rel, 5,
		\atk, 0.01,
		\spos, 0,
		\rate, 1,
		\amp, 0.5
	]
);
)

(
//more complex, with more interesting argument choices (run multiple times)
Synth(
	\bufplay,
	[
		\buf, b,
		\rel, exprand(4,8),
		\atk, exprand(0.01,2),
		\spos, b.numFrames * rrand(0.1,0.5),
		\rate, [-12,-5,-7,-2,0,2,4,7,9].choose.midiratio,
		\amp, exprand(0.2,0.8)
	]
);
)

(
//create a routine by "fork"-ing a function that loops a Synth; wait; construction
r = {

	{

		Synth(
			\bufplay,
			[
				\buf, b,
				\rel, exprand(4,8),
				\atk, exprand(0.01,2),
				\spos, b.numFrames * rrand(0.1,0.5),
				\rate, [-12,-5,-7,-2,0,2,4,7,9].choose.midiratio,
				\amp, exprand(0.2,0.8)
			]
		);

		exprand(0.1,2).wait;

	}.loop;

}.fork;
)

r.stop; //stop routine

//thisProcess.nowExecutingPath returns a string representing the path to the SC code file in which code is currently being evaluated. The SC file must have been saved at least once. In combination with PathName.new, the parentPath method, and string concatenation using the "++" operator, it is possible to create dynamic file names that change appropriately when a project folder is moved to a new location or new computer. It is always a good idea to create a project folder that contains your code file, and a subfolder of audio files, so that your audio resources and code will always travel together and remain as a single package.

//these lines should read two files into buffers, and you shouldn't need to make any changes to the code on your computer, so long as the "livestream_code_week04" folder remains intact.

~flower = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/flower_pot.aiff");

~bowl = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/prayer_bowl_roll.aiff");

~flower.play;

~bowl.play












