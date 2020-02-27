//Planetary View
(~mercuryP = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~mercuryPos,
		\reverb, 0.5]);

~venusP = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~venusPos,
		\reverb, 0.5]);

~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~earthPos,
		\reverb, 0.5]);

~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~marsPos,
		\reverb, 0.5]);
)

~mercuryP.set(\gate, 1)
~mercuryP.set(\gate, 0)

~venusP.set(\gate, 1)
~venusP.set(\gate, 0)

~earthP.set(\gate, 1)
~earthP.set(\gate, 0)

~earthP.set(\reverb, 0.9)


~marsP.set(\gate, 1)
~marsP.set(\gate, 0)


//Solar system View
(~mercuryS = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~mercuryPos,
		\reverb, 0.5]);

~venusS = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~venusPos,
		\reverb, 0.5]);

~earthS = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~earthPos,
		\reverb, 0.5]);

~marsS = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~marsPos,
		\reverb, 0.5]);
)

~mercuryS.set(\gate, 1)
~mercuryS.set(\gate, 0)

~venusS.set(\gate, 1)
~venusS.set(\gate, 0)

~earthS.set(\gate, 1)
~earthS.set(\gate, 0)

~marsS.set(\gate, 1)
~marsS.set(\gate, 0)

//Poof
(
~mercuryPoof = Synth.new(\poof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMars]);
//)
//(
~venusPoof = Synth.new(\poof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus]);
//)
//(
~earthPoof = Synth.new(\poof, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth]);
//)
//(
~marsPoof = Synth.new(\poof, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars]);

~jupiterPoof = Synth.new(\poof, [
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\pan, ~orbitJupiter]);
~saturnPoof = Synth.new(\poof, [
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn]);
~uranusPoof = Synth.new(\poof, [
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\pan, ~orbitUranus]);
~neptunePoof = Synth.new(\poof, [
		\freq, ~massNeptune,
		\rate, ~invrotationneptune,
		\pan, ~orbitNeptune]);
)

~mercuryPoof.set(\gate, 1);
~venusPoof.set(\gate, 1);
~earthPoof.set(\gate, 1);
~marsPoof.set(\gate, 1);

~jupiterPoof.set(\gate, 1);
~saturnPoof.set(\gate, 1);
~uranusPoof.set(\gate, 1);
~neptunePoof.set(\gate, 1);

~mercuryPoof.set(\gate, 0);
~venusPoof.set(\gate, 0);
~earthPoof.set(\gate, 0);
~marsPoof.set(\gate, 0);

~jupiterPoof.set(\gate, 0);
~saturnPoof.set(\gate, 0);
~uranusPoof.set(\gate, 0);
~neptunePoof.set(\gate, 0);




