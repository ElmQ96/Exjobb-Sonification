// Get the default server's options

o.numOutputBusChannels.postln;
o.numInputBusChannels

(
o = Server.default.options;

//o.numOutputBusChannels = 50; // The next time it boots, this will take effect


o.inDevice_("MME : In 1-24 (MOTU Pro Audio)");
o.outDevice_("ASIO : FL Studio ASIO");
//o.outDevice_("MME : Högtalare (Razer Surround Audio)");
//o.device = nil;            // use the system default soundcard

~surround = Bus.audio(s,8);
o.numOutputBusChannels = ~surround.index+8;
~surround.free;

Server.default.boot;
)

//Panning creature
(
SynthDef(\bpfsaw,{
	arg atk=0, sus=20, rel=3, c1=1, c2=(-1),
	freq=20, detune=0.2, pan=0,
	cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin,cfmax),
		LFNoise1.kr(0.1).exprange(rqmin,rqmax)
	);
	sig = PanAz.ar(7, sig, LFSaw.kr(0.3),1,3,0);
	//LFNoise1.kr(1);
	sig = sig * env * amp;

	Out.ar(~surroundBus, sig);

	Out.ar(2, In.ar(~surroundBus.index, 1));
	Out.ar(1, In.ar(~surroundBus.index+1, 1));
	Out.ar(5, In.ar(~surroundBus.index+2, 1));
	Out.ar(7, In.ar(~surroundBus.index+3, 1));
	Out.ar(6, In.ar(~surroundBus.index+4, 1));
	Out.ar(4, In.ar(~surroundBus.index+5, 1));
	Out.ar(0, In.ar(~surroundBus.index+6, 1));

	//Out.ar(3, In.ar(22,7))

//0.L
//1.R
//2.C
//3.LFE
//4.LS
//5.RS
//6.LB
//7.RB


}).play;
)
(
3.do{Synth(
		\bpfsaw,
		[
			\freq, 100,
			\amp,0.3,
			\detune, 1,
			\cfmin, 20*40,
			\cfmax, 20*50,
			\pan, 0.25,
		],
	);
};
)

(
SynthDef(\sin,{
	arg amp = 0.2, out=0;
	var sig;
	sig = SinOsc(100);
	sig = PanAz.ar(8, sig, LFSaw.kr(1.0));
	//LFNoise1.kr(1);
	sig = sig * amp;
	Out.ar(out, sig);
}).play;
)

(
{

        LFTri.ar([0,0,0,300,0,0,0,0],0,0.1) // 4 becomes 2

}.play
)

//0.L
//1.R
//2.C
//3.LFE
//4.LS
//5.RS
//6.LB
//7.RB

// start the effect
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play;
// start the source
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;



(
SynthDef.new("sintest", { var outArray;
    outArray = LFTri.ar(400, 0, 0.2);
    Out.ar(4, outArray); // writes to busses 0 and 1
}).play;
)


(
SynthDef.new(\source, {
	arg freq = 300, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(0, sig); //out to an arbitrary destination
}).play;
)

(
{
    var w, x, y, p, q, a, b, c, d;

    p = WhiteNoise.ar(0.05); // source
    q = LFSaw.ar(200,0,0.03)+LFSaw.ar(200.37,0,0.03)+LFSaw.ar(201,0,0.03);

    // B-format encode 2 signals at opposite sides of the circle
    #w, x, y = PanB2.ar(p, -0.5) + PanB2.ar(q, 0.5);

    #x, y = Rotate2.ar(x, y, MouseX.kr(-1,1));

    // B-format decode to quad
    #a, b, c, d = DecodeB2.ar(7, w, x, y);

    [a, b, d, c] // reorder to my speaker arrangement: Lf Rf Lr Rr
}.play;
)

(
{
    PanAz.ar(
        numChans: 8,
        in: PinkNoise.ar(0.1),
        pos: LFSaw.kr(MouseX.kr(0.2, 8, 'exponential')),
        level: 0.5,
        width: 3,
        orientation: 0.5
    );
}.play
)

(

b=Bus.audio(s, 2);
a={SinOsc.ar([330,440], 0, 0.4)}.play(s, b) //you won't hear this if you only have two channels
b.scope
)

{SinOsc.ar(freq: MouseX.kr(300, 2500), mul: MouseY.kr(0, 1))}.play;

// start the effect
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play;
// start the source
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;


~surround = Bus.audio(s,8);
~surround.server
~surround.index
//0.L
//1.R
//2.C
//3.LFE
//4.LS
//5.RS
//6.LB
//7.RB
(
var rs,rb,lb,ls;
 c = {Out.ar(2, In.ar(16, 1))}.play;
 r = {Out.ar(1, In.ar(17, 1))}.play;
 rs = {Out.ar(5, In.ar(18, 1))}.play;
 rb = {Out.ar(7, In.ar(19, 1))}.play;
 lb = {Out.ar(6, In.ar(20, 1))}.play;
 ls = {Out.ar(4, In.ar(21, 1))}.play;
 l = {Out.ar(0, In.ar(22, 1))}.play;
)

(
// Create the bus
~myBus = Bus.audio(s, 8);
// Turn on the reverb: read from myBus (source sound)
r = {Out.ar(0, In.ar(~myBus, 8))}.play;
// Feed the busy tone into ~myBus
b = {Out.ar(~myBus, SinOsc.ar([800,700,600,500], mul: LFPulse.ar(2)))}.play;
// Free both synths
r.free; b.free;
)