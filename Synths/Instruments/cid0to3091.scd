// SynthDef
(
/*
Retrieved from acid_oto309.scd
Envelopes from original changed to ADSR, filterRange calculated in octaves
Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("acidOto3091", {
	arg
	// Standard Arguments
	out = 0, gate = 1, freq = 440, amp = 0.1, pan = 0, att = 0.001, dec = 0.5, sus = 0.1, rel = 0.5, curve = -4,
	// Other Controls
	// width is 0 - 1
	// filterRange is in octaves
	lagTime = 0.12, filterRange = 6, width = 0.51, rq = 0.3;

	var ampEnv, filterEnv, snd;

	freq = Lag.kr(freq, lagTime);

	ampEnv = Env.adsr(
		attackTime: att,
		decayTime: dec,
		sustainLevel: sus,
		releaseTime: rel,
		peakLevel: amp,
		curve: [0, curve, curve, curve]
	).kr(gate: gate);

	filterEnv = Env.adsr(
		attackTime: att,
		decayTime: dec * 2,
		sustainLevel: sus / 2,
		releaseTime: rel * 2,
		peakLevel: 2.pow(filterRange), // octaves multiplier
		curve: [-1 * curve, curve, curve, curve],
		bias: 1 // env sweeps from 1 to 2.pow(filterRange) and back
	).kr(gate: gate, doneAction: 2);

	snd = LFPulse.ar(freq: freq, width: width).range(-1, 1);

	snd = RLPF.ar(snd, freq * filterEnv, rq);

	snd = snd * ampEnv;

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "08091500Acid309 by otophilia",
	category: \bass,
	tags: [\pitched, \acid, \phat, \subtractive]
	)
).add;

);
// Pattern demo
(
Pdef(\acidOto3091,
	PmonoArtic(
		"acidOto3091",
		\dur, Pseq([Pn(1/8, 8), 1/2, 1/8, 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, 3/8, 3/8, 4/8, 1/2]),
		\rel, Pseq([Pn(0.2, 8), 0.8, Pn(0.2, 8), Pn(0.4, 2), 0.8, 4]),
		\att, Pseq([Pn(0.001, 8), 0.05, Pn(0.001, 8), 0.01, 0.1, 0.4, 0.5]),
		\legato, Pseq([Pn(0.02, 7), 0.03, 0.9, Pn(0.1, 8), 0.6, 0.9, 1, 1]),
		\ctranspose, -34,
		\lagTime, 0.6,
		\width, Pwhite(0.25, 0.75, inf),
		\degree, Pseq([Pn(2, 6), 4, 5, -2, -3, -2, \rest, 0, \rest, 3, \rest, 1, 4, 6, 2, -2]),
		\amp, Pseq([0.1, 0.1, 0.15, 0.2, 0.2, 0.25, 0.3, 0.3, 0.7, 0.1, 0.15, 0, 0.2, 0, 0.3, 0, 0.4, 0.5, 0.6, 0.8, 0.8]),
	);
).play;
);