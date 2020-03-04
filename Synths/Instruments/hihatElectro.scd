// SynthDef
(
/* Retrieved from
http://sccode.org/1-5aD

By Nathan Ho aka Snappizz
http://sccode.org/1-523

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("hihatElectro", {
    arg out = 0, pan = 0, amp = 0.3, att = 0.001, rel = 0.3, curve = -8, filterFreq = 4010, rq = 0.56;

    var env, snd;

    // noise -> resonance -> exponential dec envelope
    env = Env.perc(attackTime: att, releaseTime: rel, curve: curve).kr(doneAction: 2);

	snd = ClipNoise.ar(amp);
	snd = BPF.ar(
		in: snd,
		freq: [1, 1.035] * filterFreq,
		rq: [0.27, 1] * rq,
		mul: [1.0, 0.6]
	);
	snd = Mix(snd) * env;

    Out.ar(out, Pan2.ar(snd, pan));

	},
metadata: (
	credit: "By Nathan Ho aka Snappizz",
	category: \drums,
	tags: [\clap, \percussion, \hihat]
	)
).add;

);
// Pattern demo
(
Pbindef(\hihatElectro,
	\instrument, "hihatElectro",
	\dur, Pseq([
		Rest(1/16), Pn(1/16, 3),
		1/8, 1/8,
		Rest(1/8), 1/8,
		Rest(1/16), 1/8, 1/16
	], 2) * 2,
	\amp, Pseq([
		\rest, 0.1, 0.3, 0.5,
		0.7, 0.5,
		\rest, 0.5,
		\rest, 0.6, 0.4
	], inf),
	\rel, Pseq([
		\rest, Pn(0.3, 3),
		0.4, 0.5,
		\rest, 0.3,
		\rest, 0.3, 0.5
	], inf),
	\filterFreq, Pseries(4500, -75)
).play;
);