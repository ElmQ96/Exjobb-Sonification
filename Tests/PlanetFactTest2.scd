(//10^24 kg, pitch, relation, inversed
~massMercury = 2000;
~massVenus = 551.0638298;
~massEarth = 200;
~massMars = 1900.425532;

//days, Length of sound
~orbitMercury = 88.0;
~orbitVenus = 224.7;
~orbitEarth = 365.2;
~orbitMars = 687.0;

//10^6 km,
~sundistanceMercury = 57.9;
~sundistanceVenus = 108.2;
~sundistanceEarth = 149.6;
~sundistanceMars = 227.9;

//hours, Speed of pulse
~rotationMercury = 0.7856058258;
~rotationVenus = 0.1; //-
~rotationEarth = 1;
~rotationMars = 0.9998915401;
)//Orbital Eccentricity based on vibrato depth


//Reverbed ekolod
(
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;
SynthDef.new(\reverb, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 2); //the source is stereo (line 64 has !2), so specify 2 channels
	sig = sig + (GVerb.ar(sig, 200, 5) * 0.2); //apply reverb by summing dry + wet
	Out.ar(out, sig); //out to arbitrary bus
}).add;
)
Synth.new(\reverb, [\in, 57, \out, 0]);
(
~source = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57
	]);
)

(
Synth.new(\reverb, [\in, 55, \out, 0]);
~mercury = Synth.new(\source, [
		\freq, ~massMercury,
		\amp, 0.1,
		\env_rate, ~rotationMercury,
		\out, 55
	]);
)
(
Synth.new(\reverb, [\in, 56, \out, 0]);
~venus = Synth.new(\source, [
		\freq, ~massVenus,
		\amp, 0.1,
		\env_rate, ~rotationVenus,
		\out, 56
	]);
)
(
Synth.new(\reverb, [\in, 59, \out, 0]);
~earth = Synth.new(\source, [
		\freq, ~massEarth,
		\amp, 0.1,
		\env_rate, ~rotationEarth,
		\out, 59
	]);
)
(
Synth.new(\reverb, [\in, 58, \out, 0]);
~mars = Synth.new(\source, [
		\freq, ~massMars,
		\amp, 0.1,
		\env_rate, ~rotationMars,
		\out, 58
	]);
)


