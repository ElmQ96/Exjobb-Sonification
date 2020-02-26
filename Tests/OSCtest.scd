s.boot;

NetAddr.langPort;
NetAddr.localAddr;

s.meter;

(
OSCdef.new(\mercury,
	{
		arg msg;
		("mercury:" + msg[1]).postln;
		~mercuryDist = msg[1];
		~mercuryAngle = msg[2];
		x.set(\freq, msg[1]*10);
	},'/Mercury'
    )
)
(
OSCdef.new(\venus,
	{
		arg msg;
		("venus:" + msg[1]).postln;
		//func
	},'/Venus'
    )
)
(
OSCdef.new(\mars,
	{
		arg msg;
		("mars:" + msg[1]).postln;
		//func
	},'/Mars'
    )
)
(
OSCdef.new(\earth,
	{
		arg msg;
		("earth:" + msg[1]).postln;
		//func
	},'/Earth'
    )
)
(
OSCdef.new(\jupiter,
	{
		arg msg;
		("jupiter:" + msg[1]).postln;
		//func
	},'/Jupiter'
    )
)
(
OSCdef.new(\saturn,
	{
		arg msg;
		("saturn:" + msg[1]).postln;
		//func
	},'/Saturn'
    )
)
(
OSCdef.new(\uranus,
	{
		arg msg;
		("saturn:" + msg[1]).postln;
		//func
	},'/Uranus'
    )
)
(
OSCdef.new(\neptune,
	{
		arg msg;
		("neptune:" + msg[1]).postln;
		//func
	},'/Neptune'
    )
)


OSCdef(\mercury, {|msg| \unmatching.postln}, '/mercury', n);

(
SynthDef.new(\tone, {
	arg freq=40, nharm=12,detune=0.2,amp=1,pan=0, out=0,gate=0;
	var sig,env;
	env = EnvGen.kr(Env.adsr(0.05,0.1,0.5,3),gate);
	sig = Blip.ar(
		freq *
		LFNoise1.kr(0.2!16).bipolar(detune.neg,detune).midiratio,
		nharm
	);
	sig = sig * LFNoise1.kr(0.5!16).exprange(0.1,1);
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig * env * amp;
	Out.ar(out,sig);
}).add;
)

x = Synth.new(\tone, [\gate,1]);


(
~sound = {
	arg freq= 400;
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[0.01,1],[0,-4]),
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, freq, 0.02) * 10;
	sig = sig * env;
	sig!2;
}
)

x = ~sound.play();
x.play();

(
OSCdef.new(\time,
	{
		arg msg;
		("time:" + msg[1]).postln;
	},'/time'
    )
)
