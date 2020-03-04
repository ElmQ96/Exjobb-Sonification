/*Retrieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/apad_mh.scd

"A simple sustained sound with vibrato" --Mike Hairston

FreeVerb.ar added by Josh Mitchell.

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\apad_mh, {
	arg
	//Standard Values:
	out = 0, pan = 0, freq = 880, amp = 0.5, att = 0.4, dec = 0.5, sus = 0.8, rel = 1.0, gate = 1,
	//Other Controls:
	vibratoRate = 4, vibratoDepth = 0.015, tremoloRate = 5,
	//These controls go from 0 to 1:
	tremoloDepth = 0.5, reverbMix = 0.5, roomSize = 1, damp = 0.5;

	var env, snd, vibrato, tremolo, mod2, mod3;

	env = Env.adsr(att, dec, sus, rel).kr(gate: gate);
	vibrato = SinOsc.kr(vibratoRate).range(freq * (1 - vibratoDepth), freq * (1 + vibratoDepth));
	tremolo = LFNoise2.kr(1).range(0.2, 1) * SinOsc.kr(tremoloRate).range((1 - tremoloDepth), 1);

	snd = SinOsc.ar(freq: [freq, vibrato], mul:(env * tremolo * amp)).distort;
	snd = Mix.ar([snd]);
	snd = FreeVerb.ar(snd, reverbMix, roomSize, damp);

	DetectSilence.ar(snd, 0.0001, 0.2, doneAction: 2);
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata:(
	credit: "Mike Hairston",
	tags: [\pad, \vibrato, \sustained]
	)
).add

Pbindef( \apad_mh,
	\instrument, "apad_mh",
	\dur, 4,
	\tremoloRate, Pwhite(4.0, 6.0, inf),
	\ctranspose, -5,
	\strum, Pseq([0.05, -0.05, 0.05, 0.05, -0.05]),
	\note, Pseq([
	        	    [3, 5, 10, 12, 17, 19], [2, 6, 9, 13, 16, 20],
	        	    [4, 11, 18], [2, 6, 9, 13, 16, 20],
	        	    [0, 7, 14, 21]
	            ]),
	\amp, 0.1
);