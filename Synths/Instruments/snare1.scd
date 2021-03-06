// SynthDef
(
SynthDef("snare1", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	var mix = HPF.ar(snd1, ffreq) + snd2;
	mix = mix * env;
	Out.ar(out, Pan2.ar(mix, pan));
},
metadata: (
	credit: "Bruno Tucunduva Ruviaro",
	category: \drums,
	tags: [\percussion, \snare]
)
).add;

);
// Pattern demo
(
Pbindef(\snare1,
	\instrument, "snare1",
	\dur, Pseq([
		Pseq([Pn(1/16, 3), 1/3, Rest(1/3)], 2),
		Pn(1/12, 3),
		Pn(1/3, 3)
	], 1),
	\amp, 0.25,
	\rel, 0.1
).play;
);