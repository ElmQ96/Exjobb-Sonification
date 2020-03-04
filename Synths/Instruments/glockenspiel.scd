// SynthDef
(
/* Retrieved from
http://sccode.org/1-5aD

Glockenspiel, xylophone, and tubularBell are all based on a very similar structure.
By nicolaariutti and edited by Zé Craum
http://sccode.org/1-5ay#c835

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\glockenspiel, {
	arg freq = 440, amp = 0.01, pan = 0, out = 0, att = 0.001, rel = 6, exciterRel = 0.05;

	var env, snd, exciter;

	env = Env.perc(att, exciterRel, 0.25).kr;

	exciter = WhiteNoise.ar(env);

	snd = DynKlank.ar(
		specificationsArrayRef:
	        	Ref.new([
	        		[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // harmonics
			        [1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
		        	[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]     // ring times
		        ]),
		input: exciter,
		freqscale: freq,
		decayscale: rel
	);

	DetectSilence.ar(
		        in: snd,
		        amp: 0.001,
		        time: 0.5,
		        doneAction: 2
		    );

	Out.ar(out, Pan2.ar(snd, pan, amp));
},
metadata: (
	credit: "http://sccode.org/1-5aD",
	category: \bells,
	tags: [\pitched]
	)
).add

);
// Pattern demo
(
Pbindef(\glockenspiel,
	\instrument, "glockenspiel",
    \ctranspose, 12,
	\dur, Pseq([Pn(1/3, 6), 2/3, Pn(1/3, 6), 1], 1),
    \degree, Pseq([7, 5, 6, 4, 5, 3, 4, 3, 1, 2, 0, 1, -1, 0], 1),
).play;
);