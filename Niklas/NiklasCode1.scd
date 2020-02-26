s.boot;
s.quit;

(
SynthDef(\coolSynth, {arg cutOffFrequency=250, resonanceValue = 0.5, bufnum = 0;
	var synth = LFSaw.ar(330, 0, 0.3);
	var noise = WhiteNoise.ar(0.3);//PinkNoise, BrownNoise
	var music = PlayBuf.ar(2, bufnum: bufnum, rate: 1, trigger: 0, startPos: 0, loop: 0, doneAction: 2);

	var filtered = LPF.ar(synth, cutOffFrequency);
	//var filtered = HPF.ar(synth, cutOffFrequency);
	//var filtered = BPF.ar(synth, cutOffFrequency, 0.5);
	//var filtered = BRF.ar(synth, cutOffFrequency, 0.5);

	//var filtered = RLPF.ar(synth, cutOffFrequency, resonanceValue);
	//var filtered = RHPF.ar(synth, cutOffFrequency, resonanceValue);
	//var filtered = BPF.ar(synth, cutOffFrequency, resonanceValue);
	//var filtered = BRF.ar(synth, cutOffFrequency, resonanceValue);

	//var filtered = MoogFF.ar(synth, cutOffFrequency, (resonanceValue*4));

	Out.ar(0, filtered);
}).add;


SynthDef(\sendMouse, {
	SendReply.kr(Impulse.kr(60), '/mousePosition', [MouseX.kr(0,Window.screenBounds.right), MouseY.kr(0,Window.screenBounds.bottom), MouseButton.kr.round], 2323)
}).add;

)

(

var coolSynth = Synth.new(\coolSynth).register;

var filePath = thisProcess.nowExecutingPath.dirname;

var soundFileBuffer = Buffer.read(s,filePath +/+ "music.wav");

FreqScope.new(400, 200, 0, server: s);

Synth.new(\sendMouse);

o = OSCFunc({ arg msg, time, addr, recvPort;

	var insideImage;
	var previousImageNumber;

	var xPos = msg[3].round;
	var yPos = msg[4].round;

	yPos = yPos.linexp(0,800,40,20000);
	xPos = xPos.linlin(0,1280,0.01,1);

	coolSynth.set(\cutOffFrequency, yPos, \resonanceValue, xPos, \bufnum, soundFileBuffer.bufnum);
}, '/mousePosition');

s.scope;

)