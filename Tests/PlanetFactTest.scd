(//10^24 kg, pitch, relation, inversed
~massMercury = 600;
~massVenus = 278.0141844;
~massEarth = 200;
~massMars = 577.8723404;

//days, Length of sound
~orbitMercury = 88.0;
~orbitVenus = 224.7;
~orbitEarth = 365.2;
~orbitMars = 687.0;

//10^6 km,
~sundistanceMercury = 57.9;
~sundistanceVenus = 108.2;
~sundistanceEarth = 149.6;
~sundistanceMars = 227.9;

//hours, vibrato (Pan)
~rotationMercury = 0.7856058258;
~rotationVenus = 0.1; //-
~rotationEarth = 1;
~rotationMars = 0.9998915401;
)//Orbital Eccentricity based on vibrato depth

//Temperature change

(
SynthDef.new(\mercury, {
	var sig,amp=0.5,env, pan = ~rotationMercury;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[0.5,5,0.5],[1,1,-1]),
		//doneAction:2
	);
	//amp = SinOsc.kr(pan);
	sig = SinOscFB.ar(Vibrato.kr(~massMercury,pan,0.40),0.2);
	sig = FreeVerb.ar(sig, 0.1, 0.5, 0.5);
	sig = sig * amp;// * env;
	sig = Splay.ar(sig,0,0.5,-0.2);
	Out.ar(0,sig);
}).play;
)

(
SynthDef.new(\venus, {
	var sig,amp=0.5,env, pan = ~rotationVenus;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[0.5,5,0.5],[1,1,-1]),
		//doneAction:2
	);
	//amp = SinOsc.kr(pan);
	sig = LFTri.ar(Vibrato.kr(~massVenus,pan,0.20),0.2);
	//sig = Pan2.ar(sig,SinOsc.kr(pan));
	sig = FreeVerb.ar(sig, 0.2, 0.5, 0.5);
	sig = sig * amp;// * env;
	sig = Splay.ar(sig,0,0.5,0.5);
	Out.ar(0,sig);
}).play;
)

(
SynthDef.new(\earth, {
	var sig,sig1,sig2,amp1=1.0,amp2=0.1,env, pan = ~rotationEarth;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[0.5,5,0.5],[1,1,-1]),
		//doneAction:2
	);
	//amp1 = SinOsc.kr(pan);
	//amp2 = SinOsc.kr(pan-0.5);
	sig1 = SinOscFB.ar(Vibrato.kr(~massEarth,pan,0.20),0.2);
	sig2 = SinOsc.ar(~massEarth*2.0);
	//sig2 = Pan2.ar(sig2,SinOsc.kr(pan/2));
	sig1 = sig1 * amp1;// * env;
	sig2 = sig2 * amp2;
	sig1 = FreeVerb.ar(sig1, 0.3, 0.5, 0.5);
	sig2 = FreeVerb.ar(sig2, 0.3, 0.5, 0.5);
	sig = sig1 * sig2;
	sig = Splay.ar([sig1,sig2],0,0.5,-0.8);
	Out.ar(0,sig);
}).play;
)

(
SynthDef.new(\mars, {
	var sig,sig1,sig2,sig3,amp1=0.7,amp2=0.1, amp3=0.1,env, pan = ~rotationMars;
	env = EnvGen.kr(
		Env.new([0,1,1,0],[0.5,5,0.5],[1,1,-1]),
		//doneAction:2
	);
	//amp1 = SinOsc.kr(pan);
	//amp2 = SinOsc.kr(pan-0.5);
	sig1 = SinOscFB.ar(Vibrato.kr(~massMars,pan,0.25),0.2);
	sig2 = SinOsc.ar(~massMars*1.2);
	sig3 = SinOsc.ar(~massMars*1.3);
	//sig2 = Pan2.ar(sig.2,SinOsc.kr((pan/100)-0.4));
	//sig3 = Pan2.ar(sig3,SinOsc.kr(pan/100));
	sig1 = sig1 * amp1;// * env;
	sig2 = sig2 * amp2;
	sig3 = sig3 * amp3;
	sig1 = FreeVerb.ar(sig1, 0.4, 0.5, 0.5);
	sig2 = FreeVerb.ar(sig2, 0.5, 0.5, 0.5);
	sig3 = FreeVerb.ar(sig3, 0.5, 0.5, 0.5);
	sig = Splay.ar([sig1,sig2,sig3],0,0.5,0.9);
	Out.ar(0,sig);
	//Out.ar(1,sig);
}).play;
)
