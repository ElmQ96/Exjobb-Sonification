s.boot;
s.quit;

(
SynthDef(\coolSynth, {arg frequency = 330, mix = 0.5, carPartial = 1, modPartial = 1;
	// Simple waveforms
	var sine = SinOsc.ar(frequency, 0, 0.3);
	var tri = LFTri.ar(frequency, 0, 0.3);
	var sqr = LFPulse.ar(frequency, 0, 0.5, 0.6, -0.3);
	var saw = LFSaw.ar(frequency, 0, 0.3);

	// Pulse wave with sinusodial control of the pulsewidth
	var pulseWidthMod = SinOsc.kr(0.1).range(0.01, 0.99);
	var pulse = LFPulse.ar(frequency, 0, pulseWidthMod, 0.3);

	// Mix of wave forms
	var sine2 = SinOsc.ar(frequency, 0, 0.3);
	var mixWave = (sqr*(1-mix))+(sine2*mix);

	// Suboctave oscillator
	var subTone = LFPulse.ar(frequency/2, 0, 0.5, 0.3);
	var sub = saw + (subTone*mix);

	// Distorsion
	var dist = sine.clip(mix.linexp(0,1,-0.4,-0.05),mix.linexp(0,1,0.4,0.05))*mix.linexp(0,1,1,6);

	// Ring modulation with a sine wave
	var sine3 = SinOsc.ar(frequency*1.5, 0, 0.3);
	var ringmod = sine*sine3;

	// FM with 1 or 2 modulators
	var modulator = SinOsc.ar(frequency * 2, 0, (frequency*5)*mix);
	var modulator2 = SinOsc.ar((frequency * 3)+modulator, 0, (frequency*5)*mix);
	var operator = SinOsc.ar((frequency + modulator2), 0, 0.3);

	Out.ar(0, sine);
}).add;


SynthDef(\sendMouse, {
	SendReply.kr(Impulse.kr(60), '/mousePosition', [MouseX.kr(0,Window.screenBounds.right), MouseY.kr(0,Window.screenBounds.bottom), MouseButton.kr.round], 2323)
}).add;

)

(

var coolSynth = Synth.new(\coolSynth).register;

var filePath = thisProcess.nowExecutingPath.dirname;

FreqScope.new(400, 200, 0, server: s);

Synth.new(\sendMouse);

o = OSCFunc({ arg msg, time, addr, recvPort;

	var insideImage;
	var previousImageNumber;

	var xPos = msg[3].round;
	var yPos = msg[4].round;

	yPos = yPos.linexp(0,800,110,3520);
	xPos = xPos.linlin(0,1280,0,1);

	coolSynth.set(\frequency, yPos, \mix, xPos);
}, '/mousePosition');

s.scope;

)