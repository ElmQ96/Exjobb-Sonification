//UGens to check out:
SinOsc
Pulse
LFPulse
Saw
LFSaw
WhiteNoise
PinkNoise
Line
XLine
EnvGen

//Airy poof
(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.new([0,1,0],[0.01,1],[0,-4]),
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 400, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play
)

//Gated air
(
x = {
	arg gate=0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(1.0,0.8,1.0,1),
		gate,
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play;
)
x.set(\gate, 1)
x.set(\gate, 0)

//Triggerad air
(
x = {
	arg t_gate=0;
	var sig, env;
	env = EnvGen.kr(
		Env.perc,
		t_gate,
		doneAction:0
	);
	sig = PinkNoise.ar(1);
	sig = BPF.ar(sig, 800, 0.02) * 10;
	sig = sig * env;
	sig!2;
}.play;
)
x.set(\t_gate, 1)

//Mouse radar
(
x = {
	arg freq = 200;
	var sig;
	sig = SinOsc.ar(freq, 0, 0.2);
	sig = sig + SinOsc.ar(MouseX.kr(freq, freq + 200).poll, 0, 0.2);
	//sig = sig * SinOsc.kr(2).range(0,1);
	sig = sig!2;
}.play;
)

//Mouse Pulse ElmQ
(
x = {
	arg freq = 200, phase = 0;
	var sig;
	sig = Pulse.ar(freq, phase, 0.2);
	sig = sig + Pulse.ar(MouseX.kr(freq, freq + 200).poll, MouseY.kr(phase,phase+1).poll, 0.2);
	//sig = sig * Pulse.kr(2).range(0,1);
	sig = sig!2;
}.play;
)

//Mouse Saw ElmQ
(
x = {
	arg freq = 200, phase = 0;
	var sig;
	sig = Saw.ar(freq, phase, 0.2);
	sig = sig + Saw.ar(MouseX.kr(freq, freq + 200).poll, MouseY.kr(phase,phase+1).poll, 0.2);
	//sig = sig * Saw.kr(2).range(0,1);
	sig = sig!2;
}.play;
)

//Lo-fi Synth sweep
(
{
	var sig, freq, env;
	freq = {
		exprand(50,5000)
	}!64;
	env = EnvGen.kr(
		Env.new([0,1,0],[2,2],[2,-2]),
		doneAction:2
	);
	sig = SinOsc.ar(freq) * 0.1;
	sig = Splay.ar(sig) * env;
}.play
)

//Saw
(
x = {
	arg freq=400;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * 0.2;
	sig = Splay.ar(sig).sum;
}.play;
)
x.set(\freq, 160);

//Saw chord
(
SynthDef.new(\sawtone, {
	arg freq=400, amp=0.2;
	var sig, freqCtrl;
	freqCtrl = freq * LFNoise1.kr(2!8).range(-0.25,0.25).midiratio;
	sig = VarSaw.ar(freqCtrl) * amp;
	sig = Splay.ar(sig).sum;
	Out.ar(0, sig);
}).add;
)
(
x = [49,56,60,65].do({
	arg note, index;
	Synth.new(\sawtone, [\freq, note.midicps]);
})
)

//MouseWind
//low-pass filter with mouse-controlled cutoff frequency
(
{
	var sig;
	sig = PinkNoise.ar(0.25!2);
	sig = LPF.ar(sig, abs(MouseX.kr(30,18000,0)).poll);
}.play;
)

//see also HPF, BPF, BRF


//Mouse ScaryWind
//bandpass filter with center freq = 1 kHz and mouse-controlled rq, also using some rq math for BPF mul argument to compensate for lost amplitude
(
{
	var sig, rq;
	rq = MouseX.kr(0.001,1,1);
	sig = PinkNoise.ar(0.5!2);
	//sig = Saw.ar([60,61], 0.2);
	sig = BPF.ar(
		sig,
		1000,
		rq,
		1/rq.sqrt,
	);
}.play;
)

//Mouse Saw
//lowpass filter with mouse-controlled cutoff freq, sawtooth source
(
{
	var sig, rq;
	rq = MouseX.kr(0.001,1,1);
	//sig = PinkNoise.ar(0.5!2);
	sig = Saw.ar([60,61], 0.2);
	sig = LPF.ar(
		sig,
		MouseX.kr(20,20000,1),
	);
}.play;
)

//Reverbed ekolod
(
SynthDef.new(\source, {
	arg freq = 400, amp=0.5, env_rate=0.7, out=0;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(
		Env.perc(releaseTime:0.2),
		LFSaw.kr(env_rate)
	);
	sig = sig * env * amp;
	Out.ar(out, sig); //out to an arbitrary destination
}).add;
SynthDef.new(\reverb, {
	arg in=0, out=0;
	var sig;
	sig = In.ar(in, 2); //the source is stereo (line 64 has !2), so specify 2 channels
	sig = sig + (GVerb.ar(sig, 200, 5) * 0.2); //apply reverb by summing dry + wet
	Out.ar(out, sig); //out to arbitrary bus
}).add;
)
Synth.new(\reverb, [\in, 57, \out, 0]);
(
~source = Synth.new(\source, [
		\freq, exprand(200,2000),
		\amp, exprand(0.1,0.2),
		\env_rate, exprand(0.7,1),
		\out, 57
	]);
)



