s.boot;

x = {PinkNoise.ar * 0.5}.play;

x.free;


s.plotTree;

(
{
	var sig, freq, env;
	env = XLine.kr(1,0.01,1, doneAction:2);
	freq = XLine.kr(880,110,1,doneAction:2);
	sig = Pulse.ar(freq) * env.dbamp;
}.play
)

0.125.ampdb

x.free;

s.freeAll;


Env.new.plot;

(
x = {
	arg t_gate = 1;
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate);
	sig = Pulse.ar(LFPulse.kr(8).range(600,900)) * env;
}.play
)

Env.new([0,1,0.2,0],[0.5,1,2],[3,-3,0]).plot;

x.set(\t_gate,1);

(
x = {
	arg gate = 0;
	var sig, env, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 200, 0.1);
	env = EnvGen.kr(Env.adsr,gate, doneAction:2);
	sig = VarSaw.ar(SinOsc.kr(freq).range(500,1000)) * env;
}.play
)

x.set(\gate,1);

x.free;

