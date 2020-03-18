(
~solarGrp = Group.new;
~innerSolarGrp = Group.new(~solarGrp);
~outerSolarGrp = Group.new(~solarGrp);

~planetaryGrp = Group.new;
~mercuryGrp = Group.new(~planetaryGrp);
~venusGrp = Group.new(~planetaryGrp);
~earthGrp = Group.new(~planetaryGrp);
~marsGrp = Group.new(~planetaryGrp);

~fxGrp = Group.after(~solarGrp);


//Setup
~reroute = Synth.new(\reroute, [\bus,~surroundBus], ~fxGrp);
~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus], ~fxGrp);


//Planetary View
//Mercury
~mercuryP = Synth.new(\surroundmod, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0], ~mercuryGrp);

~mercuryG = Synth.new(\gravity, [
		\freq, ~massMercury,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityMercury,
		\pan, 0], ~mercuryGrp);

~mercuryY = Synth.new(\percpoof, [
		\amp, 1.0,
		\freq, ~massMercury,
		\rate, ~orbitMercury/12,
		\pan, 0], ~mercuryGrp);
/*
~mercuryT = Synth.new(\fry, [
		\rate, ~invrotationMercury,
		\filt, 2000,
		\lowtemp, ~lowtempMercury,
		\hightemp, ~hightempMercury,
		\pan, 0], ~mercuryGrp);*/

//Venus
~venusP = Synth.new(\surroundmod, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0], ~venusGrp);

~venusG = Synth.new(\gravity, [
		\freq, ~massVenus,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityVenus,
		\pan, 0], ~venusGrp);

~venusW = Synth.new(\wind, [
		\amp, 0.5,
		\rate, 0.5,
		\pan, 0], ~venusGrp);


/*~venusT = Synth.new(\fry, [
		\rate, ~invrotationVenus,
		\filt, 6000,
		\lowtemp, ~lowtempVenus ,
		\hightemp, ~hightempVenus,
		\pan, 0], ~venusGrp);*/

//Earth
~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0], ~earthGrp);

~earthG = Synth.new(\gravity, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityEarth,
		\pan, 0], ~earthGrp);

~earthW = Synth.new(\wind, [
		\amp, 0.3,
		\rate, 0.3,
		\pan, 0], ~earthGrp);

/*~earthY = Synth.new(\poof, [
		\amp, 1.0,
		\freq, ~massEarth,
		\rate, ~orbitEarth*12,
		\pan, 0], ~earthGrp);*/


/*~earthT = Synth.new(\fry, [
		\rate, ~invrotationEarth,//~tempEarth,
		\filt, 2000,
		\lowtemp, ~lowtempEarth ,
		\hightemp, ~hightempEarth,
		\pan, 0], ~earthGrp);*/



~moonP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massMoon,
		\rate, ~invrotationMoon,
		\pan, ~orbitEarth], ~earthGrp); //~orbitMoon

//Mars
~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0], ~marsGrp);

~marsW = Synth.new(\wind, [
		\amp, 0.25,
		\rate, 0.3,
		\pan, 0], ~marsGrp);

~marsG = Synth.new(\gravity, [
		\freq, ~massMars,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityMars,
		\pan, 0], ~marsGrp);

/*~marsT = Synth.new(\fry, [
		\rate, ~invrotationMars,
		\filt, 6000,
		\lowtemp, ~lowtempMars ,
		\hightemp, ~hightempMars,
		\pan, 0], ~marsGrp);*/

~phobosP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massPhobos,
		\rate, ~invrotationPhobos,
		\pan, ~orbitMars], ~marsGrp); //~orbitPhobos

~deimosP = Synth.new(\poof, [
		\amp, 0.2,
		\freq, ~massDeimos,
		\rate, ~invrotationDeimos,
		\pan, ~orbitMars], ~marsGrp); //~orbitDeimos

 //Solar System View
~mercuryPoof = Synth.new(\poof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMars], ~innerSolarGrp);

~venusPoof = Synth.new(\poof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus], ~innerSolarGrp);

~earthPoof = Synth.new(\poof, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth], ~innerSolarGrp);

~marsPoof = Synth.new(\poof, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars], ~innerSolarGrp);

/*~jupiterPoof = Synth.new(\poof, [
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\pan, ~orbitJupiter], ~outerSolarGrp);

~saturnPoof = Synth.new(\poof, [
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn], ~outerSolarGrp);

~uranusPoof = Synth.new(\poof, [
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\pan, ~orbitUranus], ~outerSolarGrp);

~neptunePoof = Synth.new(\poof, [
		\freq, ~massNeptune,
		\rate, ~invrotationneptune,
		\pan, ~orbitNeptune], ~outerSolarGrp);*/

)

(
~planetaryGrp.set(\gate, 1);

~mercuryGrp.set(\gate, 1);
~mercuryP.set(\gate, 1);
~mercuryG.set(\gate, 1);
~mercuryY.set(\gate, 1);
~mercuryT.set(\gate, 1);

~mercuryT.set(\filt, 5000);

~venusGrp.set(\gate, 1);
~venusP.set(\gate, 1);
~venusG.set(\gate, 1);
~venusW.set(\gate, 1);
~venusT.set(\gate, 1);

~earthGrp.set(\gate, 1);
~earthP.set(\gate, 1);
~earthG.set(\gate, 1);
~earthW.set(\gate, 1);
~earthY.set(\gate, 1);
~earthT.set(\gate, 1);
~moonP.set(\gate, 1);

~marsGrp.set(\gate, 1);
~marsP.set(\gate, 1);
~marsG.set(\gate, 1);
~marsW.set(\gate, 1);
~marsT.set(\gate, 1);
~phobosP.set(\gate, 1);
~deimosP.set(\gate, 1);
)

(
~planetaryGrp.set(\gate, 0);

~mercuryGrp.set(\gate, 0);
~mercuryP.set(\gate, 0);
~mercuryG.set(\gate, 0);
~mercuryY.set(\gate, 0);
~mercuryT.set(\gate, 0);

~venusGrp.set(\gate, 0);
~venusP.set(\gate, 0);
~venusG.set(\gate, 0);
~venusW.set(\gate, 0);
~venusT.set(\gate, 0);

~earthGrp.set(\gate, 0);
~earthP.set(\gate, 0);
~earthG.set(\gate, 0);
~earthW.set(\gate, 0);
~earthY.set(\gate, 0);
~earthT.set(\gate, 0);
~moonP.set(\gate, 0);

~marsGrp.set(\gate, 0);
~marsP.set(\gate, 0);
~marsG.set(\gate, 0);
~marsW.set(\gate, 0);
~marsT.set(\gate, 0);
~phobosP.set(\gate, 0);
~deimosP.set(\gate, 0);
)



(
~innerSolarGrp.set(\gate, 1);
~innerSolarGrp.set(\gate, 0);

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
~mercuryS = Synth.new(\beating, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMercury]);

~venusS = Synth.new(\beating, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus]);

~earthS = Synth.new(\beating, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth]);

~marsS = Synth.new(\beating, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars]);
)

~mercuryS.set(\gate, 1);
~venusS.set(\gate, 1);
~earthS.set(\gate, 1);
~marsS.set(\gate, 1);


