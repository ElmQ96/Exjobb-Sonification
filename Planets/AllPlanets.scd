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
~reroute = Synth.new(\reroute, [\bus,~surroundBus], ~fxGrp);
~reverb = Synth.new(\reverb, [\in,~surroundBus,\out,~reverbBus], ~fxGrp);


//Planetary View
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
		\freq, ~massMercury,
		\rate, 1/7,
		\gravity, ~gravityMercury,
		\pan, ~orbitMercury], ~mercuryGrp);

~mercuryT = Synth.new(\fry, [
		\rate, ~invrotationMercury,
		\lowtemp, ~lowtempMercury,
		\hightemp, ~hightempMercury,
		\pan, ~orbitMercury], ~mercuryGrp);

/*~mercuryY = Synth.new(\percpoof, [
		\amp, 0.5,
		\freq, ~massMercury,
		\rate, ~orbitMercury/12,
		\pan, ~orbitMercury], ~mercuryGrp);*/

//Venus
~venusP = Synth.new(\surroundmod, [
		\amp, 0.15,
		\type, 0,
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\isMagnetic, 0,
		\pan, ~orbitVenus], ~venusGrp);

~venusG = Synth.new(\gravity, [
		\amp, 0.6,
		\freq, ~massVenus,
		\type, 0,
		\rate, 1/7,
		\gravity, ~gravityVenus,
		\pan, ~orbitVenus], ~venusGrp);

~venusW = Synth.new(\wind, [
		\amp, 0.4,
		\type, 1,
		\rate, 0.5,
		\gust, 1,
		\pan, ~orbitVenus], ~venusGrp);


~venusT = Synth.new(\fry, [
		\rate, ~invrotationVenus,
		\lowtemp, ~lowtempVenus ,
		\hightemp, ~hightempVenus,
		\pan, ~orbitVenus], ~venusGrp);

//Earth
~earthP = Synth.new(\surroundmod, [
		\type, 0,
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\isMagnetic, 1,
		\pan, ~orbitEarth], ~earthGrp);

~earthG = Synth.new(\gravity, [
		\freq, ~massEarth,
		\rate, 1/7,
		\gravity, ~gravityEarth,
		\pan, ~orbitEarth], ~earthGrp);

~earthW = Synth.new(\wind, [
		\amp, 0.6,
		\type, 0,
		\rate, 0.2,
		\gust, 1,
		\pan, ~orbitEarth], ~earthGrp);

~earthT = Synth.new(\fry, [
		\rate, ~invrotationEarth,//~tempEarth,
		\lowtemp, ~lowtempEarth ,
		\hightemp, ~hightempEarth,
		\pan, ~orbitEarth], ~earthGrp);

/*~earthY = Synth.new(\poof, [
		\amp, 1.0,
		\freq, ~massEarth,
		\rate, ~orbitEarth*12,
		\pan, 0], ~earthGrp);*/

~moonP = Synth.new(\percsuspoof, [
		\amp, 0.2,
		\freq, ~massMoon,
		\rate, ~orbitMoon,
		\pan, ~orbitMoon], ~earthGrp);

//Mars
~marsP = Synth.new(\surroundmod, [
		\type, 0,
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\isMagnetic, 0,
		\pan, ~orbitMars], ~marsGrp);

~marsG = Synth.new(\gravity, [
		\amp, 0.5,
		\freq, ~massMars,
		\rate, 1/7,
		\gravity, ~gravityMars,
		\pan, ~orbitMars], ~marsGrp);

~marsW = Synth.new(\wind, [
		\amp, 0.3,
		\type, 0,
		\rate, 0.4,
		\gust, 5,
		\atmos, 200,
		\pan, ~orbitMars], ~marsGrp);


~marsT = Synth.new(\fry, [
		\rate, ~invrotationMars,
		\lowtemp, ~lowtempMars,
		\hightemp, ~hightempMars,
		\pan, ~orbitMars], ~marsGrp);

~phobosP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massPhobos,
		\rate, ~orbitPhobos,
		//\rate, ~invrotationMars/2,
		//\phase, 0.25,
		\pan, ~orbitPhobos], ~marsGrp);

~deimosP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massDeimos,
		\rate, ~orbitDeimos,
		//\rate, ~invrotationMars/2,
		//\phase, 0.75,
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
		\rate, ~invrotationJupiter,
		\lowtemp, ~lowtempJupiter,
		\hightemp, ~hightempJupiter,
		\pan, ~orbitJupiter], ~jupiterGrp);

~ioP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massIo,
		\rate, ~orbitIo,
//		\rate, ~invrotationJupiter/4,
//		\phase, 0.25+0.125,
		\pan, ~orbitIo], ~jupiterGrp);

~europaP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massEuropa,
		\rate, ~orbitEuropa,
//		\rate, ~invrotationJupiter/4,
//		\phase, 0.75+0.125,
		\pan, ~orbitEuropa], ~jupiterGrp);

~ganymedeP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massGanymede,
		\rate, ~orbitGanymede,
//		\rate, ~invrotationJupiter/4,
//		\phase, 0+0.125,
		\pan, ~orbitGanymede], ~jupiterGrp);

~callistoP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massCallisto,
		\rate, ~orbitCallisto,
//		\rate, ~invrotationJupiter/4,
//		\phase, 0.5+0.125,
		\pan, ~orbitCallisto], ~jupiterGrp);


//Saturn
~saturnP = Synth.new(\surroundmod, [
		\amp, 0.5,
		\type, 1,
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\isMagnetic, 1,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnG = Synth.new(\gravity, [
		\freq, ~massSaturn,
		\rate, 1/7,
		\gravity, ~gravitySaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnW = Synth.new(\wind, [
		\amp, 0.5,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnT = Synth.new(\fry, [
		\rate, ~invrotationSaturn,
		\lowtemp, ~lowtempSaturn,
		\hightemp, ~hightempSaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~saturnR = Synth.new(\rings, [
		\freq, ~massSaturn*4,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn], ~saturnGrp);

~mimasP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massMimas,
		\rate, ~orbitMimas,
		\pan, ~orbitMimas], ~saturnGrp);

~enceladusP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massEnceladus,
		\rate, ~orbitEnceladus,
		\pan, ~orbitEnceladus], ~saturnGrp);

~tethysP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massTethys,
		\rate, ~invrotationSaturn/8,
		\phase, 0.375,
		\pan, ~orbitTethys], ~saturnGrp);

~dioneP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massDione,
		\rate, ~orbitDione,
		\pan, ~orbitDione], ~saturnGrp);

~rheaP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massRhea,
		\rate, ~orbitRhea,
		\pan, ~orbitRhea], ~saturnGrp);

~titanP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massTitan,
		\rate, ~orbitTitan,
		\pan, ~orbitTitan], ~saturnGrp);

~hyperionP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massHyperion,
		\rate, ~orbitHyperion,
		\pan, ~orbitHyperion], ~saturnGrp);

~iapetusP = Synth.new(\percsuspoof, [
		\amp, 0.1,
		\freq, ~massIapetus,
		\rate, ~orbitIapetus,
		\pan, ~orbitIapetus], ~saturnGrp);

//Uranus
~uranusP = Synth.new(\surroundmod, [
		\amp, 0.5,
		\type, 1,
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\isMagnetic, 1,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusG = Synth.new(\gravity, [
		\freq, ~massUranus,
		\rate, 1/7,
		\gravity, ~gravityUranus,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusW = Synth.new(\wind, [
		\amp, 0.6,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitUranus], ~uranusGrp);

~uranusT = Synth.new(\fry, [
		\rate, ~invrotationUranus,
		\lowtemp, ~lowtempUranus,
		\hightemp, ~hightempUranus,
		\pan, ~orbitUranus], ~uranusGrp);

//Neptune
~neptuneP = Synth.new(\surroundmod, [
		\amp, 0.5,
		\type, 1,
		\freq, ~massNeptune,
		\rate, ~invrotationNeptune,
		\isMagnetic, 1,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneG = Synth.new(\gravity, [
		\freq, ~massNeptune,
		\rate, 1/7,
		\gravity, ~gravityNeptune,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneW = Synth.new(\wind, [
		\amp, 0.9,
		\type, 1,
		\rate, 0.5,
		\gust, 0.5,
		\pan, ~orbitNeptune], ~neptuneGrp);

~neptuneT = Synth.new(\fry, [
		\rate, ~invrotationNeptune,
		\lowtemp, ~lowtempNeptune,
		\hightemp, ~hightempNeptune,
		\pan, ~orbitNeptune], ~neptuneGrp);

//SOLAR SYSTEM VIEW
~mercuryPoof = Synth.new(\percpoof, [
		\freq, ~massMercury,
		\rate, ~invrotationMercury,
		\pan, ~orbitMercury], ~innerSolarGrp);

~venusPoof = Synth.new(\percpoof, [
		\freq, ~massVenus,
		\rate, ~invrotationVenus,
		\pan, ~orbitVenus], ~innerSolarGrp);

~earthPoof = Synth.new(\percpoof, [
		\freq, ~massEarth,
		\rate, ~invrotationEarth,
		\pan, ~orbitEarth], ~innerSolarGrp);

~marsPoof = Synth.new(\percpoof, [
		\freq, ~massMars,
		\rate, ~invrotationMars,
		\pan, ~orbitMars], ~innerSolarGrp);

~jupiterPoof = Synth.new(\percpoof, [
		\freq, ~massJupiter,
		\rate, ~invrotationJupiter,
		\pan, ~orbitJupiter], ~outerSolarGrp);

~saturnPoof = Synth.new(\percpoof, [
		\freq, ~massSaturn,
		\rate, ~invrotationSaturn,
		\pan, ~orbitSaturn], ~outerSolarGrp);

~uranusPoof = Synth.new(\percpoof, [
		\freq, ~massUranus,
		\rate, ~invrotationUranus,
		\pan, ~orbitUranus], ~outerSolarGrp);

~neptunePoof = Synth.new(\percpoof, [
		\freq, ~massNeptune,
		\rate, ~invrotationNeptune,
		\pan, ~orbitNeptune], ~outerSolarGrp);

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