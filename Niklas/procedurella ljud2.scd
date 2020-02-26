s.boot
// Baston
(
n = LFNoise1;
~baseSound = Ndef(\baseSound,{
	a = SinOsc.ar(65.41)!2;//,Ndef(\baseSound).ar*n.ar(0.1,3),n.ar(3,6)).tanh;
	/*9.do{
		a = AllpassL.ar(a,0.3,{0.2.rand+0.1},5)
	};*/
	a.tanh;
	a * 0.2
}
).play;
)
~baseSound.stop

// Ackord/pad
(
~chordSound = fork{
	loop{
		h = 72.midicps;//([36,39,43].choose.midicps) * (2**((0 .. 4).choose));
		play{
			Splay.ar({
				SinOsc.ar(exprand(h-(h/64),h+(h/64)),0,0.1)}!1);// * LFGauss.ar(10,1/4,0,0,2) * 0.3;
		};
		10.wait;//0.5
	};
};
)
~chordSound.stop
// Regn och åska
(
~weather = Ndef(\rainSound, {
    Limiter.ar(
        tanh(
            3 * GVerb.ar(
                HPF.ar(
					WhiteNoise.ar(1,0),
					//PinkNoise.ar(1,0),
					//PinkNoise.ar(0.08+LFNoise1.kr(0.3,0.02)),
					//LPF.ar(Dust2.ar(LFNoise1.kr(0.2).range(40,50)),7000),
                    //PinkNoise.ar(0.08+LFNoise1.kr(0.3,0.02))+LPF.ar(Dust2.ar(LFNoise1.kr(0.2).range(40,50)),7000),
                    400
                ),
                250,100,0.2,drylevel:0.3
            ) * Line.kr(0,0.1,10)
        ) /*+ (
            GVerb.ar(
                LPF.ar(
                    10 * HPF.ar(PinkNoise.ar(LFNoise1.kr(3).clip(0,1)*LFNoise1.kr(2).clip(0,1) ** 1.8), 20)
                    ,LFNoise1.kr(1).exprange(100,2500)
                ).tanh,
               270,30,0.7,drylevel:0.5
            ) * Line.kr(0,0.5,30)
        )*/
    )
}
).play;
)
~weather.stop
s.scope
