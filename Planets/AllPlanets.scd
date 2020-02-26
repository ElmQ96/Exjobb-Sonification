//Planetary View
(~mercuryP = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0,
		\reverb, 0.5]);

~venusP = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0,
		\reverb, 0.5]);

~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0,
		\reverb, 0.5]);

~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0,
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



//No Surround
(~mercury = Synth.new(\mod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0,
		\reverb, 0.5]);

~venus = Synth.new(\mod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0,
		\reverb, 0.5]);

~earth = Synth.new(\mod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0,
		\reverb, 0.5]);

~mars = Synth.new(\mod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0,
		\reverb, 0.5]);
)




(~jupiter = Synth.new(\mod, [
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\pan, 0.2,
		\reverb, 0.5]);
)
(~saturn = Synth.new(\mod, [
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\pan, 0.5,
		\reverb, 0.5]);
)
(~uranus = Synth.new(\mod, [
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\pan, 0.8,
		\reverb, 0.5]);
)
(~neptune = Synth.new(\mod, [
		\freq, ~massNeptune,
		\rate, ~invrotationNeptune,
		\pan, 1,
		\reverb, 0.5]);
)

(~sun = Synth.new(\mod, [
		\freq, 50,
		\rate, ~invrotationSun,
		\pan, 0,
		\reverb, 0.5]);
)


~earth.set(\gate, 1)
~earth.set(\gate, 0)




//Solar system View
(~mercuryS = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0,
		\reverb, 0.5]);

~venusS = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0,
		\reverb, 0.5]);

~earthS = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0,
		\reverb, 0.5]);

~marsS = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0,
		\reverb, 0.5]);
)

~mercuryS.set(\gate, 1)
~mercuryS.set(\gate, 0)

~venusS.set(\gate, 1)
~venusS.set(\gate, 0)

~earthS.set(\gate, 1)
~earthS.set(\gate, 0)


//Poof
(~mercuryPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massMercury,
		\dur, 1000,
		\pan, -1
).play
)
(~venusPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massVenus,
		\dur, 1000,
		\pan, -0.7
).play
)
(~earthPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massEarth,
		\dur, ~rotationEarth,
		\pan, -0.4
).play
)
(~marsPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massMars,
		\dur, ~rotationMars,
		\pan, -0.1
).play
)
(~jupiterPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massJupiter,
		\dur, 0.4,
		\pan, 0.2
).play
)
(~saturnPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massSaturn,
		\dur, ~rotationSaturn,
		\pan, 0.5
).play
)
(~uranusPoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massUranus,
		\dur, ~rotationUranus,
		\pan, 0.7
).play
)
(~neptunePoof =Pbind(
		\type, \note,
		\instrument, \poof,
		\freq, ~massNeptune,
		\dur, ~rotationNeptune,
		\pan, 1.0
).play
)




