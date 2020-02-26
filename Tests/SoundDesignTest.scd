(//10^24 kg, pitch, relation, inversed
~massMercury = 600;
~massVenus = 278.0141844;
~massEarth = 200;
~massMars = 577.8723404;

//days,
~orbitMercury = 1;
~orbitVenus = -0.7946076795;
~orbitEarth = 0.5835058431;
~orbitMars = 0.1;

//10^6 km,
~sundistanceMercury = 57.9;
~sundistanceVenus = 108.2;
~sundistanceEarth = 149.6;
~sundistanceMars = 227.9;

//hours, vibrato (Pan)
~rotationMercury = 0.7856058258+1;
~rotationVenus = 0.1+1; //-
~rotationEarth = 1+1;
~rotationMars = 0.9998915401+1;
)//Orbital Eccentricity based on vibrato depth


ServerOptions.outDevices();

(
{
    var mod = LFGauss.ar(MouseX.kr(1, 0.07, 1), 1 * (MouseY.kr(1, 3) ** (-1..-6)));
    var carr = SinOsc.ar(200 * (1.3 ** (0..5)));
    (carr * mod).sum * 0.1
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.3!2);
	sig = LPF.ar(sig, MouseX.kr(30,18000,0).poll);
}.play;
)

(
SynthDef("mod", {
	arg freq, rate, pan, reverb, amp=0.1;
	var sig, resfreq;
	sig = Saw.ar(freq);
	resfreq = SinOsc.kr(rate) * 200 + 500;
	sig = RLPF.ar(sig, resfreq, 0.2);
	sig = sig * amp;
	sig = FreeVerb.ar(sig, reverb, 0.5, 0.1);
	//sig = Splay.ar(sig,0,0.5,pan);
	sig = PanAz.ar(7, sig, LFSaw.kr(pan/5),1,4,0);
	//Out.ar(0, sig);
	Out.ar(~surround, sig);

	Out.ar(2, In.ar(22, 1));
	Out.ar(1, In.ar(23, 1));
	Out.ar(5, In.ar(24, 1));
	Out.ar(7, In.ar(25, 1));
	Out.ar(6, In.ar(26, 1));
	Out.ar(4, In.ar(27, 1));
	Out.ar(0, In.ar(28, 1));
}).add;
)

(
SynthDef.new(\wind, {
	arg amp;
	var sig;
	sig = PinkNoise.ar(amp!2);
	sig = LPF.ar(sig, Vibrato.kr(1000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, 20);
	sig = FreeVerb.ar(sig, 0.5, 1.0, 1.0);
	Out.ar(0,sig);
}).add;
)

(
//Synth.new(\wind, [\amp, 0.0]);
~mercury = Synth.new(\mod, [
		\freq, ~massMercury,
		\rate, ~rotationMercury,
		\pan, ~orbitMercury,
		\reverb, 0.7,
]);
)

(
Synth.new(\wind, [\amp, 0.2]);
~venus = Synth.new(\mod, [
		\freq, ~massVenus,
		\rate, ~rotationVenus,
		\pan, ~orbitVenus,
		\reverb, 0.5,
]);


)

(
//Synth.new(\wind, [\amp, 0.2]);
~earth = Synth.new(\mod, [
		\freq, ~massEarth,
	\rate, ~rotationEarth,
	\pan, ~orbitEarth,
	\reverb, 0.6,

]);
//~moon = Synth.new(\mod, [
//		\freq, ~massEarth*2,
//		\rate, ~rotationEarth,
//]);
)

(
//Synth.new(\wind, [\amp, 0.0]);
~mars = Synth.new(\mod, [
		\freq, ~massMars,
		\rate, ~rotationMars,
		\pan, ~orbitMars,
		\reverb, 0.9,
]);
)