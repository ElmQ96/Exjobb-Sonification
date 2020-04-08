(
//Mass (10^24 kg), C2-C5
var mul = 1, orbitscale= 12.0, tempscale=174, tempscale2=2, tempscale3=99;

//C4-C5
/*~massMercury = 523.25*mul;//C5
~massVenus =  329.63*mul;//E4
~massEarth =  261.63*mul;//C4
//~massMars =  493.88*mul;//B4
//~massMars =  440.00*mul;//A4
~massMars =  392.00*mul;//G4 */

~massMercury = 523.25*mul;//C5
~massVenus =  329.63*mul;//E4
~massEarth =  261.63*mul;//C4
~massMars =  392.00*mul;//G4

//C3-C4 blankt
//C2-C3
~massJupiter = 65.406*mul; //C2
~massSaturn = 82.41*mul; //G2
~massUranus = 130.81*mul; //C3
~massNeptune =  98.00*mul; //B2

//not scaled
~massMoon = 659.25; //E5
~massPhobos = 783.99; //G5
~massDeimos = 987.77;

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

//1 day/second
~orbitMoon = 0.03663003663;
~orbitPhobos = 3.13568091311;
~orbitDeimos = 0.79211685307;

~orbitJupiter = (1/4331)*orbitscale;
~orbitSaturn = (1/10747)*orbitscale;
~orbitUranus = (1/30589)*orbitscale;
~orbitNeptune = (1/59800)*orbitscale;

/*orbit, 1 month/second
~orbitMercury = 0.34578146611*orbitscale;
~orbitVenus = 0.13550135501*orbitscale;
~orbitEarth = 0.08333330167*orbitscale;
~orbitMars = 0.04432624113*orbitscale;*/

//Length of day, ratio earth (1/rotationRatio),(24hrs/sec)
~invrotationMercury = 1/175.9;
~invrotationVenus = 1/116.8; //-
~invrotationEarth = 1;
~invrotationMars = 1/1.03;

//tidally locked
~invrotationMoon = ~orbitMoon;
~invrotationPhobos = ~orbitPhobos;
~invrotationDeimos = ~orbitDeimos;

~invrotationJupiter = 1/0.414;
~invrotationSaturn = 1/0.444;
~invrotationUranus = 1/0.718; //-
~invrotationNeptune = 1/0.671;

//Gravity (g), relation to Earth
~gravityMercury = 0.378;
~gravityVenus = 0.907;
~gravityEarth = 1;
~gravityMars = 0.377;

~gravityJupiter = 2.36;
~gravitySaturn = 0.916;
~gravityUranus = 0.889;
~gravityNeptune = 1.12;

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


/*Mass Earth ratio,Hz
~massMercury = 4698.63 //4731, D8
~massVenus =  329.63 //321, E4
~massEarth = 261.63; //C4
~massMars = 2489.02  //2445, D7-E7, D#

~massJupiter =  //0.82, nothing
~massSaturn =  //2.74
~massUranus = 18.35 // 18, D0
~massNeptune =16.35  //15.3, C0*/