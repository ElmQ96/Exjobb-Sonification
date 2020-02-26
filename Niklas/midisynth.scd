s.boot;
s.quit;

(

SynthDef(\coolSynth, { arg
	// Receive values
	note = 42,
	bend = 0,

	detune = 10,
	vibratoAmount = 0, // Between 0 = no vibrato and 127 = max vibrato

	pw = 64, // 64 is 50%

	gate = 0,
	attack = 0,
	decay = 0.5,
	sustain = 0.75,
	release = 0.5,
	level = 1,

	velocity = 0,

	actualCutOffFrequency = 2500,
	resonance = 0.75,
	filterAttack = 0,
	filterDecay = 0.5,
	filterSustain = 0.1,
	filterRelease = 1,

	cutOffFrequencyLFOFrequency = 0.1, // Frequency in Hz

	cutOffFrequencyLFOAmount = 0, // Between 0 = no LFO effect on VCF and 127 = max effect
	velocityCutOffFrequencyAmount = 0, // Between 0 = no effect of velocity on VCF and 127 = max effect
	noteCutOffFrequencyAmount = 0,  // Between 0 = no effect of note on VCF and 127 = max effect
	cutOffFrequencyEnvelopeAmount = 0;  // Between 0 = no effect of envelope on VCF and 127 = max effect

	// The synth modules
	var vibratoLFOFrequency = 5; // Frequency in Hz
	var vibratoLFO = SinOsc.kr(vibratoLFOFrequency).range(1-(vibratoAmount/128), 1+(vibratoAmount/127)).midiratio; // göra om till midiratio


	var oscillator1 = LFSaw.ar(note.midicps * bend.midiratio * vibratoLFO, 0, 1);
	var oscillator2 = LFSaw.ar((note - (detune/100)).midicps * bend.midiratio * vibratoLFO, 0, 1);
	var oscillator3 = LFSaw.ar((note + (detune/100)).midicps * bend.midiratio * vibratoLFO, 0, 1);


	var pwmLFOFrequency = 0.1; // Frequency in Hz
	var pwmAmount = 0; // Between 0 = no pwm and 127 = max pwm
	var pwmLFO = SinOsc.kr(pwmLFOFrequency).range(1-(pwmAmount/128), 1);

	/*var oscillator1 = LFPulse.ar(note.midicps * bend.midiratio * vibratoLFO, 0, (pw/128) * pwmLFO, 1);
	var oscillator2 = LFPulse.ar((note - (detune/100)).midicps * bend.midiratio * vibratoLFO, 0, (pw/128) * pwmLFO, 1);
	var oscillator3 = LFPulse.ar((note + (detune/100)).midicps * bend.midiratio * vibratoLFO, 0, (pw/128) * pwmLFO, 1);*/


	var mixedOscillators = (oscillator1 + oscillator2 + oscillator3);


	var cutOffFrequencyLFO = SinOsc.kr(cutOffFrequencyLFOFrequency).range(1-(cutOffFrequencyLFOAmount/128), 1+(cutOffFrequencyLFOAmount/127));

	var velocityCutOffFrequency = linexp(velocity, 1, 127, 1-(velocityCutOffFrequencyAmount/128), 1+(velocityCutOffFrequencyAmount/127));

	var noteCutOffFrequency = linexp(note, 1, 127, 1-(noteCutOffFrequencyAmount/128), 1+ (noteCutOffFrequencyAmount*8));

	var cutOffFrequencyEnvelope = EnvGen.ar(Env.adsr(filterAttack, filterDecay, filterSustain, filterRelease, 1, -4), gate, levelScale: (cutOffFrequencyEnvelopeAmount/20), levelBias: 1-(cutOffFrequencyEnvelopeAmount/127));


	var cutOffFrequency = (actualCutOffFrequency * cutOffFrequencyLFO * velocityCutOffFrequency * noteCutOffFrequency * cutOffFrequencyEnvelope).prune(0, 15000, \max);


	var filtered = RLPF.ar(mixedOscillators, cutOffFrequency, resonance);


	var envelope = EnvGen.ar(Env.adsr(attack, decay, sustain, release, level, -4), gate, doneAction: 2);

	var envelopedSound = filtered*envelope;


	var output = envelopedSound;

	Out.ar(0, {output * 0.1}!2);
}).add;

)

(
var notes, on, off;
var midiChannel = 0;

var bend, modulation;
var bendValue = 16383/2;
var modulationValue = 0;

var vcfLfoK;
var vcfLfoFrequency = 0.01;

var cutoff, reson;
var cutOffFrequency = 8000;
var resonanceVal = 1;
var fK, rK;
var sfLFO, sfV, sfK, sfE;
var sfA, sfD, sfS, sfR;

var attack, decay, sustain, release;
var attackTime = 0;
var decayTime = 0;
var sustainLevel = 1;
var releaseTime = 0;
var sV, sA, sD, sS, sR;
var velocityEffect = 1;

var vcfAttack, vcfDecay, vcfSustain, vcfRelease;
var vcfAttackTime = 0;
var vcfDecayTime = 0;
var vcfSustainLevel = 1;
var vcfReleaseTime = 0;
var vcfLFOAmount = 0;
var vcfVelAmount = 0;
var vcfNoteAmount = 0;
var vcfEnvelopeAmount = 0;

var windowWidth = Window.screenBounds.right;
var windowHeight = Window.screenBounds.bottom;
var filePath = thisProcess.nowExecutingPath.dirname;



w = Window.new("MIDI Synth", Rect(windowWidth/4,windowHeight/4,1366,768));
w.front;
v=UserView(w, w.view.bounds);
i = Image.open(filePath +/+ "midisynth.png");
v.backgroundImage = i;


vcfLfoK = Knob.new(w, Rect(190,70,50,50));
vcfLfoK.action = {
	vcfLfoFrequency = linexp(vcfLfoK.value, 0, 1, 0.01, 500);
	notes.do{arg synthNumber;
		synthNumber.set(\cutOffFrequencyLFOFrequency, vcfLfoFrequency);
	};
};

fK = Knob.new(w, Rect(410,35,50,50)).value_(1);
fK.action = {
	cutOffFrequency = linexp(fK.value, 0, 1, 75, 8000);
	notes.do{arg synthNumber;
		synthNumber.set(\actualCutOffFrequency, cutOffFrequency);
	};
};
rK = Knob.new(w, Rect(410,140,50,50)).value_(0);
rK.action = {
	resonanceVal = linexp(rK.value, 0, 1, 1, 0.01);
	notes.do{arg synthNumber;
		synthNumber.set(\resonance, resonanceVal);
	};
};

sfLFO = Slider.new(w,Rect(511,35,10,155));
sfLFO.action = {
	vcfLFOAmount = linlin(sfLFO.value, 0, 1, 0, 127);
	notes.do{arg synthNumber;
		synthNumber.set(\cutOffFrequencyLFOAmount, vcfLFOAmount);
	};
};
sfV = Slider.new(w,Rect(554,35,10,155));
sfV.action = {
	vcfVelAmount = linlin(sfV.value, 0, 1, 0, 127);
	notes.do{arg synthNumber;
		synthNumber.set(\velocityCutOffFrequencyAmount, vcfVelAmount);
	};
};
sfK = Slider.new(w,Rect(599,35,10,155));
sfK.action = {
	vcfNoteAmount = linlin(sfK.value, 0, 1, 0, 127);
	notes.do{arg synthNumber;
		synthNumber.set(\noteCutOffFrequencyAmount, vcfNoteAmount);
	};
};
sfE = Slider.new(w,Rect(644,35,10,155));
sfE.action = {
	vcfEnvelopeAmount = linlin(sfE.value, 0, 1, 0, 127);
	notes.do{arg synthNumber;
		synthNumber.set(\cutOffFrequencyEnvelopeAmount, vcfEnvelopeAmount);
	};
};
sfA = Slider.new(w,Rect(680,35,30,155));
sfA.action = {
	vcfAttackTime = linexp(sfA.value, 0, 1, 0.001, 10);
	notes.do{arg synthNumber;
		synthNumber.set(\filterAttack, vcfAttackTime);
	};
};
sfD = Slider.new(w,Rect(741,35,30,155));
sfD.action = {
	vcfDecayTime = linexp(sfD.value, 0, 1, 0.001, 1);
	notes.do{arg synthNumber;
		synthNumber.set(\filterDecay, vcfDecayTime);
	};
};
sfS = Slider.new(w,Rect(804,35,30,155)).value_(1);
sfS.action = {
	vcfSustainLevel = linexp(sfS.value, 0, 1, 0.001, 1);
	notes.do{arg synthNumber;
		synthNumber.set(\filterSustain, vcfSustainLevel);
	};
};
sfR = Slider.new(w,Rect(867,35,30,155));
sfR.action = {
	vcfReleaseTime = linexp(sfR.value, 0, 1, 0.001, 10);
	notes.do{arg synthNumber;
		synthNumber.set(\filterRelease, vcfReleaseTime);
	};
};




sV = Slider.new(w,Rect(968,35,10,155));
sV.action = {
	velocityEffect = 1-sV.value;
};
sA = Slider.new(w,Rect(1002,35,30,155));
sA.action = {
	attackTime = linexp(sA.value, 0, 1, 0.001, 10);
	notes.do{arg synthNumber;
		synthNumber.set(\attack, attackTime);
	};
};
sD = Slider.new(w,Rect(1065,35,30,155));
sD.action = {
	decayTime = linexp(sD.value, 0, 1, 0.001, 10);
	notes.do{arg synthNumber;
		synthNumber.set(\decay, decayTime);
	};
};
sS = Slider.new(w,Rect(1128,35,30,155)).value_(1);
sS.action = {
	sustainLevel = linexp(sS.value, 0, 1, 0.001, 1);
	notes.do{arg synthNumber;
		synthNumber.set(\sustain, sustainLevel);
	};
};
sR = Slider.new(w,Rect(1191,35,30,155));
sR.action = {
	releaseTime = linexp(sR.value, 0, 1, 0.001, 10);
	notes.do{arg synthNumber;
		synthNumber.set(\release, releaseTime);
	};
};



MIDIClient.init;

MIDIIn.connectAll;

notes = Array.newClear(128);

on = MIDIFunc.noteOn({ arg veloc, num, chan, src;
	var level = linlin(veloc, 0, 127, velocityEffect, 1);
	//vcfLfoFrequency.postln;
	notes[num] = Synth.new(\coolSynth, [\note, num, \bend, linlin(bendValue, 0, 16383, -12, 12), \velocity, veloc, \vibratoAmount, modulationValue, \actualCutOffFrequency, cutOffFrequency, \resonance, resonanceVal, \attack, attackTime, \decay, decayTime, \sustain, sustainLevel, \release, releaseTime, \level, level, \filterAttack, vcfAttackTime, \filterDecay, vcfDecayTime, \filterSustain, vcfSustainLevel, \filterRelase, vcfReleaseTime, \cutOffFrequencyLFOAmount, vcfLFOAmount, \velocityCutOffFrequencyAmount, vcfVelAmount, \noteCutOffFrequencyAmount, vcfNoteAmount, \cutOffFrequencyEnvelopeAmount, vcfEnvelopeAmount, \cutOffFrequencyLFOFrequency, vcfLfoFrequency, \gate, 1]);
});

off = MIDIFunc.noteOff({ arg veloc, num, chan, src;
	notes[num].set(\gate, 0);
	notes[num] = nil;
});

bend = MIDIFunc.bend({ arg val, chan, src;
	bendValue = val;
	notes.do{arg synthNumber;
		synthNumber.set(\bend, linlin(bendValue, 0, 16383, -12, 12));
	};
});

modulation = MIDIFunc.cc({ arg val, control, chan, src;
	src.postln;
});

modulation = MIDIFunc.cc({ arg val, control, chan, src;
	modulationValue = val;
	notes.do{arg synthNumber;
		synthNumber.set(\vibratoAmount, val);
	};
},1);




cutoff = MIDIFunc.cc({ arg val, control, chan, src;
	cutOffFrequency = linexp(val, 0, 127, 75, 8000);
	{fK.value = explin(cutOffFrequency,75,8000,0.001,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\actualCutOffFrequency, cutOffFrequency);
	};
},74);

reson = MIDIFunc.cc({ arg val, control, chan, src;
	resonanceVal = linexp(val, 0, 127, 1, 0.01);
	{rK.value = explin(resonanceVal,0.01,1,1,0);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\resonance, resonanceVal);
	};
},71);




attack = MIDIFunc.cc({ arg val, control, chan, src;
	// MIDI standard 73
	attackTime = linexp(val, 0, 127, 0.001, 10);
	{sA.value = explin(attackTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\attack, attackTime);
	};
},77);

decay = MIDIFunc.cc({ arg val, control, chan, src;
	decayTime = linexp(val, 0, 127, 0.001, 10);
	{sD.value = explin(decayTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\decay, decayTime);
	};
},93);

sustain = MIDIFunc.cc({ arg val, control, chan, src;
	// MIDI level standard 11
	sustainLevel = linexp(val, 0, 127, 0.001, 1);
	{sS.value = sustainLevel;}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\sustain, sustainLevel);
	};
},73);

release = MIDIFunc.cc({ arg val, control, chan, src;
	// MIDI standard 72
	releaseTime = linexp(val, 0, 127, 0.001, 10);
	{sR.value = explin(releaseTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\release, releaseTime);
	};
},75);




vcfAttack = MIDIFunc.cc({ arg val, control, chan, src;
	vcfAttackTime = linexp(val, 0, 127, 0.001, 10);
	{sfA.value = explin(vcfAttackTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\filterAttack, vcfAttackTime);
	};
},17);

vcfDecay = MIDIFunc.cc({ arg val, control, chan, src;
	vcfDecayTime = linexp(val, 0, 127, 0.001, 10);
	{sfD.value = explin(vcfDecayTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\filterDecay, vcfDecayTime);
	};
},91);

vcfSustain = MIDIFunc.cc({ arg val, control, chan, src;
	vcfSustainLevel = linexp(val, 0, 127, 0.001, 1);
	{sfS.value = linlin(vcfSustainLevel,0.001,1,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\filterSustain, vcfSustainLevel);
	};
},79);

vcfRelease = MIDIFunc.cc({ arg val, control, chan, src;
	vcfReleaseTime = linexp(val, 0, 127, 0.001, 10);
	{sfR.value = explin(vcfReleaseTime,0.001,10,0,1);}.defer;
	notes.do{arg synthNumber;
		synthNumber.set(\filterRelease, vcfReleaseTime);
	};
},72);

q = { on.free; off.free; bend.free; modulation.free;};

)