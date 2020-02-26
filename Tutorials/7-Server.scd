s.boot;
s.plotTree;
s.meter;

//Nodes, Busses, Order of Execution

//Node --> [Synth, Group]


(
SynthDef.new(\blip, {
	arg out;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300,1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01,0.2),trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out,sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig,0.5,0.8,0.2);
	Out.ar(out,sig);
}).add;
)

s.options.numAudioBusChannels;
s.options.numOutputBusChannels = 4;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

//need to reboot for channel change to happen
s.reboot;
s.meter;

y = Synth.new(\reverb, [\in,6]);
x = Synth(\blip, [\out,6]);
x.set(\out,25);
y.set(\in,25);

~reverbBus = Bus.audio(s,1);
~reverbBus.index;

~reverbBus2 = Bus.audio(s,2);
~reverbBus3 = Bus.audio(s,1);

~reverbBus2.index;

y = Synth.new(\reverb, [\in,~reverbBus2], s, \addToTail);
x = Synth.new(\blip, [\out,~reverbBus2], s);

x = Synth.new(\blip, [\out,~reverbBus2]);
y = Synth.new(\reverb, [\in,~reverbBus2], x, \addAfter);

x = Synth.before(y, \blip, [\out,~reverbBus2]);

8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverb2,
			\fund, exprand(60,300).round(30)
		],
		~sourceGrp
	);
}

~sourceGrp.set(\decay, 0.03);

~sourceGrp = GRoup.new;
~fxGrp = Group.after(~sourceGrp);






g = Group.new;
g.free;




