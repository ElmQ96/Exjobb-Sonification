//Mouse radar

(
var mercury = {
	var sig;
	sig = SinOsc.ar(MouseX.kr(500,1000), 0, 0.2);
	sig = sig!2;
}.play;
)

(
var venus = {
	var sig;
	sig = SinOsc.ar(MouseY.kr(300,800), 0, 0.2);
	sig = sig!2;
}.play;
)

(
var earth = {
	var sig;
	sig = SinOsc.ar(MouseX.kr(200,700), 0, 0.2);
	sig = sig!2;
}.play;
)

(
var mars = {
	var sig;
	sig = SinOsc.ar(MouseY.kr(400,900), 0, 0.2);
	sig = sig!2;
}.play;
)