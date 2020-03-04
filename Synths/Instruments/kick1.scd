// SynthDef
(
SynthDef("kick1", {arg out = 0, amp = 0.3, sinFreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var gliss = XLine.kr(sinFreq, sinFreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = snd * env * amp;
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Bruno Tucunduva Ruviaro",
	category: \drums,
	tags: [\percussion, \kick]
)
).add;

);
// Pattern demo
(
Pbindef(\kick1,
	\instrument, "kick1",
	\dur, Pseq([
		3/4, 1/4,
		1/2, 1/2,
		Rest(1/2), 1/2,
		Rest(1/4), 3/4
	], 3) * 0.5,
	\amp, 0.9,
	\rel, Pseq([0.9, Pn(0.15, 6), 0.6], inf),
	\glissf, Pseq([Pn(0.9, 7), 0.5], inf)
).play;
);