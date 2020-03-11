(
o = Server.default.options;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
//s.options.memSize = 65536;
o.numOutputBusChannels = 8;
o.numOutputBusChannels;
s.reboot;
)
(
~surroundBus = Bus.audio(s,8);
~reverbBus = Bus.audio(s,8);
o.numOutputBusChannels = ~reverbBus.index+8;
~reverbBus.index;
~surroundBus.index;
)

//0.L
//1.R
//2.C
//3.LFE
//4.LS
//5.RS
//6.LB
//7.RB

(
SynthDef.new(\reverb, {
	arg in, out=0, amp = 0.2;
	var sig, reverbed;
	sig = In.ar(~surroundBus.index,7);
	sig = FreeVerb.ar(sig,0.8,1.0,1.0);
	//4.do({ sig = AllpassC.ar(sig, 0.6, { Rand(0.001,0.6) }, 6)});
	sig = {AllpassN.ar(sig, 0.2, Rand(0.001,0.6), 0.6)}!7;
	//sig = AllpassN.ar(sig, 0.2, {Rand(0.001,0.6)}!7, 0.3);
	//(10.do({ sig = AllpassC.ar(sig, 0.2, { Rand(0.001,0.2) }, 0.3)}!7));

	sig = sig * amp;
	Out.ar(~reverbBus,sig);
}).add;

SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=1.0, remix=0.3, lfemix=0.5;

	Out.ar(2, (sigmix*In.ar(~surroundBus.index, 1))   + (remix*In.ar(~reverbBus.index, 1)));
	Out.ar(1, (sigmix*In.ar(~surroundBus.index+1, 1)) + (remix*In.ar(~reverbBus.index+1, 1)));
	Out.ar(5, (sigmix*In.ar(~surroundBus.index+2, 1)) + (remix*In.ar(~reverbBus.index+2, 1)));
	Out.ar(7, (sigmix*In.ar(~surroundBus.index+3, 1)) + (remix*In.ar(~reverbBus.index+3, 1)));
	Out.ar(6, (sigmix*In.ar(~surroundBus.index+4, 1)) + (remix*In.ar(~reverbBus.index+4, 1)));
	Out.ar(4, (sigmix*In.ar(~surroundBus.index+5, 1)) + (remix*In.ar(~reverbBus.index+5, 1)));
	Out.ar(0, (sigmix*In.ar(~surroundBus.index+6, 1)) + (remix*In.ar(~reverbBus.index+6, 1)));

	Out.ar(3, lfemix*(Mix.new(In.ar(~surroundBus.index, 7))));

}).add;
)

(//Setup

~reroute = Synth.new(\reroute, [\bus,~surroundBus]);

~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus]);

)


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
	sig = PanAz.ar(7, sig, Lag.kr(LFSaw.kr(0.1).poll,1),1,3,0);
	//LFNoise1.kr(1);
	sig = sig * env * amp;

	Out.ar(~surroundBus, sig);

	//Out.ar(3, In.ar(22,7))

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
SynthDef.new("sintest", { var outArray;
    outArray = LFTri.ar(100, 0, 0.2);
    Out.ar(6, outArray); // writes to busses 0 and 1
}).play;
)

(
SynthDef(\panaz,{
	arg out=0;
	var sig;
    sig = PanAz.ar(
        numChans: 7,
        in: LFTri.ar(200, 0, 0.2),
		//in: PinkNoise.ar(0.1),
       // pos: LFSaw.kr(MouseX.kr(0.2, 8, 'exponential')),
		pos: MouseX.kr(0.5, 2),
        level: 0.5,
        width: 3,
        orientation: 0.0
    );
	Out.ar(~surroundBus,sig);
}).play
)


(
var earth = {
	var sig;
	sig = SinOsc.ar(MouseY.kr(100,700), 0, 0.2);
	sig = PanAz.ar(7,sig, MouseX.kr(0.5, 2),0.7,3,0);
	sig = Out.ar(~surroundBus,sig);

}.play;
)

(
SynthDef.new(\panpluck, {
	arg out = 0;
    var n, sig;
    n = 7; // number of 'voices'
    sig = Pan4.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    Array.fill(n, 1),
                    0.3 // amplitude
                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                Array.fill(n, {0.004.rand+0.0003}),
                4 // decay time in seconds
            ),
            Array.fill(n,{1.0.rand2}) // give each voice a different pan position
        );
	Out.ar(~surroundBus, sig);

}).play;
)