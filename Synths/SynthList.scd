(
SynthDef("mod", {
	var sig, resfreq;
	sig = Saw.ar(100);
	resfreq = SinOsc.kr(2) * 200 + 500;
	sig = RLPF.ar(sig, resfreq, 0.1);
	sig = sig * 0.3;
	Out.ar(0, sig);
}).play;
)

//wind
play{f=LFDNoise3.kr(1/pi.dup);Mix.fill(5,{RLPF.ar(PinkNoise.ar([1,1]),f.range(200,3000),f.range(0.1,0.8),f.range(0.2,0.5))})}

//Random Sinus
(
x = { var src;
 src = SinOsc.ar( { |i| LFNoise2.kr( rrand(10, 20), 200, i + 3 * 100) } ! 10);
 Splay.ar(src, MouseY.kr(1, 0), 0.2, MouseX.kr(-1, 1));
}.play;
)

//BladeRunner
(
// modal space
// mouse x controls discrete pitch in dorian mode
var scale, buffer;
scale = FloatArray[0, 2, 3.2, 5, 7, 9, 10]; // dorian scale
buffer = Buffer.alloc(s, scale.size,1, {|b| b.setnMsg(0, scale) });

play({
    var mix;

    mix =

    // lead tone
    SinOsc.ar(
        (
            DegreeToKey.kr(
                buffer.bufnum,
                MouseX.kr(0,15),        // mouse indexes into scale
                12,                    // 12 notes per octave
                1,                    // mul = 1
                72                    // offset by 72 notes
            )
            + LFNoise1.kr([3,3], 0.04)    // add some low freq stereo detuning
        ).midicps,                        // convert midi notes to hertz
        0,
        0.1)

    // drone 5ths
    + RLPF.ar(LFPulse.ar([48,55].midicps, 0.15),
        SinOsc.kr(0.1, 0, 10, 72).midicps, 0.1, 0.1);

    // add some 70's euro-space-rock echo
    CombN.ar(mix, 0.31, 0.31, 2, 1, mix)
})
)


//Dot communcating
(
{
    var env = Env([0.0, [-0.2, 0.5], 0.0, 1.0, [-0.4, 0.9], 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
    var envgen = EnvGen.ar(env, Dust.ar(1));
    SinOsc.ar(
        envgen * 440 + 550
    ) * envgen * 0.1
}.play
);




//Notification sound
(
SynthDef(\env_help, { | out, gate = 0, freq = 440 |
    var z;
    z = EnvGen.kr(Env.perc, doneAction: Done.freeSelf) * SinOsc.ar(freq, 0, 0.1);
    Out.ar(out, z)
}).add;
)

(
fork {
    10.do {
        Synth(\env_help);
        0.2.rand.wait;
    }
}
)


(
SynthDef(\gabberkick, {
    var snd, freq, high, lfo;
    freq = \freq.kr(440) * (Env.perc(0.001, 0.08, curve: -1).ar * 48 * \bend.kr(1)).midiratio;
    snd = Saw.ar(freq);
    snd = (snd * 100).tanh + ((snd.sign - snd) * -8.dbamp);
    high = HPF.ar(snd, 300);
    lfo = SinOsc.ar(8, [0, 0.5pi]).range(0, 0.01);
    high = high.dup(2) + (DelayC.ar(high, 0.01, lfo) * -2.dbamp);
    snd = LPF.ar(snd, 100).dup(2) + high;
    snd = RLPF.ar(snd, 7000, 2);
    snd = BPeakEQ.ar(snd, \ffreq.kr(3000) * XLine.kr(1, 0.8, 0.3), 0.5, 15);
    snd = snd * Env.asr(0.001, 1, 0.05).ar(2, \gate.kr(1));
    Out.ar(\out.kr(0), snd * \amp.kr(0.1));
}).play;
)
(
SynthDef(\hoover, {
    var snd, freq, bw, delay, decay;
    freq = \freq.kr(440);
    freq = freq * Env([-5, 6, 0], [0.1, 1.7], [\lin, -4]).kr.midiratio;
    bw = 1.035;
    snd = { DelayN.ar(Saw.ar(freq * ExpRand(bw, 1 / bw)) + Saw.ar(freq * 0.5 * ExpRand(bw, 1 / bw)), 0.01, Rand(0, 0.01)) }.dup(20);
    snd = (Splay.ar(snd) * 3).atan;
    snd = snd * Env.asr(0.01, 1.0, 1.0).kr(0, \gate.kr(1));
    snd = FreeVerb2.ar(snd[0], snd[1], 0.3, 0.9);
    snd = snd * Env.asr(0, 1.0, 4, 6).kr(2, \gate.kr(1));
    Out.ar(\out.kr(0), snd * \amp.kr(0.1));
}).play;
)

//Boiling water
{BPF.ar(PinkNoise.ar(1),LFNoise2.kr(400,1000,1100), LFNoise2.kr(0.5,0.09,0.1))}.play;


play{b=Blip;c=TChoose.kr(Impulse.kr(2),[2,4,20,40,60,80,140,260]*8);Limiter.ar(sin(c*b.ar((c/400)+b.ar(c,4),c/24)),0.5)!2};

play{{a=LFCub;b=LFNoise0;c=Crackle;a.ar([b.kr(300,50,0.5),b.kr(250,50,0.3)],0,1).frac*a.kr(b.kr*c.kr(2,4,8),0,0.5,0.5)}*0.2}

play{a=LFSaw;Splay.ar(MoogFF.ar(a.ar(a.ar(9,2/b=(1..9)))>0.05*GrayNoise.ar(999)*a.ar,2**a.ar(b/3.55).round*b*99,3.5)).tanh}


play{t=ar(TDuty,1/6,0,Dseq([4,4,4,5,4]/4*523));x=ar(SinOsc,ar(Latch,t,t))!2*ar(Decay2,t.tanh);ar(DetectSilence,x,1/9,1,2);x}

play{a=VarSaw;ar(LeakDC,ar(LPF,ar(Splay,ar(b=CombN,ar(b,cos(ar(a,[11-1,11<<1,11,11>>1,11+1]**ar(a,11.1,1,1/11,1,1.11111111))*ar(a,d=1/(1..11)/1,d,1/11,ar(a,1.11/d,1,1.1-d,11),1)),d,d+1/(111>>1),ar(a,d*11/111,1,1/(c=1+1),1,1.1/c,d).max,1/c),c,c/11/d)),11111)).sin}

play{a=LFTri;c=Klank.ar(`[[12,4,3,9,10]*2*99],a.ar(5*b=[1,9/8]),b)*d=a.ar(b/8);a.ar(b*2).sum<0*SinOscFB.ar(b*99,d+1/2)+c/2}

play{a=LFTri;CombN.ar(a.ar(Duty.ar(c=[4,2]/(a.ar([4,1])>0*4+4),0,Dseries()%a.ar(c,c,42)+1*99).lag3(0.025).max(0)),2,2,4)/2}

play{Splay.ar(n=(67..71).nthPrime;t=PulseCount.ar(Impulse.ar(n*[3,8]*8));x=(t%8)&(t>>9);(x.atan/32).frac)};

play{Splay.ar(n=7.midicps*[2,4,8];t=PulseCount.ar(Impulse.ar(n*[1,8]*8));x=(t%8)&(t>>9);(x.atan/32).frac)};


a={|f|f=Lag2.kr(f,1);LFPar.ar(f*f+[60,64],0,LFSaw.kr(f,0,-0.5,0.5))}.play;Task({{a.set(\f,{s.avgCPU});0.2.wait}.loop}).start

play{a=LFSaw;sum({|i|AllpassN.ar(RHPF.ar(Saw.ar(a.ar(1/[99,100]).round(1/8)**2*8),2**i*[99,50],0.01),1,i+1/9,9)/9}!8).tanh}

play{c=ar(RHPF,ar(CombN,ar(a=SinOsc,e=(f=[2,2.2])/22)/2*ar(LocalIn,2),2,2,g=2<<2),[22,2]*222,e*2);ar(LocalOut,d=ar(Splay,ar(RLPF,ar(a,2.2**ar(t=ToggleFF,ar(p=LFPulse,2,[2.2,2],e))*22*2.22,ar(t,c-e).lag*g)*ar(p,2,f),g**ar(a,e/2/2)*2222/2,ar(a,e)+2/2pi)+c).tanh);d}

play{ar(Splay,ar(RLPF,ar(a=VarSaw,ar(a,(c=4/4/4)/4,c,c).max*4+44,4,ar(a,[4,4/44,c*4]).abs),44*44,c)*ar(Line,dur:4)+ar(PitchShift,ar(CombC,b=ar(a,f=ar(a,d=c*4/44.4,c,-4.sin,4).max.ceil*44+44,4,ar(a,[44-4,4,44+4]/4.44))/4,c,c*4/f+d),4-c,[4+4+4,4*4,4+4],c,c,c+c))/4}

play{r=ar(Splay,(ar(a=LFTri,{|i|i+3.33+ar(a,3/3333)}!3%3*33*(3/3pi+kr(c=LFPulse,3e-3*3)),3,_+3!3).reduce('*').tanh*[3,333*ar(a,3/3333),33])).sin+ar(a,3*3**[3.3,3]+(ar(a,[3,pi])),3,ar(c,pi)/3*ar(a,3e-3))/3;r+sum({|i|ar(b=PitchShift,r,3/33,3/3+i*3,3/33,3/33)}!3)/3}

play{a=SinOsc;c=VarSaw;Splay ar:perform(a,x=\ar,0,perform(BRF,x,perform(c,x,perform(c,x,perform(a,x,b=(6..1)*2.1)*b,0,7-b/9)>0+(perform(a,x,1/b)>perform(a,x,0.1/b)+1)*[99,198]*b/9,0,perform(c,x,b/48)+1/2),2**perform(c,x,b/24)*488,0.4)*perform(a,x,0.012,b,2pi))/2}

play{a=Blip;b=(1..8);Splay.ar(a.ar(a.ar(3.125,b)+a.ar(b/2.45,b)+1*a.ar(8/b,50)+1*99,a.ar(b/pi,b)+b-a.ar(1/4/b,2,4)).sin/2)}

TempoClock.tempo=1;Pbind(\note,Pwhite(0,Pseg([0,12,0],60,0,inf))+Pseg([0,60],60*60),\dur,0.1,\sustain,10,\amp,1).play

fork{a=Pulse;g=40.geom(1,1.12);g.do{|i|{Resonz.ar(b=a.ar(i+i),[2000,3000].rand*EnvGen.kr(Env.circle(g,1/g)),0.1,1/50)}.play}}

{BPF.ar(GrayNoise.ar(1),LFPulse.kr(0.5,0,0.1,12000,1000),0.3)!2}.play

{Splay.ar(Saw.ar(EnvGen.ar(Env([60,40,43],[0.2,0.2]))*[2,3,4,5,7,9]))*EnvGen.ar(Env.perc)*0.2}.play

play{c=LFCub;t=Dust2.kr(pi);x=TChoose;p=Splay;p.ar([c.ar(x.kr(t,(432..999)),0,0.5).tanh,c.ar()],t)*EnvGen.kr(Env.perc,t,1,0,0.9)!2}

fork{y=[Blip,Saw,Pulse,SinOsc];loop{x=play{z=_.ar(rand(999));z.(y.choose)*z.(y.choose)*z.(y.choose)};(rand(0.1)+0.05).wait;x.free;}}


play{a=LFNoise0;b=1/6;MoogFF.ar(a.ar(999)*Pulse.ar(a.kr(b).range(15,24),a.kr(1))!8,a.kr(0.6).range(55,8e3),LFPar.kr(a.kr(b,8),0,4))}

play{c=0.4;b=LFNoise1;DelayL.ar(FreeVerb.ar(a=Decay.ar(Dust.ar(c!2),c,c)*FBSineL.ar(b.ar(1,1e4,1e4),b.ar(1,8,9),1,1),1,1),1,c,c)+a}

play{c=ar(e=SinOsc,0,pi**ar(SinOscFB,ar(Duty,b=("00".size.."0000000".size).reciprocal,0,Dseq("0 0 00 0 0 000  _0 0 0 00 00 00000+  !".ascii,inf)),ar(e,d=$0.ascii.reciprocal).max*0.cos.sin));ar(LeakDC,ar(Splay,c+ar(PitchShift,c,e=0.cos.cos,b.reciprocal,d,d,b)))*e}//

play{a=VarSaw;ar(LeakDC,ar(LPF,ar(Splay,ar(b=CombN,ar(b,cos(ar(a,[11-1,11<<1,11,11>>1,11+1]**ar(a,11.1,1,1/11,1,1.11111111))*ar(a,d=1/(1..11)/1,d,1/11,ar(a,1.11/d,1,1.1-d,11),1)),d,d+1/(111>>1),ar(a,d*11/111,1,1/(c=1+1),1,1.1/c,d).max,1/c),c,c/11/d)),11111)).sin}//


play{ar(Splay,ar(RLPF,ar(a=VarSaw,ar(a,(c=4/4/4)/4,c,c).max*4+44,4,ar(a,[4,4/44,c*4]).abs),44*44,c)*ar(Line,dur:4)+ar(PitchShift,ar(CombC,b=ar(a,f=ar(a,d=c*4/44.4,c,-4.sin,4).max.ceil*44+44,4,ar(a,[44-4,4,44+4]/4.44))/4,c,c*4/f+d),4-c,[4+4+4,4*4,4+4],c,c,c+c))/4}//

(
play {
    Limiter.ar(
        tanh(
            3 * GVerb.ar(
                HPF.ar(
                    PinkNoise.ar(0.08+LFNoise1.kr(0.3,0.02))+LPF.ar(Dust2.ar(LFNoise1.kr(0.2).range(40,50)),7000),
                    400
                ),
                250,100,0.25,drylevel:0.3
            ) * Line.kr(0,1,10)
        ) + (
            GVerb.ar(
                LPF.ar(
                    10 * HPF.ar(PinkNoise.ar(LFNoise1.kr(3).clip(0,1)*LFNoise1.kr(2).clip(0,1) ** 1.8), 20)
                    ,LFNoise1.kr(1).exprange(100,2500)
                ).tanh,
               270,30,0.7,drylevel:0.5
            ) * Line.kr(0,0.7,30)
        )
    )
};
)
