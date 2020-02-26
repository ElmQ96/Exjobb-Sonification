(
x = {
	arg freq = 200;
	var sig;
	sig = SinOsc.ar(freq, 0, 0.2);
	sig = sig + SinOsc.ar(MouseX.kr(freq, freq + 200).poll, 0, 0.2);
	sig = sig * SinOsc.kr(2).range(0,1);
	sig = sig!2;
}.play;
)

//envelopes
(
{
	var sig;
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 1000, 0.02) * 10;
	sig!2;
}.play
)

(
e = Env.new([0,1,0.2,0.2,0.5,0],[0.1,0.1,3,0.2,0.2],'lin');
e.plot;
)

(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[0.01,1],[0,-4]),
		doneAction:0
	).poll;
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play
)

x.free;

Env.perc.plot
Env.sine.plot
Env.adsr.plot(2)

(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.perc,
		doneAction:2
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play
)

(
x = {
	arg gate=0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(0.01,0.2,0.3,1),
		gate,
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play;
)

x.set(\gate, 1)
x.set(\gate, 0)

(
x = {
	arg t_gate=0;
	var sig, env;
	env = EnvGen.kr(
		Env.perc,
		t_gate,
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play;
)

x.set(\t_gate, 1)

//arrays
x = [2, 30, 4.5, "hello"];

x.size;

x.at(2);
x[3];

x[2] = 97

x

x = Array.series(20, 5, 5);
x = Array.geom(12, 100, 2);

x = Array.series(20, 80, 80);

x = x.scramble;

x.choose;

(1,7..99)


//randomness

rrand(1,100)

exprand(1,100)

{rrand(1,100)}!2

//synthesis

(
{
	var sig, freq, env;
	freq = {
		exprand(50,5000)
	}!64;
	env = EnvGen.kr(
		Env.new([0,1,0],[2,2],[2,-2]),
		doneAction:2
	);
	sig = SinOsc.ar(freq) * 0.1;
	sig = Splay.ar(sig) * env;
}.play
)

[1,2,3,4].sum

s.meter;

SinOsc.ar([400,800]);

[SinOsc.ar(400), SinOsc.ar(800)]


















