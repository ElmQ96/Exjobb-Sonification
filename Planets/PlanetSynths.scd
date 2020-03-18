(
o = Server.default.options;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
//o.outDevice_("ASIO : Focusrite(USB Audio)");
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

(
~panlagTime = 1;
~poslagTime = 1;

SynthDef.new(\reverb, {
	arg in, out=0, amp = 0.4;
	var sig, reverbed;
	sig = In.ar(~surroundBus.index,7);
	sig = FreeVerb.ar(sig,0.8,1.0,1.0);
	sig = {AllpassN.ar(sig, 0.2, Rand(0.001,0.6), 0.3)}!7;
	sig = sig * amp;
	Out.ar(~reverbBus,sig);
}).add;

SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=1.0, remix=0.0, lfemix=0.5;
	Out.ar(2, (sigmix*In.ar(~surroundBus.index, 1))   + (remix*In.ar(~reverbBus.index, 1)));
	Out.ar(1, (sigmix*In.ar(~surroundBus.index+1, 1)) + (remix*In.ar(~reverbBus.index+1, 1)));
	Out.ar(5, (sigmix*In.ar(~surroundBus.index+2, 1)) + (remix*In.ar(~reverbBus.index+2, 1)));
	Out.ar(7, (sigmix*In.ar(~surroundBus.index+3, 1)) + (remix*In.ar(~reverbBus.index+3, 1)));
	Out.ar(6, (sigmix*In.ar(~surroundBus.index+4, 1)) + (remix*In.ar(~reverbBus.index+4, 1)));
	Out.ar(4, (sigmix*In.ar(~surroundBus.index+5, 1)) + (remix*In.ar(~reverbBus.index+5, 1)));
	Out.ar(0, (sigmix*In.ar(~surroundBus.index+6, 1)) + (remix*In.ar(~reverbBus.index+6, 1)));
	Out.ar(3, lfemix*(Mix.new(In.ar(~surroundBus.index, 7))));
}).add;

SynthDef(\surroundmod, {
	arg freq=200, rate=1, pan=0, lagpan=0, gate=0, reverb=0.5, amp=0.3, amp2=1.0;
	var sig, sig2, resfreq, env, reverbed,  lfo, input, snd;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);
	sig = LFSaw.ar(freq);
	sig2 = SinOsc.ar(freq/2,0,0.2);
	resfreq = SinOsc.kr(rate) * 200 + 400;
	sig = RLPF.ar(sig, resfreq,0.5);
	//sig = FreeVerb.ar(sig, reverb, 0.5, 0.8);
	sig = (sig + sig2)/2;
	/*if(~lagSwitch==1,
		{lagpan = Lag.kr(pan,~panlagTime)},
		{lagpan = pan});*/

	/*lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, freq*2, 20000/8);
	BRF.ar(sig, lfo, 1);*/
	/*snd = BAllPass.ar(sig, [1, 2, 4, 8] * lfo, 0.5);
	snd = Mix.ar(snd);
	snd = snd + (sig * -1 * 3);
	sig = Mix.ar(snd);*/


	//sig = sig + snd;
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef("poof", {
	arg freq=400, rate=1, pan=0, out=0, amp=0.5, amp2=1.0, gate=0;
	var sig,sig2, env, env2, t_gate=0,oscillator1, oscillator2;
	t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		t_gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = PinkNoise.ar(1);
	sig2 = (BPF.ar(sig, freq/2, 0.01) * 40);
	sig = (BPF.ar(sig, freq*2, 0.01) * 40);

	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
	//sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	sig2 = PanAz.ar(7, sig2, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	//sig2 = SinOsc.ar(freq/2,0,0.2);
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef("percpoof", {
	arg freq=400, rate=1, pan=0, out=0, amp=0.4, amp2=1.0, gate=0;
	var sig, env, t_gate=0;
	t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		//Env.adsr(0.05,0.5,0.3,0.5),
		Env.perc(0.01,1.0),
		t_gate,
		doneAction:0);
	sig = PinkNoise.ar(1);
	sig = (BPF.ar(sig, freq*2, 0.01) * 40); //+ (BPF.ar(sig, freq*, 0.01) *5);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),0.2,3,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\wind, {
	arg amp=0.1, amp2=1.0, rate=0.45, gate, pan=0;
	var sig, env, lfo;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);
	sig = PinkNoise.ar(amp);
	sig = LPF.ar(sig, Vibrato.kr(1000,rate,rate,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,rate,rate,rateVariation:0.7,depthVariation:0.3));
	//sig = sig * LPF.ar(sig, Vibrato.kr(1500,0.45,0.40,rateVariation:0.7,depthVariation:0.3));
	sig = HPF.ar(sig, 100);
	/*lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, 100, 20000/8);
	sig = BRF.ar(sig, lfo, 1);*/
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\gravity, {
	arg amp=0.8, amp2=1.0, freq=200, gravity=1, gate=0, rate, pan=0, out=0;
    var t, sf, env, sig, t_gate, lfo;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);
	//sf = K2A.ar(LFPulse.kr(0.5).poll > 0.5) > 0;
	sf = LFPulse.ar(rate,0.9999);
    t = TBall.ar(sf, gravity,0,0.01);
    sig = Ringz.ar(t * 5, freq, 0.5);
	lfo = LinExp.ar(LFTri.ar(0.1), -1, 1, 100, 20000/8);
	sig = BRF.ar(sig, lfo, 1);
	//sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1.0,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\fry, {
	arg amp=0.5, amp2=1.0, freq=440, filt=440, rate=1, lowtemp=20, hightemp=200, gate, pan=0;
	var sig, env, newrate;
	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);
	newrate = SinOsc.kr(rate).range(lowtemp,hightemp);
	sig = Dust.ar(newrate, 0.4); //rate: 5-1000
	sig = LPF.ar(sig,2000);
	sig = PanAz.ar(7, sig, Lag.kr(pan,~panlagTime),1,2.5,0);
	amp2 = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * amp2;
	Out.ar(~surroundBus, sig);
}).add;
)
SynthDef("beating", {
	arg freq = 440, amp = 0.1, out = 0, pan = 0, att = 0.01, dec = 1, curve = -4, beatFreq = 15, rate, gate;

	var env, snd, oscillator1, oscillator2, t_gate;

		t_gate = gate * LFPulse.ar(rate);
	env = EnvGen.kr(
		Env.adsr(0.01,0.5,0.3,0.5),
		t_gate,
		doneAction:0);

	oscillator1 = SinOsc.ar(freq); //Try other waveforms for the oscillators! Mix and match, collect them all!
	oscillator2 = SinOsc.ar(Line.kr(freq + beatFreq, freq, dec));

	snd = Mix([oscillator1, oscillator2]);
	snd = snd * env;

	Out.ar(out, Pan2.ar(snd, pan));

}
).add

SynthDef(\FMRhodes2, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1,
	//controls
	lfoSpeed = 2.4, inputLevel = 0.2, modIndex = 2, fmHarmonic = 30,
    // all of these range from 0 to 1
    mix = 0.2, lfoDepth = 0.75, lfoBottom = 0.15, lfoRange = 0.3;

    var env1, env2, env3, env4, range, bottom;
    var osc1, osc2, osc3, osc4, snd;

	bottom = lfoBottom.linlin(0, 1, 100, 12000);
	range = lfoRange.linlin(0, 1, bottom, 16000);

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * fmHarmonic) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;

    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = LPF.ar(snd, SinOsc.kr(lfoSpeed).range(bottom, range), lfoDepth) + (snd * (1 - lfoDepth));
    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
}).add;


SynthDef(\kalimba, {
	arg
	// Standard values
	out = 0, freq = 440, amp = 0.1, att = 0.001, pan = 0,
	// Mix control goes from 0 to 1
	mix = 0.1,
	// Release controls for different parts of the sound
	minRel = 2.5, maxRel = 3.5, clickRel = 0.01;

	var note, env, body, snd;

	env = Env.perc(att * 3, Rand(minRel, maxRel), 1, -8).kr(doneAction: 2);
	note = SinOsc.ar(freq) * env;
	body = DynKlank.ar(
		specificationsArrayRef:
		Ref.new([
			[240 * ExpRand(0.9, 1.1), 2020 * ExpRand(0.9, 1.1), 3151 * ExpRand(0.9, 1.1)],
			[-7, 0, 3].dbamp, // same as 10.pow([-7, 0, 3] / 20),
			[0.75, 0.04, 0.06] + clickRel
		]),
		input:
		// Try BrownNoise, GrayNoise, etc. here, but you may need to change ring times above
		(PinkNoise.ar * Env.perc(att, clickRel).kr)
	);
	snd = (note * (1 - mix)) + (body * mix) * amp;

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Nathan Ho aka Snappizz",
	category: \bells,
	tags: [\pitched, \kalimba]
)
).add;

SynthDef("phazer", {
    arg
	//Standard Values
	out = 0, pan = 0, freq = 440, amp = 0.5, gate = 1,
	att = 1, dec = 3, sus = 0, rel = 1.5, crv = -4,
    //Other controls
    rq = 0.5, rate = 1, minfreq = 100, maxfreq = 16000,
	drylevel = 1.5, fmdepth = 1.5, fmfreq = 432;

	var env, lfo, input, snd;

	env = Env.adsr(
		    attackTime: att,
	    	decayTime: dec,
    		sustainLevel: sus,
		    releaseTime: rel,
	    	curve: crv
	    ).ar(doneAction: 2);

	//Controls the all pass freq; try an envelope here as well!
	lfo = LinExp.ar(LFTri.ar(rate), -1, 1, minfreq, maxfreq/8);
	//lfo = LinExp.ar(env, 0, 1, minfreq, maxfreq/8);

	//The input sound (Dense frequency content is better)
	input = LFSaw.ar(freq: SinOsc.ar(fmfreq).range(1, fmdepth) * freq, mul: env * amp);

	//All pass filter + dry sound = P H A Z E R
	snd = BAllPass.ar(input, [1, 2, 4, 8] * lfo, rq);
	snd = Mix.ar(snd);
	snd = snd + (input * -1 * drylevel);
	snd = Mix.ar(snd);

    Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Josh Mitchell",
	category: \misc,
	tags: [\pitched, \effects]
	)
).add;

(
SynthDef("sawSynth", { arg freq = 440, amp = 0.1, att = 0.1, rel = 2, lofreq = 1000, hifreq = 3000;
    var env, snd;
    env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp
	).kr(doneAction: 2);
    snd = Saw.ar(freq: freq * [0.99, 1, 1.001, 1.008], mul: env);
	snd = LPF.ar(
		in: snd,
		freq: LFNoise2.kr(1).range(lofreq, hifreq)
	);
    snd = Splay.ar(snd);
    Out.ar(0, snd);
// Basic saw synth for chords and bass
//By Bruno Ruviaro
//http://sccode.org/1-54H
}).add;
)





SynthDef("phazer", {
    arg
	//Standard Values
	out = 0, pan = 0, freq = 440, amp = 0.5, gate = 1,
	att = 1, dec = 3, sus = 0, rel = 1.5, crv = -4,
    //Other controls
    rq = 0.5, rate = 1, minfreq = 100, maxfreq = 16000,
	drylevel = 1.5, fmdepth = 1.5, fmfreq = 432;

	var env, lfo, input, snd;
	lfo = LinExp.ar(LFTri.ar(1), -1, 1, 100, 16000/8);
	snd = BAllPass.ar(input, [1, 2, 4, 8] * lfo, 0.5);
	snd = Mix.ar(snd);
	snd = snd + (input * -1 * 1.5);
	snd = Mix.ar(snd);
	//Controls the all pass freq; try an envelope here as well!

	//lfo = LinExp.ar(env, 0, 1, minfreq, maxfreq/8);

	//The input sound (Dense frequency content is better)

	//All pass filter + dry sound = P H A Z E R


    Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Josh Mitchell",
	category: \misc,
	tags: [\pitched, \effects]
	)
).add;


{ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 }.play;

(
{
loop({
	{
		Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
			* EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
	}.play;
	2.wait;
})
}.fork;
)

{ LFDNoise0.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;

{ LFClipNoise.ar(XLine.kr(1000, 20000, 10), 0.1) }.freqscope.scope;

{ SinOsc.ar(LFTri.kr(4, 0, 200, 400), 0, 0.7) }.play

SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;
	var x, y, env;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(Impulse.ar(0, 0, rand), 0.1+rand, WhiteNoise.ar);
 	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));
	x = Pan2.ar(x, pan);
	Out.ar(0, LeakDC.ar(x));
}).store;

// and play the synthdef
(
{
	20.do({
		Synth(\ks_guitar, [\note, 220+(400.rand),
					\pan, 1.0.rand2,
					\rand, 0.1+0.1.rand,
					\delayTime, 2+1.0.rand]);

	   (1.0.rand + 0.5).wait;
	});
}.fork
)

{ Decay.ar(Impulse.ar(XLine.kr(1,50,20), 0.25), 0.2, FSinOsc.ar(600), 0)  }.play;

(
SynthDef(\flanger, { arg out=0, in=0, delay=0.1, depth=0.08, rate=0.06, fdbk=0.0, decay=0.0;

	var input, maxdelay, maxrate, dsig, mixed, local;
	maxdelay = 0.013;
	maxrate = 10.0;
	input = In.ar(in, 1);
	local = LocalIn.ar(1);
	dsig = AllpassL.ar( // the delay (you could use AllpassC (put 0 in decay))
		input + (local * fdbk),
		maxdelay * 2,
		LFPar.kr( // very similar to SinOsc (try to replace it) - Even use LFTri
			rate * maxrate,
			0,
			depth * maxdelay,
			delay * maxdelay),
		decay);
	mixed = input + dsig;
	LocalOut.ar(mixed);
	Out.ar([out, out+1], mixed);
}).load(s);
)

SynthDef(\reverb, {arg inbus=0, outbus=0, predelay=0.048, combdecay=15, allpassdecay=1, revVol=0.31;
	var sig, y, z;
	sig = In.ar(inbus, 1);

	// predelay
	z = DelayN.ar(sig, 0.1, predelay); // max 100 ms predelay

	// 7 length modulated comb delays in parallel :
	y = Mix.ar(Array.fill(7,{ CombL.ar(z, 0.05, rrand(0.03, 0.05), combdecay) }));

	6.do({ y = AllpassN.ar(y, 0.050, rrand(0.03, 0.05), allpassdecay) });
	Out.ar(outbus, sig + (y * revVol) ! 2); // as fxlevel is 1 then I lower the vol a bit
}).load(s);




