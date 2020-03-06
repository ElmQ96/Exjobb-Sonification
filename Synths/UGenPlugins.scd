( //drum
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneCircle.ar(excitation, tension, loss);
}.play;
)

( //Tippity tap
SynthDef("help-GaussTrig", { arg out=0;
    Out.ar(out,
        Ringz.ar(
            WhiteNoise.ar(
                Decay.kr(
                    GaussTrig.kr(10.dup, MouseX.kr(0, 0.9), 0.5),
                    0.02,
                    0.2
                )
            ),
            2000,
            0.02
        ).fold2(0.2)
    )
}).play;
)

( //blippity bloop
var scale, buffer;
scale = FloatArray[0, 2, 4, 6, 7, 9, 11];
buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });
​
play({
    var mix;
    mix =
    SinOsc.ar(
        (
            DegreeToKey.kr(
                buffer.bufnum,
                Gendy5.kr(minfreq:1, maxfreq:8, ampscale:0.1, durscale:0.1, initCPs:3, mul:7.5, add:7.5),
                12,
                1,
                60
            )
            + LFNoise1.kr([3,3], 0.04)
        ).midicps,
        0).cubed * 0.1
    + RLPFD.ar(LFPulse.ar([48,55].midicps, 0.15),
        Gendy4.kr(2, 2, 1, 1, 0.1, 0.2, 0.1, 0.1, 2, mul:10, add:72).midicps, 0.6, 0.2);
    CombN.ar(mix, 0.31, 0.31, 2, 0.2, mix)
})
)
​
(
SynthDef("plucking", {arg out = 0, amp = 0.1, freq = 440, decay = 5, coef = 0.1;
	var env, snd;
	env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);
	snd = Pluck.ar(
		in: PinkNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: coef);
	snd = LeakDC.ar(snd).clip2;
	Out.ar(out, snd * env);
}).add;

b = Bus.audio(s,1);

SynthDef("reverbBus", { arg outBus = 0, inBus, wet = 0.5;
	var input, rev;
	input = In.ar(inBus,1);
	rev = JPverb.ar(input * wet, t60:3);
    Out.ar(outBus, input + rev);
}).add;
)


( // start reverb at the end of the group
~reverb = Synth("reverbBus", [\inBus, b, \wet, 0.6]);

Pbind(
	\instrument, "plucking",
	\out, b,
	\scale, Scale.major.tuning_(\just),
	\octave, 4,
	\degree, Pseq([1,3,7,8,Prand([7,10,11,13,14]),8,7,3], inf),
	\dur, Pseq([Pwrand([
		Pseq([0.2,0.2]),
		//0.2,
		0.4,
		Pseq([0.1],4),
		Pseq([0.05],4)],
		[0.5,0.3,0.1,0.1] // weights
	)], 240),
	\coef, Pwrand([0.8, 0.6, 0.4, 0.2], [0.4,0.3,0.2,0.1], inf),
	\amp, 1,
	\addAction, 0, // make sure new synths are added to head of group (optional)
).play;
)

// set reverb 'wetness'
~reverb.set(\wet,1);

( // set tempo
var bpm = 50;
t = TempoClock.default;
t.tempo_(bpm/60) // beats per minute
)

(
SynthDef(\bird,{
	var sig, freqenv, env, trig;
	trig = Dust.ar(2);
	env = EnvGen.ar(Env.perc(0.01,0.4,0.8,-8), trig, doneAction: 2);
	freqenv = EnvGen.ar(Env([Rand(1000,3000), Rand(3000,6000), Rand(1000,2000), Rand(2000,5000)],[0.1,0.01,0.1]);, trig);
	sig = SinOsc.ar(freqenv, 0, env);
	sig = Pan2.ar(sig, Rand(-1.0,1.0));
	Out.ar(0, sig);
}).add;
)

(
Routine({
	inf.do({
		Synth(\bird);
		rrand(1.0,2.0).wait;
	})
}).play;
)

