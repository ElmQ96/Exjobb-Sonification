(
{
    var mod = LFGauss.ar(MouseX.kr(1, 0.07, 1), 1 * (MouseY.kr(1, 3) ** (-1..-6)));
    var carr = SinOsc.ar(200 * (1.3 ** (0..5)));
    (carr * mod).sum * 0.1
}.play;
)

//Chaotic
{SinOscFB.ar(440,MouseX.kr(0,4))*0.1}.play

//Deterministic
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;

(
b = Buffer.alloc(s, 512, 1, {arg buf; buf.sine1Msg(1.0/[1,2,3,4,5,6,7,8,9,10])});
{ COsc.ar(b.bufnum, 200, 0.7, 0.25) }.play;
)

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007])) }.play;

play({ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 });

(
{
loop({
    play({
        Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf);
    });
    2.wait;
})
}.fork;
)

{ LFGauss.ar(MouseX.kr(1, 0.001, 1), 0.1) * SinOsc.ar(1000) * 0.1 }.play;

(
{     var dur = SinOsc.ar(MouseX.kr(2, 1000, 1) * [1, 1.1]).range(0.0006, 0.01);
    var width = SinOsc.ar(0.5 * [1, 1.1]).range(0.01, 0.3);
    LFGauss.ar(dur, width) * 0.2
}.play
);



{ LFPar.kr(XLine.kr(1, 200, 10)) * SinOsc.ar(440) * 0.1 }.play;

(
SynthDef("help-VOsc",{ arg out=0, bufoffset=0;
    var x;
    // mouse x controls the wavetable position
    x = MouseX.kr(0,7);
    Out.ar(out,
        VOsc.ar(bufoffset+x, [120,121], 0, 0.3)
    )
}).play(s,[\out, 0, \bufoffset, 0]);
)

//Granular
(
b.free;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
{
    var pointer = Phasor.ar(0, SampleDur.ir / BufDur.ir(b) * XLine.kr(1, 0.25, 20));
    var sound = Warp1.ar(1, b, pointer, 1, 0.3, -1, 16, Line.kr(0, 1, 40), 4);
    Pan2.ar(sound, pointer * 2 - 1, 0.25)
}.play
)

//Physical models
(
{
    var t, sf;
    sf = K2A.ar(MouseX.kr > 0.5) > 0;
    t = TBall.ar(sf, MouseY.kr(0.01, 1.0, 1), 0.01);
    Pan2.ar(Ringz.ar(t * 10, 1200, 0.1), MouseX.kr(-1,1));
}.play;
)

(
{
    var t, sf, g;
    sf = LFNoise0.ar(MouseX.kr(0.5, 100, 1));
    g = MouseY.kr(0.01, 10, 1);
    t = TBall.ar(sf, g, 0.01, 0.002);
    Ringz.ar(t * 4, [600, 645], 0.3);
}.play;
)

(
{
    var f, g, h, fr;
    fr = MouseX.kr(1, 1000, 1);
    h = MouseY.kr(0.0001, 0.001, 1);
    g = LFNoise1.kr(0.1, 3, 5);
    f = TBall.ar(SinOsc.ar(fr), g, 0.1, h);
    Pan2.ar(Ringz.ar(f, 1400, 0.04),0,5)
}.play;
)

//Stochastic
{ BPF.ar(BrownNoise.ar(0.1.dup), MouseX.kr(40, 17000, 1), 0.2) }.play;

{ Crackle.ar(Line.kr(1.0, 2.0, 3), 0.5, 0.5) }.play;

(
        {
            Mix.fill(10, {
                var freq = rrand(130,160.3);
                Pan2.ar(SinOsc.ar(Gendy1.ar(6.rand, 6.rand, SinOsc.kr(0.1, 0, 0.49, 0.51),
                    SinOsc.kr(0.13, 0, 0.49, 0.51), freq, freq, SinOsc.kr(0.17, 0, 0.49, 0.51),
                    SinOsc.kr(0.19, 0, 0.49, 0.51), 12, 12, 200, 400), 0, 0.1), 1.0.rand2)
            })
        }.play
    )

(
        {
            Pan2.ar(
                CombN.ar(
                    Resonz.ar(
                        Gendy1.ar(2, 3, minfreq:1, maxfreq: MouseX.kr(10, 700), durscale:0.1, initCPs:10),
                        MouseY.kr(50, 1000), 0.1),
                    0.1, 0.1, 5, 0.6
                ),
                0.0)
        }.play
    )

{SinOsc.ar(Vibrato.ar(DC.ar(400.0),LFNoise1.kr(1,3,7),MouseX.kr(0.0,1.0),1.0,1.0,MouseY.kr(0.0,1.0),0.1) )}.play

(
SynthDef("help-Dust2", { arg out=0;
    Out.ar(out,
        Dust2.ar(XLine.kr(20000, 2, 10), 0.5)
    )
}).play;
)

//Other

(
{
    var exciter;
    exciter = WhiteNoise.ar(0.001);
    Mix.arFill(10, {
        Ringz.ar(exciter,
        XLine.kr(exprand(100.0,5000.0), exprand(100.0,5000.0), 20),
        0.5)
    })
}.play
)


//FFT

(
{
    var in, chain;
    in = SinOsc.ar(LFNoise1.kr([5.2, 3.3],250,400));
    chain = FFT({ LocalBuf(2048) } ! 2, in); // we need two buffers for stereo input.
    // moves in and out of freeze
    chain = PV_MagFreeze(chain, SinOsc.kr([0.2, 0.3]) );
    0.5 * IFFT(chain);
}.play;
)

//Pluck
(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)

//Demand
(
{
    var trig, seq;
    trig = Impulse.kr(8);
    seq = Drand([
        Dseq([4,0,0,1,2,1,0,1]),
        Dseq([4,0,2,0,1,0,1,1]),
        Dseq([4,0,0,2,0,0,1,1]),
        Dseq([4,0,1,2,0,1,2,0]),
        Dseq([4,1,1,1,2,2,3,3]),
        Dseq([4,1,0,1,0,1,0,1])
    ], inf);
    trig = Demand.kr(trig, 0, seq * 0.4) * trig;
    {LPF.ar(PinkNoise.ar, 5000)}.dup * Decay.kr(trig, 0.5);
}.play;
)
(
{
    var freq, trig, reset, seq;
    trig = Impulse.kr(10);
    seq = Dseq([72, 75, 79, Drand([82,84,86])], inf).midicps;
    freq = Demand.kr(trig, 0, seq);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)

//Xline
play({ SinOsc.ar(XLine.kr(200,17000,10),0,0.1) });

//TOUR OF UGENS

{ Klang.ar(`[ {exprand(400, 2000)}.dup(16), nil, nil ], 1, 0) * 0.04 }.scope(1);

{ BrownNoise.ar(0.2) }.scope(1);

{ Dust.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);
{ Dust2.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);

{ Crackle.ar(MouseX.kr(1,2), 0.5) }.scope(1);

{ Saw.ar(500, 0.1) + Dust2.ar(100, 0.9) }.scope(1);

{ Formlet.ar(Impulse.ar(MouseX.kr(2,300,1), 0, 0.4), 800, 0.01, 0.1) }.scope(1, zoom:4);

{ Pan4.ar(BrownNoise.ar, MouseX.kr(-1,1), MouseY.kr(1,-1), 0.3) }.scope(4);

{ PanAz.ar(5, BrownNoise.ar, MouseX.kr(-1,1), 0.3, 2) }.scope(5);

{ XFade2.ar(BrownNoise.ar, SinOsc.ar(500), MouseX.kr(-1,1), 0.3) }.scope(1);

{ SinOsc.ar(Lag.ar(LFPulse.ar(2,0,0.5,800,400), MouseX.kr(0,0.5)), 0, 0.2) }.scope(1, zoom:4);

//artifical space
//Building a sense of space into a sound by setting up phase differences between the speakers.
// correlated
{ var x; x = LPF.ar(BrownNoise.ar(0.2), MouseX.kr(100,10000)); [x,x] }.scope(2);
// not correlated
{ LPF.ar({BrownNoise.ar(0.2)}.dup, MouseX.kr(100,10000)) }.scope(2);

(
// more spatial sounding. phasing causes you to perceive directionality
{ var x; x = BrownNoise.ar(0.2);
    [DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0.02, 0))]
}.scope(2);
)