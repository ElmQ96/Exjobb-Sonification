//Processing Synth, after 20 minutes in tutorial 16, part III
(
SynthDef(\reverb, {
	arg in, predelay = 0.1, revtime=1.8, lpf=4500;
	var dry, wet, temp, sig;
	dry = In.ar(in,2);
	temp = In.ar(in,2);
	wet = 0;
	temp = DelayN.ar(temp, 0.2, predelay);
	16.do{
		temp = AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2,revtime);
		temp = LPF.ar(temp,lpf);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry,wet,mix*2-1,amp);
	Out.ar(out, sig);
}).add;
)

~reverbBus = Bus.audio(s,2);
~reverbSynth = Synth(\reverb, [\in, ~reverbBus])