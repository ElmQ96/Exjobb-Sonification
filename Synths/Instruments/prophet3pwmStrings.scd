/*
Mitchell Sigman (2011) Steal this Sound. Milwaukee, WI: Hal Leonard Books
pp. 2-3

Adapted for SuperCollider and elaborated by Nick Collins
http://www.sussex.ac.uk/Users/nc81/index.html
under GNU GPL 3 as per SuperCollider license

Minor modifications by Bruno Ruviaro, June 2015.
*/

SynthDef("prophet5pwmStrings", {
	arg out = 0, pan = 0.0, freq = 440, amp = 1.0, gate = 1, att = 0.01, rel = 0, sus = 1, dec = 0.5, lforate = 10, lfowidth = 0.5, cutoff = 12000, rq = 0.5;

	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate * [1, 1.01], Rand(0, 2.0) ! 2);
	pulse = Pulse.ar(freq * [1, 1.01], lfo * lfowidth + 0.5);
	filter = RLPF.ar(pulse, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	Out.ar(out, Pan2.ar(
		in: Mix(filter) * env * 0.5,
		pos: pan)
	);
}).play;

Pbindef(\prophet5pwmStrings,
	\instrument, "prophet5pwmStrings",
	\note, Pseq([0, 3, 8, 7, 5, 8, 7, 3], inf),
	\ctranspose, -12,
	\amp, 0.1,
	\dur, Pseq([Pn(0.5, 8), Pn(0.25, 8), Pn(0.125, 16)], 1),
	\lfowidth, Pn(Pseries(0.0, 0.025, 7), inf),
	\lforate, Pn(Pseries(2, 1, 11), inf),
	\rq, Pn(Pseries(0.9, -0.1, 5), inf)
);