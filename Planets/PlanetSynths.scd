(
o = Server.default.options;
o.outDevice_("MME : Högtalare (Razer Surround Audio)");
//o.outDevice_("ASIO : Focusrite USB ASIO");
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
~autOrbitP = 0;
~autOrbitM = 0;
~panlagTime = 0.1;
~poslagTime = 0.1;

SynthDef.new(\reverb, {
	arg in, out=0, amp = 0.25;
	var sig, reverbed;

	sig = In.ar(in,7);
	sig = FreeVerb.ar(sig,0.8,1.0,1.0);
	sig = {AllpassN.ar(sig, 0.2, Rand(0.001,0.6), 0.3)}!7;
	sig = sig * amp;
	Out.ar(out,sig);
}).add;

SynthDef.new(\reroute, {
	arg sigbus, rebus, sigmix=1.0, remix=0.2, lfemix=0.3;
	Out.ar(2, (sigmix*In.ar(sigbus, 1))   + (remix*In.ar(rebus, 1)));   //C
	Out.ar(1, (sigmix*In.ar(sigbus+1, 1)) + (remix*In.ar(rebus+1, 1))); //R
	Out.ar(5, (sigmix*In.ar(sigbus+2, 1)) + (remix*In.ar(rebus+2, 1))); //RS
	Out.ar(7, (sigmix*In.ar(sigbus+3, 1)) + (remix*In.ar(rebus+3, 1))); //RB
	Out.ar(6, (sigmix*In.ar(sigbus+4, 1)) + (remix*In.ar(rebus+4, 1))); //LB
	Out.ar(4, (sigmix*In.ar(sigbus+5, 1)) + (remix*In.ar(rebus+5, 1))); //LS
	Out.ar(0, (sigmix*In.ar(sigbus+6, 1)) + (remix*In.ar(rebus+6, 1))); //L
	Out.ar(3, lfemix*(Mix(In.ar(sigbus, 7)))); //LFE
}).add;

SynthDef(\surroundmod, {
	arg gate=0, amp=0.3, amp2=1.0, freq=200, rate=1, time=1, pan=0, type=0, isMagnetic=0;
	var sig, sig2, globalAmp, env, resfreq, lfo;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	//Select signal depending on planet type
	sig = Select.ar(type,[
			LFSaw.ar(Vibrato.kr(freq,rate*time,0.004)),
			LFPulse.ar(Vibrato.kr(freq,rate*time,0.004),0,0.4)]);

	//Sustained base tone
	sig2 = SinOsc.ar(freq/2,0,0.2);

	//Sweeping resonant low-pass filter for length of day
	resfreq = SinOsc.kr(rate*time) * 200 + 400;
	//resfreq = Vibrato.kr(freq*2,rate*time,0.6,0,0,0,0);
	sig = RLPF.ar(sig, resfreq,0.5);

	//Phaser sweep if planet has a magnetic field
	lfo = LinLin.ar(Vibrato.ar(0.4,0.04,1.0,0,0,0.2,0.2), 0, 1, 600, 5000);
	sig = Select.ar(isMagnetic,
		[sig, sig + HPF.ar(BPF.ar(sig, lfo, 0.1)*2,freq*3)]);

	sig = (sig + sig2)/2;

	//VBAP setup
	/*a = VBAPSpeakerArray.new(2, [0, 45, 90, 135, -135, -90, -45]);
	a.speakers[1].dump;
	b = a.loadToBuffer;
	VBAP.ar(7, sig, b.bufnum, CircleRamp.kr(pan,~panlagTime,-1,1),0,20);
	if(~autOrbitP == 1,
		{sig = VBAP.ar(7, sig, b.bufnum, LFSaw.kr(pan).range(-180,180),1,20);},
		{sig = VBAP.ar(7, sig, b.bufnum, CircleRamp.kr(pan,~panlagTime,-1,1),1,20);});*/

	//PanAz
	if(~autOrbitP == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan)+SinOsc.kr(rate*time,pi/2).range(-0.01,0.01),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1)+SinOsc.kr(rate*time,pi/2).range(-0.01,0.01),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\gravity, {
	arg gate=0, amp=0.4, amp2=1.0, freq=200, rate=1, pan=0, gravity=1, type=0;
    var sig, globalAmp, env, b, sf, gFreq;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	gFreq = Select.kr(type,[
			freq;,
			freq*2;]);

	//Physical model of a ball
	sf = LFPulse.ar(rate,0.0);
    b = TBall.ar(sf, gravity,0.01,0.01);
    sig = Ringz.ar(b * 20, gFreq, 0.6);

	if(~autOrbitP == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan+LFTri.kr(rate/2,1.0).range(-0.02,0.02)),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan+LFTri.kr(rate/2,1.0).range(-0.02,0.02),~panlagTime, -1, 1),1.0,2.5,0);});

	/*if(~autOrbitP == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan+LFTri.kr(rate,0).range(-0.1,0.1)),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});*/

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\wind, {
	arg gate=0, amp=0.4, amp2=1.0, rate=0.45, pan=0, type=0, gust=1, atmos=60;
	var sig, globalAmp, env, lfo;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	//Select signal depending on planet type
	sig = Select.ar(type,[
			PinkNoise.ar(amp);,
			BrownNoise.ar(amp);]);

	//Sweeping low-pass filter on noise to create wind sound
	sig = LPF.ar(sig, Vibrato.kr(1000*gust,rate,rate,rateVariation:0.7,depthVariation:0.3));
	sig = LPF.ar(sig, Vibrato.kr(5000,rate,rate,rateVariation:0.7,depthVariation:0.3).lag(0.5));

	//High-pass filter for thinner atmosphere
	sig = HPF.ar(sig, atmos);

	if(~autOrbitP == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef.new(\fry, {
	arg gate=0, amp=0.7, amp2=1.0, freq=440, rate=1, time=1, pan=0, type=0, lowtemp=20, hightemp=200;
	var sig, globalAmp, env, newrate, newrate2, grate;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	//Set temperature range and length of day.
	newrate = SinOsc.kr(rate*time).range(lowtemp,hightemp);

	newrate2 = SinOsc.kr(rate*time).range(lowtemp/4000,hightemp/4000);

	//Grating sound
	sig = Dust.ar(newrate, 0.20);

	/*grate = Dust.kr(newrate/2, 0.3).range(100,14000); //rate: 5-1000
	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, grate, 0.1));*/

	//Select Low-pass filter (depending on day/night)
	//depending on if the temperature is dynamic or not
	sig = Select.ar(type,[
			LPF.ar(sig,SinOsc.kr(rate*time).range(4000,13000));,
			LPF.ar(sig,12000);]);

	sig = sig + Crackle.ar(2.0,newrate2); //GrayNoise, ClipNoise

	if(~autOrbitP == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\rings, {
	arg gate=0, amp=0.2, amp2=1.0, freq=400, rate=1, pan=0, type=0, dev=1.04;
	var sig, globalAmp, temp, env;

	env = EnvGen.kr(
		Env.adsr(5.0,0.0,1.0,5.0),
		gate,
		doneAction:0);

	sig = 0;
	3.do{
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05,0.2)}!3).range(dev.reciprocal,dev)
		);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!7).exprange(0.01,1);
		sig = sig + temp;
	};
	sig = LPF.ar(sig,400);
	sig = sig * 0.5;

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;


SynthDef(\percsusMoon, {
	arg gate=0, amp=0.4, ampMoon=1.0, freq=400, rate=1, pan=0;
	var sig, sig2, globalAmp, env, env2, t_gate=0;

	if(~autOrbitM == 1,
		{t_gate = gate * LFPulse.kr(rate);},
		{t_gate = gate * CircleRamp.kr(pan,~panlagTime,-1,1);});

	env = EnvGen.kr(
		Env.perc(0.01,0.5),
		t_gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig2 = (BPF.ar(sig, freq*1, 0.01) * 10);
	sig = (BPF.ar(sig, freq*2, 0.005) * 25);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = ampMoon;
	//globalAmp = -4*((Lag.kr(amp2, ~poslagTime)-0.5)**2)+1;
	//globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\percsusSolar, {
	arg gate=0, amp=0.2, amp2=1.0, freq=400, rate=1, pan=0, time=1;
	var sig, sig2, globalAmp, env, env2, t_gate=0;

	t_gate = gate * LFPulse.kr(rate*time);

	env = EnvGen.kr(
		Env.perc(0.01,0.5),
		t_gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig2 = (BPF.ar(sig, freq*2, 0.01) * 10);
	sig = (BPF.ar(sig, freq*4, 0.005) * 30);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	//globalAmp = -4*((Lag.kr(amp2, ~poslagTime)-0.5)**2)+1;
	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\percSolar, {
	arg freq=400, rate=1, pan=0, out=0, amp=0.2, amp2=1.0, gate=0, phase=0, time=1;
	var sig, globalAmp, env, t_gate=0;

	t_gate = gate * LFPulse.kr(rate*time,phase);
	env = EnvGen.kr(
		Env.perc(0.01,1/(rate*time)), // 1/rate as release
		t_gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, freq*2, 0.005) * 20);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\percMoon, {
	arg freq=400, rate=1, pan=0, out=0, amp=0.3, ampMoon=1.0, gate=0, phase=0, time=1;
	var sig, globalAmp, env, t_gate=0;

	t_gate = gate * LFPulse.kr(rate*time,phase);
	//t_gate = gate * CircleRamp.kr(pan,~panlagTime,-1,1);

	env = EnvGen.kr(
		Env.perc(0.01,1/(rate*time)), // 1/rate as release
		t_gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, freq, 0.005) * 20);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(ampMoon, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\sinsuspoof, {
	arg freq=400, rate=1, pan=0, out=0, amp=1.0, amp2=1.0, gate=0;
	var sig, globalAmp, sig2, env, env2, t_gate=0,oscillator1, oscillator2, resfreq;

	env = EnvGen.kr(
		Env.adsr(0.01,0.0,0.3,0.1),
		gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig2 = (BPF.ar(sig, freq*2, 0.01) * 5);
	sig = (BPF.ar(sig, Vibrato.kr(freq*4,rate,0.01), 0.005) * 20);

	sig = 1-SinOsc.kr(rate).range(0,1) * sig;

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\sinpoof, {
	arg freq=400, rate=1, pan=0, out=0, amp=1.0, amp2=1.0, gate=0;
	var sig, globalAmp, sig2, env, env2, t_gate=0,oscillator1, oscillator2, resfreq;

	env = EnvGen.kr(
		Env.adsr(0.01,0.0,0.3,0.1),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, Vibrato.kr(freq*2,rate,0.01), 0.005) * 20);

	sig = 1-SinOsc.kr(rate).range(0,1) * sig;

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig = sig  * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\suspoof, {
	arg freq=400, rate=1, pan=0, out=0, amp=0.5, amp2=1.0, gate=0;
	var sig, globalAmp, sig2, env, env2, t_gate=0,oscillator1, oscillator2;

	t_gate = gate * LFPulse.ar(rate/2);
	env = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		t_gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sig = PinkNoise.ar(1);
	sig2 = (BPF.ar(sig, freq, 0.01) * 40);
	sig = (BPF.ar(sig, freq*4, 0.01) * 40);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\lpfpoof, {
	arg freq=400, rate=1, pan=0, out=0, amp=1.0, amp2=1.0, gate=0;
	var sig, globalAmp, sig2, env, env2, t_gate=0,oscillator1, oscillator2, resfreq;

	env = EnvGen.kr(
		Env.adsr(0.01,0.0,0.3,0.1),
		gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, Vibrato.kr(freq*4,rate,0.01), 0.005) * 20);

	//Sweeping resonant low-pass filter for length of day
	resfreq = SinOsc.kr(rate) * 200 + 200;
	sig = RLPF.ar(sig, resfreq,0.5);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig = sig  * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\percmany, {
	arg freq=400, rate=1, pan=0, out=0, amp=0.3, amp2=1.0, gate=0, phase=0, time=1;
	var sig, globalAmp, env, t_gate=0;

	t_gate = gate * LFPulse.kr(rate*time,phase);
	env = EnvGen.kr(
		Env.perc(0.01,0.5), // 1/rate as release
		t_gate,
		doneAction:0);

	sig = BrownNoise.ar(1);
	sig = (BPF.ar(sig, freq, 0.005) * 20);

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;

SynthDef(\sinamppoof, {
	arg freq=400, rate=1, pan=0, out=0, amp=0.6, amp2=1.0, gate=0, time=1;
	var sig, globalAmp, sig2, env, env2, t_gate=0,oscillator1, oscillator2, resfreq, sinlvl;

	env = EnvGen.kr(
		Env.adsr(0.01,0.0,0.3,0.1),
		gate,
		doneAction:0);
	env2 = EnvGen.kr(
		Env.adsr(0.05,0.5,0.3,0.5),
		gate,
		doneAction:0);

	sinlvl = SinOsc.kr(rate*time).range(0,1);

	sig = BrownNoise.ar(1);
	sig2 = (BPF.ar(sig, freq*1, 0.01) * 5) * (1-sinlvl);
	sig = (BPF.ar(sig, freq*2, 0.005) * 20)* sinlvl;

	if(~autOrbitM == 1,
		{sig = PanAz.ar(7, sig, LFSaw.kr(pan),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, LFSaw.kr(pan),1.0,2.5,0);},
		{sig = PanAz.ar(7, sig, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);
		 sig2 = PanAz.ar(7, sig2, CircleRamp.kr(pan,~panlagTime,-1,1),1.0,2.5,0);});

	globalAmp = Lag.kr(amp2, ~poslagTime);
	sig = sig * env;
	sig2 = sig2 * env2;
	sig = (sig + sig2)/2 * amp * globalAmp;
	Out.ar(~surroundBus, sig);
}).add;
)


