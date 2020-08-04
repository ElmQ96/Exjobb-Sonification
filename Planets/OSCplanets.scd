NetAddr.langPort;
NetAddr.localAddr;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = GUI-gate array
	//msg[3][0] = Size/day-gate
	//msg[3][1] = Gravity-gate
	//msg[3][2] = Temperature-gate
	//msg[3][3] = Atmosphere-gate
	//msg[3][4] = Moons-gate
	//msg[3][5] = Rings-gate
//msg[4] = Pos 1st moon
//msg[5] = Pos 2nd moon



(
~compareGate = 0;
~minDist = 3;
~maxDist = 500;

OSCdef.new(\speed,
	{
		arg msg;

		("time:" + msg[1]).postln;

		~planetaryGrp.set(\time, abs(msg[1]));
		~solarGrp.set(\time, abs(msg[1]));

	},'/Time');

OSCdef.new(\mercury,
	{
		arg msg;
		var amp = (~minDist*~diameterMercury)/msg[1];

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~mercuryP.set(\gate, 1);},
				{~mercuryP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~mercuryG.set(\gate, 1);},
				{~mercuryG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~mercuryT.set(\gate, 1);},
				{~mercuryT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~mercuryW.set(\gate, 1);},
				{~mercuryW.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (~minDist*~diameterMercury)/msg[1]});

			~mercuryGrp.set(\amp2, amp);},
			{~mercuryGrp.set(\amp2, 0.5);});

		~posMercury = -1*(msg[2]/pi);

		~mercuryGrp.set(\pan, ~posMercury);
		~mercuryPoof.set(\pan, ~posMercury);

	},'/Mercury');

OSCdef.new(\venus,
	{
		arg msg;
		var amp = (~minDist*~diameterVenus)/msg[1];

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~venusP.set(\gate, 1);},
				{~venusP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~venusG.set(\gate, 1);},
				{~venusG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~venusT.set(\gate, 1);},
				{~venusT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~venusW.set(\gate, 1);},
				{~venusW.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (~minDist*~diameterVenus)/msg[1]});

			~venusGrp.set(\amp2, amp);},
			{~venusGrp.set(\amp2, 0.5);});

		~posVenus = -1*(msg[2]/pi);

		~venusGrp.set(\pan, ~posVenus);
		~venusPoof.set(\pan, ~posVenus);

	},'/Venus');

OSCdef.new(\earth,
	{
		arg msg;

		var ampMoon;
		var amp = (-5.4e-7*1.1*msg[1]).exp*1.05;
		//("earthAngle:" + msg[2]).postln;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~earthP.set(\gate, 1);},
				{~earthP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~earthG.set(\gate, 1);},
				{~earthG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~earthT.set(\gate, 1);},
				{~earthT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~earthW.set(\gate, 1);},
				{~earthW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~moonP.set(\gate, 1);},
				{~moonP.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-5.4e-7*1.1*msg[1]).exp*1.05});

			~earthGrp.set(\amp2, amp);},
			{~earthGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~earthGrp.set(\ampMoon, ampMoon);

		~posEarth = -1*(msg[2]/pi);
		~posMoon = -1*(msg[4]/pi);

		~earthGrp.set(\pan, ~posEarth);
		~moonP.set(\pan, ~posMoon);
		~earthPoof.set(\pan, ~posEarth);

	},'/Earth');

OSCdef.new(\mars,
	{
		arg msg;
		var ampMoon;
		var amp = (-9.5e-6*0.5*msg[1]).exp*1.1;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~marsP.set(\gate, 1);},
				{~marsP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~marsG.set(\gate, 1);},
				{~marsG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~marsT.set(\gate, 1);},
				{~marsT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~marsW.set(\gate, 1);},
				{~marsW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~phobosP.set(\gate, 1);
					~deimosP.set(\gate, 1);
				},
				{~phobosP.set(\gate, 0);
					~deimosP.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-9.5e-6*0.5*msg[1]).exp*1.1});

			if(0>amp,
				{amp = 0.0},
				{amp = (-9.5e-6*0.5*msg[1]).exp*1.1});

			~marsGrp.set(\amp2, amp);},
			{~marsGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~marsGrp.set(\ampMoon, ampMoon);
		//("Mars moon amp:" + ampMoon).postln;

		~posMars = -1*(msg[2]/pi);
		~posPhobos = -1*(msg[4]/pi);
		~posDeimos = -1*(msg[5]/pi);

		~marsGrp.set(\pan, ~posMars);
		~phobosP.set(\pan, ~posPhobos);
		~deimosP.set(\pan, ~posDeimos);
		~marsPoof.set(\pan, ~posMars);

	},'/Mars');

OSCdef.new(\jupiter,
	{
		arg msg;
		var ampMoon;
		var amp = (-1.2e-7*0.9*msg[1]).exp*1.05;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~jupiterP.set(\gate, 1);},
				{~jupiterP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~jupiterG.set(\gate, 1);},
				{~jupiterG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~jupiterT.set(\gate, 1);},
				{~jupiterT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~jupiterW.set(\gate, 1);},
				{~jupiterW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~ioP.set(\gate, 1);
					~europaP.set(\gate, 1);
					~ganymedeP.set(\gate, 1);
					~callistoP.set(\gate, 1);
				},
				{~ioP.set(\gate, 0);
					~europaP.set(\gate, 0);
					~ganymedeP.set(\gate, 0);
					~callistoP.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-1.2e-7*0.9*msg[1]).exp*1.05});

			if(0>amp,
				{amp = 0.0},
				{amp = (-1.2e-7*0.9*msg[1]).exp*1.05});

			~jupiterGrp.set(\amp2, amp);},
			{~jupiterGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~jupiterGrp.set(\ampMoon, ampMoon);
		//("Jupiter moon amp:" + ampMoon).postln;

		~posJupiter = -1*(msg[2]/pi);
		~posIo = -1*(msg[4]/pi);
		~posEuropa = -1*(msg[5]/pi);
		~posGanymede = -1*(msg[6]/pi);
		~posCallisto = -1*(msg[7]/pi);

		~jupiterGrp.set(\pan, ~posJupiter);
		~ioP.set(\pan, ~posIo);
		~europaP.set(\pan, ~posEuropa);
		~ganymedeP.set(\pan, ~posGanymede);
		~callistoP.set(\pan, ~posCallisto);

		~jupiterPoof.set(\pan, ~posJupiter);

	},'/Jupiter');


OSCdef.new(\saturn,
	{
		arg msg;
		var ampMoon;
		var amp = (-1.2e-7*0.9*msg[1]).exp*1.05;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~saturnP.set(\gate, 1);},
				{~saturnP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~saturnG.set(\gate, 1);},
				{~saturnG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~saturnT.set(\gate, 1);},
				{~saturnT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~saturnW.set(\gate, 1);},
				{~saturnW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~mimasP.set(\gate, 1);
					~enceladusP.set(\gate, 1);
					~tethysP.set(\gate, 1);
					~dioneP.set(\gate, 1);
					~rheaP.set(\gate, 1);
					~titanP.set(\gate, 1);
					~hyperionP.set(\gate, 1);
					~iapetusP.set(\gate, 1);
				},
				{~mimasP.set(\gate, 0);
					~enceladusP.set(\gate, 0);
					~tethysP.set(\gate, 0);
					~dioneP.set(\gate, 0);
					~rheaP.set(\gate, 0);
					~titanP.set(\gate, 0);
					~hyperionP.set(\gate, 0);
					~iapetusP.set(\gate, 0);
			});

			if(msg[3][5]==1,
				{~saturnR.set(\gate, 1);},
				{~saturnR.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-1.2e-7*0.9*msg[1]).exp*1.05});

			~saturnGrp.set(\amp2, amp);},
			{~saturnGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~saturnGrp.set(\ampMoon, ampMoon);
		//("Saturn moon amp:" + ampMoon).postln;

		~posSaturn = -1*(msg[2]/pi);

		~posDione = -1*(msg[4]/pi);
		~posEnceladus = -1*(msg[5]/pi);
		~posHyperion = -1*(msg[6]/pi);
		~posIapetus = -1*(msg[7]/pi);
		~posMimas = -1*(msg[8]/pi);
		~posRhea = -1*(msg[9]/pi);
		~posTethys = -1*(msg[10]/pi);
		~posTitan = -1*(msg[11]/pi);

		~saturnGrp.set(\pan, ~posSaturn);
		~mimasP.set(\pan, ~posMimas);
		~enceladusP.set(\pan, ~posEnceladus);
		~tethysP.set(\pan, ~posTethys);
		~dioneP.set(\pan, ~posDione);
		~rheaP.set(\pan, ~posRhea);
		~titanP.set(\pan, ~posTitan);
		~hyperionP.set(\pan, ~posHyperion);
		~iapetusP.set(\pan, ~posIapetus);
		~saturnPoof.set(\pan, ~posSaturn);

	},'/Saturn');

OSCdef.new(\uranus,
	{
		arg msg;
		var ampMoon;
		var amp = (-6.7e-7*0.7*msg[1]).exp*1.1;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~uranusP.set(\gate, 1);},
				{~uranusP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~uranusG.set(\gate, 1);},
				{~uranusG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~uranusT.set(\gate, 1);},
				{~uranusT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~uranusW.set(\gate, 1);},
				{~uranusW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~arielP.set(\gate, 1);
					~mirandaP.set(\gate, 1);
					~oberonP.set(\gate, 1);
					~titaniaP.set(\gate, 1);
					~umbrielP.set(\gate, 1);
				},
				{~arielP.set(\gate, 0);
					~mirandaP.set(\gate, 0);
					~oberonP.set(\gate, 0);
					~titaniaP.set(\gate, 0);
					~umbrielP.set(\gate, 0);
			});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-6.7e-7*0.7*msg[1]).exp*1.1});

			~uranusGrp.set(\amp2, amp);},
			{~uranusGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~uranusGrp.set(\ampMoon, ampMoon);
		//("Uranus moon amp:" + ampMoon).postln;

		~posUranus = -1*(msg[2]/pi);
		~posAriel = -1*(msg[4]/pi);
		~posMiranda = -1*(msg[5]/pi);
		~posOberon = -1*(msg[6]/pi);
		~posTitania = -1*(msg[7]/pi);
		~posUmbriel = -1*(msg[8]/pi);

		~uranusGrp.set(\pan, ~posUranus);
		~arielP.set(\pan, ~posAriel);
		~mirandaP.set(\pan, ~posMiranda);
		~oberonP.set(\pan, ~posOberon);
		~titaniaP.set(\pan, ~posTitania);
		~umbrielP.set(\pan, ~posUmbriel);

		~uranusPoof.set(\pan, ~posUranus);

	},'/Uranus');

OSCdef.new(\neptune,
	{
		arg msg;
		var ampMoon;
		var amp = (-7.7e-7*0.8*msg[1]).exp*1.15;

		if(~compareGate == 0,
			{if(msg[3][0]==1,
				{~neptuneP.set(\gate, 1);},
				{~neptuneP.set(\gate, 0);});

			if(msg[3][1]==1,
				{~neptuneG.set(\gate, 1);},
				{~neptuneG.set(\gate, 0);});

			if(msg[3][2]==1,
				{~neptuneT.set(\gate, 1);},
				{~neptuneT.set(\gate, 0);});

			if(msg[3][3]==1,
				{~neptuneW.set(\gate, 1);},
				{~neptuneW.set(\gate, 0);});

			if(msg[3][4]==1,
				{~tritonP.set(\gate, 1);},
				{~tritonP.set(\gate, 0);});

			if(amp>1.0,
				{amp = 1.0},
				{amp = (-7.7e-7*0.8*msg[1]).exp*1.15});

			~neptuneGrp.set(\amp2, amp);},
			{~neptuneGrp.set(\amp2, 0.5);});

		ampMoon = -4*(amp - 0.5).pow(2)+1;
		~neptuneGrp.set(\ampMoon, ampMoon);
		//("Neptune moon amp:" + ampMoon).postln;

		~posNeptune = -1*(msg[2]/pi);
		~posTriton = -1*(msg[4]/pi);

		~neptuneGrp.set(\pan, ~posNeptune);
		~tritonP.set(\pan, ~posTriton);
		~neptunePoof.set(\pan, ~posNeptune);

	},'/Neptune');

OSCdef.new(\sun,
	{
		arg msg;
		//msg[1] = array of gates
		//msg[1][0] = all gate
		//msg[1][1] = mercury
		//msg[1][2] = venus
		//msg[1][3] = earth
		//msg[1][4] = mars
	    //...

		if(msg[1][0] == 1,
			{~mercuryPoof.set(\gate, 1);},
			{~mercuryPoof.set(\gate, 0);});

		if(msg[1][1] == 1,
			{~venusPoof.set(\gate, 1);},
			{~venusPoof.set(\gate, 0);});

		if(msg[1][2] == 1,
			{~earthPoof.set(\gate, 1);},
			{~earthPoof.set(\gate, 0);});

		if(msg[1][3] == 1,
			{~marsPoof.set(\gate, 1);},
			{~marsPoof.set(\gate, 0);});

		if(msg[1][4] == 1,
			{~jupiterPoof.set(\gate, 1);},
			{~jupiterPoof.set(\gate, 0);});

		if(msg[1][5] == 1,
			{~saturnPoof.set(\gate, 1);},
			{~saturnPoof.set(\gate, 0);});

		if(msg[1][6] == 1,
			{~uranusPoof.set(\gate, 1);},
			{~uranusPoof.set(\gate, 0);});

		if(msg[1][7] == 1,
			{~neptunePoof.set(\gate, 1);},
			{~neptunePoof.set(\gate, 0);});

	},'/Sun');

OSCdef.new(\compare,
	{
		arg msg;
		//msg[1] = first planet to compare
		//msg[2] = second planet to compare

		("First: " + msg[1]).postln;
		("Second: " + msg[2]).postln;

		if(msg[1] != 0 or: msg[2] != 0,
			{~compareGate=1;},
			{~compareGate=0});


		if(msg[1] == 1 or: msg[2] == 1,
			{~mercuryGrp.set(\gate, 1);},
			{~mercuryGrp.set(\gate, 0);});

		if(msg[1] == 2 or: {msg[2] == 2},
			{~venusGrp.set(\gate, 1);},
			{~venusGrp.set(\gate, 0);});

		if(msg[1] == 3 or: {msg[2] == 3},
			{~earthGrp.set(\gate, 1);},
			{~earthGrp.set(\gate, 0);});

		if(msg[1] == 4 or: {msg[2] == 4},
			{~marsGrp.set(\gate, 1);},
			{~marsGrp.set(\gate, 0);});

		if(msg[2] == 5 or: {msg[1] == 5},
			{~jupiterGrp.set(\gate, 1);},
			{~jupiterGrp.set(\gate, 0);});

		if(msg[1] == 6 or: {msg[2] == 6},
			{~saturnGrp.set(\gate, 1);},
			{~saturnGrp.set(\gate, 0);});

		if(msg[1] == 7 or: {msg[2] == 7},
			{~uranusGrp.set(\gate, 1);},
			{~uranusGrp.set(\gate, 0);});

		if(msg[1] == 8 or: {msg[2] == 8},
			{~neptuneGrp.set(\gate, 1);},
			{~neptuneGrp.set(\gate, 0);});

	},'/Compare');
)