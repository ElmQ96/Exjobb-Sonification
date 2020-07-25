(
//Mass (10^24 kg), C2-C5
var mul = 1, orbitscale= 12.0, gravityscale=2, tempscale=174, tempscale2=2, tempscale3=99;

~time = 1;

//C4-C5
~massMercury = 523.25*mul;//C5
~massVenus =  329.63*mul;//E4
~massEarth =  261.63*mul;//C4
//~massMars =  440.00*mul;//A4
~massMars =  392.00*mul;//G4

//C3-C4 blank
//C2-C3
~massJupiter = 65.406*mul; //C2
~massSaturn = 82.41*mul; //E2
~massUranus = 130.81*mul; //C3
~massNeptune =  110.00*mul; //A2

//Moons, not scaled
~massMoon = 659.25; //E5

~massPhobos = 783.99; //G5
~massDeimos = 1046.50; //C6

~massIo = 659.25; //E5, similar to moon
~massEuropa = 783.99; //G5
~massGanymede =  440.00; //A4, biggest
~massCallisto = 523.25; //C5, similar to mercury

~massMimas =  1046.50; //C6
~massEnceladus = 880.00; //A5
~massTethys =  783.99; //G5
~massDione = 659.25; //E5,
~massRhea = 523.25; //C5,
~massTitan = 440.00; //A4, biggest
~massHyperion = 1318.51; //E6
~massIapetus = 587.33; //D5

~massAriel = 880.00; //A5
~massMiranda = 1046.50; //C6
~massOberon =  659.25; //E5
~massTitania = 523.25; //C5
~massUmbriel = 783.99; //G5

~massTriton = 440.00; //A4, biggest

//Diameter
~diameterMercury = 4879;
~diameterVenus = 12104;
~diameterEarth = 12756;
~diameterMars = 6792;

~diameterJupiter = 142984;
~diameterSaturn = 120536;
~diameterUranus = 51118;
~diameterNeptune = 49528;

//orbital period, Earth ratio, (1 day/second)
~orbitMercury = (1/88)*orbitscale;
~orbitVenus = (1/224.7)*orbitscale;
~orbitEarth = (1/365.2)*orbitscale;
~orbitMars = (1/687)*orbitscale;

~orbitJupiter = (1/4331)*orbitscale;
~orbitSaturn = (1/10747)*orbitscale;
~orbitUranus = (1/30589)*orbitscale;
~orbitNeptune = (1/59800)*orbitscale;

/*~orbitMercury = 0;
~orbitVenus = 0;
~orbitEarth = 0;
~orbitMars = 0;

~orbitJupiter = 0;
~orbitSaturn = 0;
~orbitUranus = 0;
~orbitNeptune = 0;*/


~orbitMoon = 1/27.3;

~orbitPhobos = 1/0.31891;
~orbitDeimos = 1/1.26244;

~orbitIo = 1/1.8;
~orbitEuropa = 1/3.6;
~orbitGanymede = 1/7.2;
~orbitCallisto = 1/16.7;

~orbitMimas = 1/0.9424218;
~orbitEnceladus = 1/1.370218;
~orbitTethys =  1/1.887802;
~orbitDione = 1/2.736915;
~orbitRhea = 1/4.517500;
~orbitTitan = 1/15.945421;
~orbitHyperion = 1/21.276609;
~orbitIapetus = 1/79.330183;

~orbitAriel = 1/2.520379;
~orbitMiranda = 1/1.413479;
~orbitOberon = 1/13.463234;
~orbitTitania = 1/8.705867;
~orbitUmbriel = 1/4.144176;

~orbitTriton = 1/5.876854;

//Length of day, ratio earth (1/rotationRatio),(24hrs/sec)
~invrotationMercury = 1/175.9;
~invrotationVenus = 1/116.8; //-
~invrotationEarth = 1;
~invrotationMars = 1/1.03;

~invrotationJupiter = 1/0.414;
~invrotationSaturn = 1/0.444;
~invrotationUranus = 1/0.718; //-
~invrotationNeptune = 1/0.671;

//Moons are tidally locked ~invrotation = ~orbit

//Gravity (g), relation to Earth
~gravityMercury = 0.378/gravityscale;
~gravityVenus = 0.907/gravityscale;
~gravityEarth = 1/gravityscale;
~gravityMars = 0.377/gravityscale;

~gravityJupiter = 2.36/gravityscale;
~gravitySaturn = 0.916/gravityscale;
~gravityUranus = 0.889/gravityscale;
~gravityNeptune = 1.12/gravityscale;

//Avrg temperatur
~tempMercury = (167+tempscale)*tempscale2;
~tempVenus = (464+tempscale)*tempscale2;
~tempEarth = (15+tempscale)*tempscale2;
~tempMars = (-65+tempscale)*tempscale2;

//Kelvin
~lowtempMercury = 100-tempscale3;
~lowtempVenus = 735-tempscale3;
~lowtempEarth = 185-tempscale3;
~lowtempMars = 120-tempscale3;

~hightempMercury = 700-tempscale3;
~hightempVenus = 735-tempscale3;
~hightempEarth = 331-tempscale3;
~hightempMars = 293-tempscale3;

~lowtempJupiter = ~hightempJupiter = 163-tempscale3;
~lowtempSaturn = ~hightempSaturn = 133-tempscale3;
~lowtempUranus = ~hightempUranus = 100-tempscale3; //78
~lowtempNeptune = ~hightempNeptune = 100-tempscale3; //73

/*~lowtempMercury = (-173+tempscale)*tempscale2; //-173
~lowtempVenus = (462+tempscale)*tempscale2;
~lowtempEarth = (-88+tempscale)*tempscale2;
~lowtempMars = (-153+tempscale)*tempscale2; //-153

~hightempMercury = (427+tempscale)*tempscale2;
~hightempVenus = (462+tempscale)*tempscale2;
~hightempEarth = (58+tempscale)*tempscale2;
~hightempMars = (20+tempscale)*tempscale2;*/

/*
~tempJupiter = (-110+tempscale)*tempscale2;
~tempSaturn = (-140+tempscale)*tempscale2;
~tempUranus = (-195+tempscale)*tempscale2;
~tempNeptune = (-200+tempscale)*tempscale2;
*/
)

//Bruce Mass mapping
//E2 - E8

//E2 - G4
//A4 - E6 blankt
//F6 - E8

//merc E8
//venus G6
//Earth F6
//Mars C8

//Jupiter E2
//Saturn D3
//Uranus G4
//Neptune F4

//Quinton Mass mapping
//C2-C4
//~massMercury = 261.63;//C4
//~massVenus = 220.00;//A3
//~massEarth = 196.00;//G3
//~massMars = 246.94;//B3

//~massJupiter = 65.41;//C2
//~massSaturn = 73.42;//D2
//~massUranus = 82.41;//E2
//~massNeptune = 87.31;//F2