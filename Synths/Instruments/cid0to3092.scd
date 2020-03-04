// SynthDef
(
/*
Based on acid_oto309.scd

This version uses percussive envelopes for both amp and filter sweep.
Filter sweep is calculated in octaves

Modified by Bruno Ruviaro and Josh Mitchell, August 2019.
*/

SynthDef("acidOto3092", {
	arg
	// Standard Arguments
	out = 0, freq = 440, amp = 0.1, pan = 0, att = 0.001, rel = 0.5,
	// Other Controls
	// width is 0 to 1
	// filterRange is in octaves
	lagTime = 0.12, filterRange = 6, width = 0.51, rq = 0.3;

	var ampEnv, filterEnv, snd, pitch;

	pitch = freq.cpsmidi; // Lag only useful if synth is played with Pmono

	ampEnv = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);

	filterEnv = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: filterRange * 12, // octaves to semitones
	).kr;

	snd = LFPulse.ar(freq: pitch.midicps, width: width).range(-1, 1);

	// filter sweeps from current pitch all the way up to <filterRange> octaves above and back down.
	snd = RLPF.ar(snd, (pitch + filterEnv).midicps, rq).distort;

	snd = snd * ampEnv;

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "based on 08091500Acid309 by otophilia",
	category: \bass,
	tags: [\pitched, \acid, \phat, \subtractive]
	)
).add;

);
// Pattern demo
(
Pbindef(\acidOto3092,
	\instrument, "acidOto3092",
	\dur, Pseq([Pn(1/8, 8), 1/2, 1/8, 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, Rest(1/8), 1/8, 3/8, 3/8, 3/8, 1/2]),
	\rel, Pseq([Pn(0.4, 8), 0.8, Pn(0.4, 8), Pn(0.4, 2), 0.8, 1]),
	\att, Pseq([Pn(0.001, 8), 0.05, Pn(0.001, 8), 0.01, 0.1, 0.3, 0.5]),
	\ctranspose, -32,
	\filterRange, Pn(Pseries(3, 1, 3)), // in octaves
	\width, Pwhite(0.25, 0.75, inf),
	\degree, Pseq([Pn(2, 6), 4, 5, -2, -3, -2, \rest, 0, \rest, 3, \rest, 1, 4, 6, 2, -2]),
	\amp, Pseq([0.1, 0.1, 0.15, 0.2, 0.2, 0.25, 0.3, 0.3, 0.7, 0.1, 0.15, 0, 0.2, 0, 0.3, 0, 0.4, 0.5, 0.6, 0.6, 0.4]),
).play;
);