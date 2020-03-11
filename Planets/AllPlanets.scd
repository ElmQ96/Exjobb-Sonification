(//Setup
~reroute = Synth.new(\reroute, [\bus,~surroundBus]);
~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus]);
)

(//Planetary View
~mercuryP = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMercury]);

~mercuryG = Synth.new(\gravity, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\gravity, ~gravityMercury,
		\pan, ~orbitMercury]);


~venusP = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus]);

~venusG = Synth.new(\gravity, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\gravity, ~gravityVenus,
		\pan, ~orbitVenus]);

~venusW = Synth.new(\wind, [
		\amp, 0.4,
		\rate, 0.4,
		\pan, ~orbitVenus]);


~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth]);

~earthG = Synth.new(\gravity, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\gravity, ~gravityEarth,
		\pan, ~orbitEarth]);

~earthW = Synth.new(\wind, [
		\amp, 0.2,
		\rate, 0.2,
		\pan, ~orbitEarth]);

~moonP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massMoon,
		\rate, ~invrotationMoon,
		\pan, ~orbitEarth]); //~orbitMoon


~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars]);

~marsW = Synth.new(\wind, [
		\amp, 0.05,
		\rate, 0.2,
		\pan, ~orbitMars]);

~marsG = Synth.new(\gravity, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\gravity, ~gravityMars,
		\pan, ~orbitMars]);

~phobosP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massPhobos,
		\rate, ~invrotationPhobos,
		\pan, ~orbitMars]); //~orbitPhobos

~deimosP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massDeimos,
		\rate, ~invrotationDeimos,
		\pan, ~orbitMars]); //~orbitDeimos
)

(
~mercuryP.set(\gate, 1);
~mercuryG.set(\gate, 1);

~venusP.set(\gate, 1);
~venusG.set(\gate, 1);
~venusW.set(\gate, 1);

~earthP.set(\gate, 1);
~earthG.set(\gate, 1);
~earthW.set(\gate, 1);
~moonP.set(\gate, 1);

~marsP.set(\gate, 1);
~marsG.set(\gate, 1);
~marsW.set(\gate, 1);
~phobosP.set(\gate, 1);
~deimosP.set(\gate, 1);
)

(
~mercuryP.set(\gate, 0);
~mercuryG.set(\gate, 0);
~venusP.set(\gate, 0);
~venusG.set(\gate, 0);
~venusW.set(\gate, 0);
~earthP.set(\gate, 0);
~earthG.set(\gate, 0);
~earthW.set(\gate, 0);
~moonP.set(\gate, 0);
~marsP.set(\gate, 0);
~marsG.set(\gate, 0);
~marsW.set(\gate, 0);
~phobosP.set(\gate, 0);
~deimosP.set(\gate, 0);
)

( //Solar System View
~mercuryPoof = Synth.new(\poof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMars]);

~venusPoof = Synth.new(\poof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus]);

~earthPoof = Synth.new(\poof, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth]);

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

(
~mercuryPoof.set(\gate, 1);
~venusPoof.set(\gate, 1);
~earthPoof.set(\gate, 1);
~marsPoof.set(\gate, 1);

~jupiterPoof.set(\gate, 1);
~saturnPoof.set(\gate, 1);
~uranusPoof.set(\gate, 1);
~neptunePoof.set(\gate, 1);
)
(
~mercuryPoof.set(\gate, 0);
~venusPoof.set(\gate, 0);
~earthPoof.set(\gate, 0);
~marsPoof.set(\gate, 0);

~jupiterPoof.set(\gate, 0);
~saturnPoof.set(\gate, 0);
~uranusPoof.set(\gate, 0);
~neptunePoof.set(\gate, 0);
)

(//Solar system View
~mercuryS = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~posMercury,
		\reverb, 0.5]);

~venusS = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~posVenus,
		\reverb, 0.5]);

~earthS = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~posEarth,
		\reverb, 0.5]);

~marsS = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~posMars,
		\reverb, 0.5]);
)