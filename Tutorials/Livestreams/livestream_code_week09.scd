(
//create a window and make it visible/frontmost
w = Window.new;
w.front;
)

(
w.close; //can be useful to close a window if re-creating it to avoid window buildup

//title & rectacular bounds
//pixels from left, from bottom, window width, height
w = Window.new("my window", Rect(1200, 200, 400, 400));
w.front;
)

//useful for clearing away all windows
Window.closeAll;

//also will apply to
s.scope;
s.meter; //etc

(
w.close;
w = Window.new("my window", Rect(1200, 200, 400, 400));

//populate with GUI objects
//when creating GUI objects on a Window, Rect represents pixels from left, then pixels from *top*, then width, height
~sl = Slider.new(w, Rect(50,20,30,150));

//a function to define the GUI object's action
~sl.action_({
	arg view;
	view.value.postln;
});

w.front;
)

//if using global variables, can interact with GUI in separate code context
~sl.visible_(false); //hide it
~sl.value; //return its value
~sl.background_(Color.magenta); //change its background color

//flashy background color dance
//doesn't work because GUI calls can't be scheduled on a TempoClock
x = { {w.view.background_(Color.rand);0.2.wait}.loop }.fork;
x.stop;

//schedule them on AppClock instead like this:
x = { {w.view.background_(Color.rand);0.2.wait}.loop }.fork(AppClock)
x.stop;


(
w.close;
w = Window.new("my window", Rect(1200, 200, 400, 400));

//GUI attributes (action, background, etc) can be chained together using this syntax:
~sl = Slider.new(w, Rect(50,20,30,150))
.action_({
	arg view;
	view.value.postln;
})
.background_(Color.rand);

~kn = Knob.new(w, Rect(120, 20, 100, 100))
.action_({
	arg kn;
	kn.value.postln;
	//knob's action fades slider's color from black to red
	~sl.background_(Color.new(kn.value, 0, 0));
})
.mode_(\vert) //some GUI objects have unique methods, e.g. Knob has a user interaction "mode" (how you move the mouse in order to change the slider state)

//and expects an array of Colors using the color method, instead of background
.color_([Color.red, Color.blue, Color.yellow, Color.green]);

w.front;
)

(
//adding a button
w.close;
w = Window.new("my window", Rect(1200, 200, 400, 400));

~sl = Slider.new(w, Rect(50,20,30,150))
.action_({
	arg view;
	view.value.postln;
})
.background_(Color.black);

~kn = Knob.new(w, Rect(120, 20, 100, 100))
.action_({
	arg kn;
	//kn.value.postln;
	~sl.background_(Color.new(kn.value, 0, 0));
});

~btn = Button.new(w, Rect(50,250,200,30))
.action_({
	arg btn;
	btn.value.postln;
})
//buttons have states: text label, text color, bg color
.states_([
	["click to turn on", Color.gray(0.2), Color.green(0.8)],
	["click to turn off", Color.cyan(0.7), Color.gray(0.2)],
]);
w.front;
)

//example with sound
s.boot;

//simple tone
(
SynthDef.new(\tone2, {
	arg freq=440, amp=0.2, out=0, gate=0;
	var sig, env;
	env = EnvGen.kr(Env.asr(0,1,0), gate);
	sig = SinOsc.ar(freq);
	amp = Lag.kr(amp, 0.1); //Lag is useful for smoothing control signals to avoid clicks from GUI movement discontinuities
	sig = sig * env * amp!2;
	Out.ar(out,sig);
}).add;
)

(
~tone.free; //free the Synth in case it already exists

//with sound
w.close;
w = Window.new("my window", Rect(1200, 200, 400, 400));

~sl = Slider.new(w, Rect(50,20,30,150))
.action_({
	arg sl;
	//sl.value.postln;
	~tone.set(\amp, sl.value * 0.2)
})
.background_(Color.black);

~kn = Knob.new(w, Rect(120, 20, 100, 100))
.action_({
	arg kn;
	//kn.value.postln;
	~sl.background_(Color.new(kn.value, 0, 0));
});

~btn = Button.new(w, Rect(50,250,200,30))
.action_({
	arg btn;
	btn.value.postln;

	//alternate conditional logig using if
	// if(
	// 	btn.value == 1, {~tone.set(\gate, 1)},  {~tone.set(\gate, 0)}
	// );

	//use button state to set env gate value
	~tone.set(\gate, btn.value);
})
.states_([
	["click to turn on", Color.gray(0.2), Color.green(0.8)],
	["click to turn off", Color.cyan(0.7), Color.gray(0.2)],
]);
w.front;

//tone initially silent
~tone = Synth(\tone2, [\gate, 0, \amp, ~sl.value * 0.2]);
)

//possible to use iteration to generate multiple GUI objects and store them in a collection
(
w.close;
w = Window.new(bounds:Rect(400,300,1000,500));
~knobs = 10.collect({
	arg n;
	Knob.new(w, Rect((n*50)+10,10,40,40))
});
w.front;
)

~knobs[7].value_(0.5); //talk to an individual knob

MIDIIn.connectAll; //MIDI example

(
w.close;
w = Window.new(bounds:Rect(400,300,1000,500));

~kn = Knob.new(w, Rect(30,30,100,100))
.action_({
	arg kn;
	kn.value.postln;
});
w.front;

MIDIdef.cc(\moveKnob, {
	arg val, num, chan;

	//value updates a GUI's value but does not call its action
	//valueAction updates a GUI's value *and* calls its action

	{~kn.valueAction_(val/127)}.defer; //calls to GUI objects inside MIDIdef must be "deferred" to the AppClock
}, 23); //change ccNum if necessary for your own controller
)


//composite view is useful for organizing GUIs into subcategories
(
w.close;
w = Window.new(bounds:Rect(400,300,1000,500));

~cv = CompositeView.new(w, Rect(400,50,80,80))
.background_(Color.green);
~kn2 = Knob.new(~cv, Rect(5,5,30,30));

~kn = Knob.new(w, Rect(30,30,100,100))
.action_({
	arg kn;
	kn.value.postln;
});
w.front;
)

~cv.visible_(false);
~cv.visible_(true);
~cv.children;