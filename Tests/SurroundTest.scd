s.boot;
//surround, PanAz is surround in a circle
s.options.numOutputBusChannels_(8);
s.options.numOutputBusChannels;
s.reboot;
s.meter;
s.plotTree;

s.options.num

(
SynthDef(\bpfsaw,{
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=700, detune=0.2, pan=0,
	cfmin=200, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin,cfmax),
		LFNoise1.kr(0.1).exprange(rqmin,rqmax)
	);
	sig = PanAz.ar(8, sig, LFSaw.kr(0.5));
	LFNoise1.kr(1);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do{Synth(
		\bpfsaw,
		[
			\freq, 20,
			\amp,1.0,
			\detune, 1,
			\cfmin, 20*40,
			\cfmax, 20*50,
			\pan, 0.25,
		],
	);
};
)

(
SynthDef.new(\pulseTest, {
	arg  ampHz=3, fund=40, maxPartial=4, width=0.5;
	var amp1,amp2,freq1,freq2,sig1,sig2;
	amp1 = LFNoise0.kr(ampHz, 0, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund,fund*maxPartial).round(fund);
	//freq1 = freq1 * LFPulse.kr(8, 0);
	sig1 = Pulse.ar(freq1,width,amp1);
	//sig1 = FreeVerb.ar(sig1, 0.4, 0.8, 0.25);
	sig1 = PanAz.ar(8, sig1, LFSaw.kr(0.1));
	Out.ar(0,sig1);
}).play
)

x = Synth.new(\pulseTest);

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

