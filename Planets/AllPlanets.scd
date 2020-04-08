( //Groups
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
		\amp, 0.2,
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, 0], ~mercuryGrp);

~mercuryG = Synth.new(\gravity, [
		\freq, ~massMercury,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityMercury,
		\pan, 0], ~mercuryGrp);

~mercuryY = Synth.new(\percpoof, [
		\amp, 0.5,
		\freq, ~massMercury,
		\rate, ~orbitMercury/12,
		\pan, 0], ~mercuryGrp);

~mercuryT = Synth.new(\fry, [
		\rate, ~invrotationMercury,
		\filt, 2000,
		\lowtemp, ~lowtempMercury,
		\hightemp, ~hightempMercury,
		\pan, 0], ~mercuryGrp);

//Venus
~venusP = Synth.new(\surroundmod, [
		\amp, 0.2,
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, 0], ~venusGrp);

~venusG = Synth.new(\gravity, [
		\freq, ~massVenus,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityVenus,
		\pan, 0], ~venusGrp);

~venusW = Synth.new(\wind, [
		\amp, 0.9,
		\rate, 0.5,
		\gust, 0.5,
		\pan, 0], ~venusGrp);


~venusT = Synth.new(\fry, [
		\rate, ~invrotationVenus,
		\filt, 6000,
		\lowtemp, ~lowtempVenus ,
		\hightemp, ~hightempVenus,
		\pan, 0], ~venusGrp);

//Earth
~earthP = Synth.new(\surroundmod, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, 0], ~earthGrp);

~earthG = Synth.new(\gravity, [
		\freq, ~massEarth,
		\rate, 0.5,
		\gravity, ~gravityEarth,
		\pan, 0], ~earthGrp);

~earthW = Synth.new(\wind, [
		\amp, 0.6,
		\rate, 0.2,
		\gust, 1,
		\pan, 0], ~earthGrp);

/*~earthY = Synth.new(\poof, [
		\amp, 1.0,
		\freq, ~massEarth,
		\rate, ~orbitEarth*12,
		\pan, 0], ~earthGrp);*/


~earthT = Synth.new(\fry, [
		\rate, ~invrotationEarth,//~tempEarth,
		\filt, 2000,
		\lowtemp, ~lowtempEarth ,
		\hightemp, ~hightempEarth,
		\pan, 0], ~earthGrp);

~moonP = Synth.new(\sinpoof, [
		\amp, 0.2,
		\freq, ~massMoon,
		\rate, ~invrotationMoon,
		\pan, ~orbitMoon], ~earthGrp); //~orbitMoon

//Mars
~marsP = Synth.new(\surroundmod, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, 0], ~marsGrp);

~marsW = Synth.new(\wind, [
		\amp, 0.4,
		\rate, 0.3,
		\gust, 5,
		\atmos, 200,
		\pan, 0], ~marsGrp);

~marsG = Synth.new(\gravity, [
		\freq, ~massMars,
		\rate, ~invrotationEarth/7,
		\gravity, ~gravityMars,
		\pan, 0], ~marsGrp);

~marsT = Synth.new(\fry, [
		\rate, ~invrotationMars,
		\filt, 6000,
		\lowtemp, ~lowtempMars ,
		\hightemp, ~hightempMars,
		\pan, 0], ~marsGrp);

~phobosP = Synth.new(\sinpoof, [
		\amp, 0.2,
		\freq, ~massPhobos,
		\rate, ~invrotationPhobos,
		\pan, ~orbitPhobos], ~marsGrp); //~orbitPhobos

~deimosP = Synth.new(\sinpoof, [
		\amp, 0.2,
		\freq, ~massDeimos,
		\rate, ~invrotationDeimos,
		\pan, ~orbitDeimos], ~marsGrp); //~orbitDeimos

//Solar System View
~mercuryPoof = Synth.new(\sinpoof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMars], ~innerSolarGrp);

~venusPoof = Synth.new(\sinpoof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus], ~innerSolarGrp);

~earthPoof = Synth.new(\sinpoof, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth], ~innerSolarGrp);

~marsPoof = Synth.new(\sinpoof, [
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