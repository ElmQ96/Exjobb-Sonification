( //Groups
~solarGrp = Group.new;
~innerSolarGrp = Group.new(~solarGrp);
~outerSolarGrp = Group.new(~solarGrp);

~planetaryGrp = Group.new;
~innerPlanetaryGrp = Group.new(~planetaryGrp);
~outerPlanetaryGrp = Group.new(~planetaryGrp);

~mercuryGrp = Group.new(~innerPlanetaryGrp);
~venusGrp = Group.new(~innerPlanetaryGrp);
~earthGrp = Group.new(~innerPlanetaryGrp);
~marsGrp = Group.new(~innerPlanetaryGrp);
~jupiterGrp = Group.new(~outerPlanetaryGrp);
~saturnGrp = Group.new(~outerPlanetaryGrp);
~uranusGrp = Group.new(~outerPlanetaryGrp);
~neptuneGrp = Group.new(~outerPlanetaryGrp);

~fxGrp = Group.after(~solarGrp);

//Setup
~reroute = Synth.new(\reroute, [\sigbus,~surroundBus,\rebus,~reverbBus], ~fxGrp);
~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus], ~fxGrp);

//Planetary View

~moonMode = \percMoon;

//Mercury
~mercuryP = Synth.new(\surroundmod, [
		\amp, 0.2,
		\type, 0,
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\isMagnetic, 1,
		\pan, ~orbitMercury], ~mercuryGrp);

~mercuryG = Synth.new(\gravity, [
		\amp, 0.3,
		\type, 0,
		\freq, ~massMercury,
		\rate, 1/7,
		\gravity, ~gravityMercury,
		\pan, ~orbitMercury], ~mercuryGrp);

~mercuryT = Synth.new(\fry, [
		\rate, ~invrotationMercury,
		\type, 0,
		\lowtemp, ~lowtempMercury,
		\hightemp, ~hightempMercury,
		\pan, ~orbitMercury], ~mercuryGrp);

/*~mercuryY = Synth.new(\percpoof, [
		\freq, ~massMercury/2,
		\rate, ~orbitMercury,
		\pan, ~orbitMercury], ~mercuryGrp);*/

//Venus
~venusP = Synth.new(\surroundmod, [
		\amp, 0.2,
		\type, 0,
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\isMagnetic, 0,
		\pan, ~orbitVenus], ~venusGrp);

~venusG = Synth.new(\gravity, [
		\amp, 0.4,
		\type, 0,
		\freq, ~massVenus,
		\rate, 1/7,
		\gravity, ~gravityVenus,
		\pan, ~orbitVenus], ~venusGrp);

~venusW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 2,
		\pan, ~orbitVenus], ~venusGrp);

~venusT = Synth.new(\fry, [
		\type, 1,
		\rate, ~invrotationVenus,
		\lowtemp, ~lowtempVenus ,
		\hightemp, ~hightempVenus,
		\pan, ~orbitVenus], ~venusGrp);

/*~venusY = Synth.new(\percpoof, [
		\freq, ~massVenus/2,
		\rate, ~orbitVenus,
		\pan, ~orbitVenus], ~venusGrp);*/

//Earth
~earthP = Synth.new(\surroundmod, [
		\type, 0,
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\isMagnetic, 1,
		\pan, ~orbitEarth], ~earthGrp);

~earthG = Synth.new(\gravity, [
		\type, 0,
		\freq, ~massEarth,
		\rate, 1/7,
		\gravity, ~gravityEarth,
		\pan, ~orbitEarth], ~earthGrp);

~earthW = Synth.new(\wind, [
		\amp, 0.7,
		\type, 0,
		\rate, 0.3,
		\gust, 1,
		\pan, ~orbitEarth], ~earthGrp);

~earthT = Synth.new(\fry, [
		\type, 0,
		\rate, ~invrotationEarth,//~tempEarth,
		\lowtemp, ~lowtempEarth ,
		\hightemp, ~hightempEarth,
		\pan, ~orbitEarth], ~earthGrp);

/*~earthY = Synth.new(\percpoof, [
		\freq, ~massEarth/2,
		\rate, ~orbitEarth,
		\pan, ~orbitEarth], ~earthGrp);*/

~moonP = Synth.new(~moonMode, [
		\freq, ~massMoon,
		\rate, ~orbitMoon,
		\pan, ~orbitMoon], ~earthGrp);

//Mars
~marsP = Synth.new(\surroundmod, [
		\amp, 0.3,
		\type, 0,
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\isMagnetic, 0,
		\pan, ~orbitMars], ~marsGrp);

~marsG = Synth.new(\gravity, [
		\type, 0,
		\amp, 0.5,
		\freq, ~massMars,
		\rate, 1/7,
		\gravity, ~gravityMars,
		\pan, ~orbitMars], ~marsGrp);

~marsW = Synth.new(\wind, [
		\amp, 0.6,
		\type, 0,
		\rate, 0.2,
		\gust, 2,
		\atmos, 400,
		\pan, ~orbitMars], ~marsGrp);

~marsT = Synth.new(\fry, [
		\type, 0,
		\rate, ~invrotationMars,
		\lowtemp, ~lowtempMars,
		\hightemp, ~hightempMars,
		\pan, ~orbitMars], ~marsGrp);

/*~marsY = Synth.new(\percpoof, [
		\freq, ~massMars/2,
		\rate, ~orbitMars,
		\pan, ~orbitMars], ~marsGrp);*/

~phobosP = Synth.new(~moonMode, [
		\freq, ~massPhobos,
		\rate, ~orbitPhobos,
		\pan, ~orbitPhobos], ~marsGrp);

~deimosP = Synth.new(~moonMode, [
		\freq, ~massDeimos,
		\rate, ~orbitDeimos,
		\pan, ~orbitDeimos], ~marsGrp);

//Jupiter
~jupiterP = Synth.new(\surroundmod, [
		\amp, 0.4,
		\type, 1,
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\isMagnetic, 1,
		\pan, ~orbitJupiter], ~jupiterGrp);

~jupiterG = Synth.new(\gravity, [
		\amp, 0.5,
		\type, 1,
		\freq, ~massJupiter,
		\rate, 1/7,
		\gravity, ~gravityJupiter,
		\pan, ~orbitJupiter], ~jupiterGrp);

~jupiterW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitJupiter], ~jupiterGrp);

~jupiterT = Synth.new(\fry, [
		\type, 1,
		\rate, ~invrotationJupiter,
		\lowtemp, ~lowtempJupiter,
		\hightemp, ~hightempJupiter,
		\pan, ~orbitJupiter], ~jupiterGrp);

~ioP = Synth.new(~moonMode, [
		\freq, ~massIo,
		\rate, ~orbitIo,
		\pan, ~orbitIo], ~jupiterGrp);

~europaP = Synth.new(~moonMode, [
		\freq, ~massEuropa,
		\rate, ~orbitEuropa,
		\pan, ~orbitEuropa], ~jupiterGrp);

~ganymedeP = Synth.new(~moonMode, [
		\freq, ~massGanymede,
		\rate, ~orbitGanymede,
		\pan, ~orbitGanymede], ~jupiterGrp);

~callistoP = Synth.new(~moonMode, [
		\freq, ~massCallisto,
		\rate, ~orbitCallisto,
		\pan, ~orbitCallisto], ~jupiterGrp);

//Saturn
~saturnP = Synth.new(\surroundmod, [
		\amp, 0.4,
		\type, 1,
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\isMagnetic, 1,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnG = Synth.new(\gravity, [
		\amp, 0.5,
		\type, 1,
		\freq, ~massSaturn,
		\rate, 1/7,
		\gravity, ~gravitySaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 0.6,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnT = Synth.new(\fry, [
		\type, 1,
		\rate, ~invrotationSaturn,
		\lowtemp, ~lowtempSaturn,
		\hightemp, ~hightempSaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnR = Synth.new(\rings, [
		\freq, ~massSaturn*4,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~mimasP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massMimas,
		\rate, ~orbitMimas,
		\pan, ~orbitMimas], ~saturnGrp);

~enceladusP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massEnceladus,
		\rate, ~orbitEnceladus,
		\pan, ~orbitEnceladus], ~saturnGrp);

~tethysP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massTethys,
		\rate, ~invrotationSaturn/8,
		\phase, 0.375,
		\pan, ~orbitTethys], ~saturnGrp);

~dioneP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massDione,
		\rate, ~orbitDione,
		\pan, ~orbitDione], ~saturnGrp);

~rheaP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massRhea,
		\rate, ~orbitRhea,
		\pan, ~orbitRhea], ~saturnGrp);

~titanP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massTitan,
		\rate, ~orbitTitan,
		\pan, ~orbitTitan], ~saturnGrp);

~hyperionP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massHyperion,
		\rate, ~orbitHyperion,
		\pan, ~orbitHyperion], ~saturnGrp);

~iapetusP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massIapetus,
		\rate, ~orbitIapetus,
		\pan, ~orbitIapetus], ~saturnGrp);

//Uranus
~uranusP = Synth.new(\surroundmod, [
		\amp, 0.4,
		\type, 1,
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\isMagnetic, 1,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusG = Synth.new(\gravity, [
		\type, 1,
		\freq, ~massUranus,
		\rate, 1/7,
		\gravity, ~gravityUranus,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusT = Synth.new(\fry, [
		\type, 1,
		\rate, ~invrotationUranus,
		\lowtemp, ~lowtempUranus,
		\hightemp, ~hightempUranus,
		\pan, ~orbitUranus], ~uranusGrp);

~arielP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massAriel,
		\rate, ~orbitAriel,
		\pan, ~orbitAriel], ~uranusGrp);

~mirandaP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massMiranda,
		\rate, ~orbitMiranda,
		\pan, ~orbitMiranda], ~uranusGrp);

~oberonP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massOberon,
		\rate, ~orbitOberon,
		\pan, ~orbitOberon], ~uranusGrp);

~titaniaP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massTitania,
		\rate, ~orbitTitania,
		\pan, ~orbitTitania], ~uranusGrp);

~umbrielP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massUmbriel,
		\rate, ~orbitUmbriel,
		\pan, ~orbiUmbriel], ~uranusGrp);

//Neptune
~neptuneP = Synth.new(\surroundmod, [
		\amp, 0.4,
		\type, 1,
		\freq, ~massNeptune,
		\rate, ~invrotationNeptune,
		\isMagnetic, 1,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneG = Synth.new(\gravity, [
		\type, 1,
		\freq, ~massNeptune,
		\rate, 1/7,
		\gravity, ~gravityNeptune,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneT = Synth.new(\fry, [
		\rate, ~invrotationNeptune,
		\lowtemp, ~lowtempNeptune,
		\hightemp, ~hightempNeptune,
		\pan, ~orbitNeptune], ~neptuneGrp);

~tritonP = Synth.new(~moonMode, [
//		\amp, 0.2,
		\freq, ~massTriton,
		\rate, ~orbitTriton,
		\pan, ~orbiTriton], ~neptuneGrp);


//SOLAR SYSTEM VIEW

//~solarMode = \percsusSolar;
~solarMode = \percSolar;

//~solarMode = \sinsuspoof;
//~solarMode = \sinpoof;

//~solarMode = \suspoof;

//~solarMode = \lpfpoof;

//~solarMode = \sinamppoof;

//~solarMode = \percmanypoof;

~mercuryPoof = Synth.new(\sinamppoof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMercury], ~innerSolarGrp);

~venusPoof = Synth.new(\sinamppoof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus], ~innerSolarGrp);

~earthPoof = Synth.new(~solarMode, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth], ~innerSolarGrp);

~marsPoof = Synth.new(~solarMode, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars], ~innerSolarGrp);

~jupiterPoof = Synth.new(~solarMode, [
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\pan, ~orbitJupiter], ~outerSolarGrp);

~saturnPoof = Synth.new(~solarMode, [
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn], ~outerSolarGrp);

~uranusPoof = Synth.new(~solarMode, [
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\pan, ~orbitUranus], ~outerSolarGrp);

~neptunePoof = Synth.new(~solarMode, [
		\freq, ~massNeptune,
		\rate, ~invrotationNeptune,
		\pan, ~orbitNeptune], ~outerSolarGrp);
)

(
~chords = Pbind(
	\instrument, \percpoof,
	\gate, 1,
	\dur, 1,
	\freq, Pexprand(300,900,inf),
	\amp, 0.8,

).play
)