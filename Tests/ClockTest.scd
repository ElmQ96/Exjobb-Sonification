(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.perc(attackTime: 0.01, releaseTime: 0.05, level: 1.0, curve: -4.0),
		doneAction:0
	);
	sig = WhiteNoise.ar(100);
	sig = HPF.ar(sig, 2000, );
	sig = LPF.ar(sig, 300, );
	//sig = BPF.ar(sig, 1500, 0.3);
	sig = sig * env;
	//sig = FreeVerb.ar(sig,0.01);
	sig!2;
}.play
)

(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.perc(attackTime: 0.00, releaseTime: 0.1, level: 1.0, curve: -4.0),
		doneAction:0
	);
	sig = LFTri.ar(300) *100;
	//sig = BPF.ar(sig, 600, 0.01) * 100;
	sig = HPF.ar(sig, 3000, );
	sig = LPF.ar(sig, 200, );
	sig = sig * env;
	//sig = FreeVerb.ar(sig);
	sig!2;
}.play
)


(
SynthDef("help-Dust2", { arg out=0;
    Out.ar(out,
        Dust2.ar(XLine.kr(20000, 2, 10), 0.5)
    )
}).play;
)

(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(1), 240.reciprocal, 240.reciprocal, 1,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)

(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)

{ Dust.ar(MouseX.kr(5,1000,1), 0.4) }.scope(1, zoom:4);
{ Dust2.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);