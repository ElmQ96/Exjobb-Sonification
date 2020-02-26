//OSC "debug mode": post all incoming OSC messages
OSCFunc.trace(true);
OSCFunc.trace(false);

//receiving OSC in SC from TouchOSC
//make sure TouchOSC is configured to send to the correct IP address and port (57120 if using default sclang port)

NetAddr.langPort; //confirm default port

(
OSCdef.new(\get_toggle, {
	arg msg, time, addr, port;
	//[msg, time, addr, port].postln;
	//msg.postln;
	msg[1].postln;
}, "/1/toggle1"); //make sure OSC pattern address is correct

OSCdef.new(\get_fader, {
	arg msg, time, addr, port;
	//[msg, time, addr, port].postln;
	//msg.postln;
	msg[1].postln;
}, "/1/fader2");

OSCdef.new(\get_knob, {
	arg msg, time, addr, port;
	//[msg, time, addr, port].postln;
	//msg.postln;
	msg[1].postln;
}, "/1/rotary1");
)

//send OSC from SC to TouchOSC
//define a NetAddr with TouchOSC device's IP address and receiving port
~touchOSC = NetAddr.new("10.194.216.212", 9000);

//update TouchOSC GUI elements
~touchOSC.sendMsg('/1/fader2', 0.75);

~touchOSC.sendMsg('/1/toggle1', 0);

//now with sound

s.boot;

(
SynthDef.new(\ping, {
	arg freq=500, pan=0, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01,1), doneAction:2);
	sig = SinOsc.ar(freq, 0, 0.4) * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;
)

Synth.new(\ping, [\freq, 1000, \pan, 0]);

OSCdef.freeAll; //cleanup

(
OSCdef.new(\makePing, {
	arg msg;
	//if button is turned on, make a Synth
	if( msg[1] == 1, {
		Synth.new(\ping, [
			\freq, exprand(300,2000),
			\pan, rrand(-0.5,0.5)
		]);
	});
}, '/1/toggle1');
)

//doesn't have to be sent from TouchOSC - can be sent from anywhere as long as sent to correct IP address + port, and data is consistent with what OSCdef expects (pattern address and numerical data)
~me = NetAddr.new("10.193.250.5", 57120); //your local IP here

~me.sendMsg('/1/toggle1', 1);


//slightly different synthdef
(
SynthDef.new(\ping, {
	arg freq=500, pan=0, out=0;
	var sig, env;

	//"sterilize" arguments
	freq = freq.clip(20,20000);
	pan = pan.clip(-1,1);

	env = EnvGen.kr(Env.perc(0.01,1), doneAction:2);
	sig = SinOsc.ar(freq, 0, 0.4) * env;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
});
)

(
OSCdef.new(\makePing, {
	arg msg;
	//expected values:
	//msg[1]: freq, msg[2]: pan

	//post it
	msg.postln;

	//if data are both numbers, make a Synth using OSC data as SynthDef arg values
	if(
		(msg[1].isNumber) && (msg[2].isNumber), {
			Synth.new(\ping, [
				\freq, msg[1],
				\pan, msg[2],
			]);
	});
}, '/makePing'); // will only listen to messages that match this address
)


//it's fine to add extra data at the end, which the OSCdef will ignore, except for postln-ing the whole thing
~me.sendMsg('/makePing', exprand(300,2000), rrand(-0.9,0.9), "eli");

//can also make a Routine that pipes OSC messages out
(
r = Routine.new({
	loop{
		~me.sendMsg('/makePing', exprand(300,2000), rrand(-0.9,0.9));
		0.25.wait;
	}
}).play;
)

r.stop;

//if on IllinoisNet, run this line
~eli = NetAddr.new("10.193.250.5", 57120);

//then this line
~eli.sendMsg('/makePing', exprand(300,2000), rrand(-0.9,0.9), "eli");

s.addr; //also possible but a bit more complex to send OSC directly to scsynth (which sclang does automatically when we do things like Synth.new, Group.new, Synth.set, Group.freeAll, Buffer.read, etc)

//we're used to doing it this way
x = Synth(\default, [\amp, 0.8])
x.free;

//this is what actually happens behind the scenes
s.sendMsg('/s_new', 'default', ~id = s.nextNodeID, 0, 1, 'amp', 0.8);
s.sendMsg('/n_free', ~id);

//it is also possible to make an instance of a Server on someone else's computer and send OSC messages (add SynthDefs, create Synths, load Buffers, etc) to it remotery
~s = Server.remote(...)
~s.sendMsg(...)