
//shift-enter on a single line to evaluate
//must boot audio server in order to make sound
Server.local.boot;
Server.local.quit;

//localhost server stored in interpreter variable s for convenience:
s.boot;
s.quit;

//simple sound function: function-dot-play
//monophonic pink noise (left speaker only)
{PinkNoise.ar * 0.5}.play;

//command-period to stop all sound

//single lowercase alphabetic chars are interpreter variables which can be used globally
x = {PinkNoise.ar * 0.5}.play;

x.free;

//alternatively, longer name preceded by tilde

~sound = {PinkNoise.ar * 0.5}.play;

~sound.free;

//global variables are nil by default - a value given to variables that don't yet have a value
~something; //initially nil

//if local variable is desired, must be declared with var statement - highlight both lines and press shift-enter
var sound;
sound = {PinkNoise.ar * 0.5}.play;

sound.free; //does not work - "sound" only defined within scope of evaluation. so command-period is necessary

//enclose in parentheses and press command-enter to evaluate a multi-line block:

(
var sound;
sound = {PinkNoise.ar * 0.5}.play;
)

//functions don't have to contain signal generators

~myFunc = {5.squared}; //define a function

~myFunc.value; //evaluate a function

//declare an argument so that an arbitrary value can be passed in as an input

(
~myFunc = {
	arg input=5; //5 by default
	input.squared
};
)

~myFunc.value(4); //evaluate with user-specified input

(
~sound = {
	arg amp=0.5;
	var sig;
	sig = PinkNoise.ar!2; //note: "!2" creates an array of copies, which scsynth interprets as a multichannel signal -- in this case, mono becomes stereo
	sig = sig * amp; //apply amplitude argument
};
)

//instantiate sound with user-specified amplitude
x = ~sound.play(args:[\amp, 0.1]);

x.set(\amp, 0.5); //args can be modified while sound is "live"

x.free; //stop


//more complex example: noise generator controlling frequency of sine wave

//command-d on any class to bring up its help file
(
~sound = {
	arg amp=0.2;
	var sig, freq;

	//8 random value per second
	//non-interpolating noise
	//output ranges from 100-1000
	freq = LFNoise0.kr(8).range(100,1000);

	//used as freq input for SinOsc
	sig = SinOsc.ar(freq, 0, amp)!2;
}.play;
)

~sound.free;

//all UGens can be plotted
//plot argument determines number of seconds to graph (takes this many seconds to build)
{LFNoise0.ar(100)}.plot(0.1);
{LFNoise1.ar(100)}.plot(0.1);
{LFTri.ar(100)}.plot(0.04);

//other UGens to check out:
SinOsc
Pulse
LFPulse
Saw
LFSaw
WhiteNoise
PinkNoise
Line
XLine
EnvGen

//helpful visual tools:
//all/most accessible via Server drop-down menu
s.meter;
s.scope;
FreqScope.new;
s.volume.gui;
s.makeGui;
s.plotTree;



















[1,2,3]++[4,5,6]




PinkNoise.ar * 0.2!2

"value is: " ++ 5.postln;

3 + (4 * 5)


{PinkNoise.ar * 0.2}.play





















s.meter;
s.scope;
FreqScope.new;
s.makeGui
s.volume.gui