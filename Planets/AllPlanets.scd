(//Setup
~reroute = Synth.new(\reroute, [\bus,~surroundBus]);
~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus]);
)

(//Planetary View
~mercuryP = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0]);

~mercuryG = Synth.new(\gravity, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\gravity, ~gravityMercury,
		\pan, 0]);

~mercuryY = Synth.new(\percpoof, [
		\amp, 1.0,
		\freq, ~massMercury,
		\rate, ~orbitMercury/12,
		\pan, 0]);

~mercuryT = Synth.new(\fry, [
		\rate, ~tempMercury,
		\pan, 0]);


~venusP = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0]);

~venusG = Synth.new(\gravity, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\gravity, ~gravityVenus,
		\pan, 0]);

~venusW = Synth.new(\wind, [
		\amp, 0.5,
		\rate, 0.5,
		\pan, 0]);


~venusT = Synth.new(\fry, [
		\rate, ~tempVenus,
		\pan, 0]);


~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0]);

~earthG = Synth.new(\gravity, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\gravity, ~gravityEarth,
		\pan, 0]);

~earthW = Synth.new(\wind, [
		\amp, 0.3,
		\rate, 0.3,
		\pan, 0]);

~earthY = Synth.new(\poof, [
		\amp, 1.0,
		\freq, ~massEarth,
		\rate, ~orbitEarth*12,
		\pan, 0]);


~earthT = Synth.new(\fry, [
		\rate, ~tempEarth,
		\pan, 0]);



~moonP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massMoon,
		\rate, ~invrotationMoon,
		\pan, ~orbitEarth]); //~orbitMoon

~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0]);

~marsW = Synth.new(\wind, [
		\amp, 0.25,
		\rate, 0.3,
		\pan, 0]);

~marsG = Synth.new(\gravity, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\gravity, ~gravityMars,
		\pan, 0]);


~marsT = Synth.new(\fry, [
		\rate, ~tempMars,
		\pan, 0]);

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
~mercuryY.set(\gate, 1);
~mercuryT.set(\gate, 1);

~venusP.set(\gate, 1);
~venusG.set(\gate, 1);
~venusW.set(\gate, 1);
~venusT.set(\gate, 1);

~earthP.set(\gate, 1);
~earthG.set(\gate, 1);
~earthW.set(\gate, 1);
~earthY.set(\gate, 1);
~earthT.set(\gate, 1);
~moonP.set(\gate, 1);

~marsP.set(\gate, 1);
~marsG.set(\gate, 1);
~marsW.set(\gate, 1);
~marsT.set(\gate, 1);
~phobosP.set(\gate, 1);
~deimosP.set(\gate, 1);
)

(
~mercuryP.set(\gate, 0);
~mercuryG.set(\gate, 0);
~mercuryY.set(\gate, 0);
~mercuryT.set(\gate, 0);

~venusP.set(\gate, 0);
~venusG.set(\gate, 0);
~venusW.set(\gate, 0);
~venusT.set(\gate, 0);

~earthP.set(\gate, 0);
~earthG.set(\gate, 0);
~earthW.set(\gate, 0);
~earthY.set(\gate, 0);
~earthT.set(\gate, 0);
~moonP.set(\gate, 0);

~marsP.set(\gate, 0);
~marsG.set(\gate, 0);
~marsW.set(\gate, 0);
~marsT.set(\gate, 0);
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