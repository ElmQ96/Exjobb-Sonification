// SynthDef
(
/*
A SynthDef by Josh Mitchell, 8/19.

The core sound comes from brown noise being sent through two comb filters in series.
The first comb filter randomly fluctuates around the root frequency, creating an effect
halfway between vibrato and a flanger. The second filter is set to a harmonic of the
root frequency. After that, a tiny bit of runaway low end gets filtered out and the
sound is sent through an envelope filter for a vocal sort of sound.
*/

SynthDef("combs", {
	arg
	//Standard Arguments
	out = 0, pan = 0, amp = 0.1, freq = 440, gate = 1, att = 0.01, dec = 0.1, sus = 0.7, rel = 0.5,
	//Other Controls
	rate = 6, depth = 0.2, regen = -3, sweep = 16, rq = 0.5, harmonic = 1.5;

	var max, min, vibrato, snd, env, filterenv;

	//Setting some values for the filters:
	max = ((1 + depth) / freq);
	min = (1 / (freq * (1 + depth)));
	vibrato = LFNoise1.ar(rate).range(min, max);

	//Amplitude and filter cutoff envelopes
	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);
	filterenv = Env.perc(att, rel).kr;
	filterenv = ((filterenv * sweep) + 1) * freq;

	//The core noise:
	snd = BrownNoise.ar(1);
	snd = CombL.ar(snd, max, vibrato, regen);
	snd = CombN.ar(snd, harmonic / freq, harmonic / freq, regen, env);

	//More filters and output stuff:
	snd = RHPF.ar(snd, freq * 4, rq);
	snd = RLPF.ar(snd, filterenv, rq, amp);
	snd = Limiter.ar(snd, amp);
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell",
	category: \bass,
	tags: [\metallic, \bass, \synth, \pitched]
	)
).add

);
// Pattern demo
(
Pbindef( \combs,
	\instrument, "combs",
	\dur, Pseq([1, Pn(1/8, 7), 1, Pn(1/8, 5), 1, Pn(1/8, 7), 1, Pn(1/8, 9), 1]),
	\legato, Pseq([1, Pn(0.1, 7), 1, Pn(0.1, 5), 1, Pn(0.1, 7), 1, Pn(0.1, 9), 1]),
	\ctranspose, -20,
	\degree, Pseq([
		           -2, Prand([0, 1, 2, 4, 5, 7], 7),
		            5, Prand([1, 2, 4, 5, 7, 8], 5),
		            0, Prand([0, 1, 2, 4, 5, 7], 7),
		            2, Prand([-2, 0, 1, 2, 4, 5], 9), [-2, 5]
	            ]),
	\amp, Pseq([
		            0.5, Prand([0.5, 0.25, 0], 7),
		            0.5, Prand([0.5, 0.25, 0], 5),
		            0.5, Prand([0.5, 0.25, 0], 7),
		            0.5, Prand([0.5, 0.25, 0], 9), 0.5
	            ]),
).play;
);