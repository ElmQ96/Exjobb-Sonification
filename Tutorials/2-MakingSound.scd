//boots and quits the server
Server.local.boot;
Server.local.quit;

s.boot;
s.quit;

//ctrl+B also starts server


{SinOsc.ar}.play;

x = {SinOsc.ar}.play;

x.free;

//ctrl+. to stop sounds

//characters a-z are reserved as global variables
//self-made variables has to start with a lower case letter

x = {SinOsc.ar};

y = x.play;

y.free;


x = {SinOsc.ar(700,0,0.125,0)}.play;

x = {SinOsc.ar(700)}.play;

x = {SinOsc.ar(700, mul:0.125)}.play;

x = {SinOsc.ar(700) * 0.125}.play;


(
z = {
	arg freq=440, amp=1;
	var sig;
	sig = SinOsc.ar(freq) * amp;
}.play;
)

z.set(\freq,330);
z.set(\amp,0.125);
z.set(\freq,660, \amp, 1);
z.set(\amp, 0.125, \freq, 550);
z.free;

//8 random values per second, frequencies between 600+400=1000 and 600-400=200
LFNoise0.kr(8,400,600)
LFNoise0.kr(8).range(200,1000)

//exponentially ranges the notes, creating a more even distribution
LFNoise0.kr(8).exprange(200,1000)

(
z = {
	arg noiseHz=8;
	var freq,amp, sig; .
	freq = LFNoise0.kr(noiseHz).exprange(200,1000);
	amp = LFNoise1.kr(12).exprange(0.02,1);
	sig = SinOsc.ar(freq);
}.play;
)

z.set(\noiseHz, 300)
z.set(\noiseHz, exprand(4,64));
z.free;