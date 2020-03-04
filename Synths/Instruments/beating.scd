// SynthDef
(
/*
A SynthDef by Bruno Ruviaro built around beats, an acoustic phenomenon created when
two oscillators at slightly different frequencies are combined. We hear the beating
frequency as the difference between these two frequencies.

For example, 455hz - 440hz = 15 beats per second.

Slightly modified by Josh Mitchell 8/19.
*/

SynthDef("beating", {
	arg freq = 440, amp = 0.1, out = 0, pan = 0, att = 0.01, dec = 1, curve = -4, beatFreq = 15;

	var env, snd, oscillator1, oscillator2;

	env = Env.perc(att, dec, amp, curve).kr(doneAction: 2);

	oscillator1 = SinOsc.ar(freq); //Try other waveforms for the oscillators! Mix and match, collect them all!
	oscillator2 = SinOsc.ar(Line.kr(freq + beatFreq, freq, dec));

	snd = Mix([oscillator1, oscillator2]);
	snd = snd * env;

	Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Bruno Ruviaro",
	category: \misc,
	tags: [\pitched]
	)
).add

);
// Pattern demo
(
Pbindef(\beating,
	\instrument, "beating",
	\ctranspose, -8,
	\curve, -6,
	\beatFreq, 9,
	\dur, Pwhite(0.25, 0.3, inf),
	\dec, Pwhite(0.7, 1.75, inf),
	\note, Pseq([Pseq([0, 11, 7], 4), Pseq([3, 14, 10], 2), 2, 6, 7, 6, [0, 7, 11]], 1),
	\amp, Pseq([Pseq([0.35, 0.15, 0.35, 0.2, 0.2, 0.2], 3), 0.35, 0.35, 0.35, 0.25, 0.25], 1),
	// comment out next three lines for another variation
	// \ctranspose, [-8, 0],
	// \strum, 0.045,
	// \amp, Pkey(\amp) * [1, 0.2]
).play;
);