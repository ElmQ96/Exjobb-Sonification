NetAddr.langPort;
NetAddr.localAddr;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = time (days/s)
//msg[4] = GUI-gate array
	//msg[4][0] = Size/day-gate
	//msg[4][1] = Gravity-gate
	//msg[4][2] = Temperature-gate
	//msg[4][3] = Atmosphere-gate
	//msg[4][4] = Moons-gate
//msg[5] = Pos 1st moon
//msg[6] = Pos 2nd moon

(
~minDist = 3;
~maxDist = 500;

OSCdef.new(\mercury,
	{
		arg msg;
		var amp = (~minDist*~diameterMercury)/msg[1];

		if(msg[4][0]==1,
			{~mercuryP.set(\gate, 1);},
			{~mercuryP.set(\gate, 0);});

		if(msg[4][1]==1,
			{~mercuryG.set(\gate, 1);},
			{~mercuryG.set(\gate, 0);});

		if(msg[4][2]==1,
			{~mercuryW.set(\gate, 1);},
			{~mercuryW.set(\gate, 0);});

		if(amp>1.0,
			{amp = 1.0},
			{amp = (~minDist*~diameterMercury)/msg[1]});

		~mercuryGrp.set(\amp2, amp);

		~posMercury = -1*(msg[2]/pi);

		~mercuryGrp.set(\pan, ~posMercury);
		~mercuryPoof.set(\pan, ~posMercury);

	},'/Mercury');

OSCdef.new(\venus,
	{
		arg msg;
		var amp = (~minDist*~diameterVenus)/msg[1];

		if(msg[4][0]==1,
			{~venusP.set(\gate, 1);},
			{~venusP.set(\gate, 0);});

		if(msg[4][1]==1,
			{~venusG.set(\gate, 1);},
			{~venusG.set(\gate, 0);});

		if(msg[4][2]==1,
			{~venusW.set(\gate, 1);},
			{~venusW.set(\gate, 0);});

		if(amp>1.0,
			{amp = 1.0},
			{amp = (~minDist*~diameterVenus)/msg[1]});

		~venusGrp.set(\amp2, amp);

		~posVenus = -1*(msg[2]/pi);

		~venusGrp.set(\pan, ~posVenus);
		~venusPoof.set(\pan, ~posVenus);

	},'/Venus');

OSCdef.new(\earth,
	{
		arg msg;

		var amp = (~minDist*~diameterEarth)/msg[1];
		//("earthAngle:" + msg[2]).postln;

		if(msg[4][0]==1,
			{~earthP.set(\gate, 1);},
			{~earthP.set(\gate, 0);});

		if(msg[4][1]==1,
			{~earthG.set(\gate, 1);},
			{~earthG.set(\gate, 0);});

		if(msg[4][2]==1,
			{~earthW.set(\gate, 1);},
			{~earthW.set(\gate, 0);});

		if(msg[4][3]==1,
			{~moonP.set(\gate, 1);},
			{~moonP.set(\gate, 0);});

		if(amp>1.0,
			{amp = 1.0},
			{amp = ((~minDist*~diameterEarth)/msg[1])});

		~earthGrp.set(\amp2, amp);

		~posEarth = -1*(msg[2]/pi);
		~posMoon = -1*(msg[5]/pi);

		~earthGrp.set(\pan, ~posEarth);
		~moonP.set(\pan, ~posMoon);
		~earthPoof.set(\pan, ~posEarth);

	},'/Earth');

OSCdef.new(\mars,
	{
		arg msg;
		var amp = (~minDist*~diameterMars)/msg[1];

		if(msg[4][0]==1,
			{~marsP.set(\gate, 1);},
			{~marsP.set(\gate, 0);});

		if(msg[4][1]==1,
			{~marsG.set(\gate, 1);},
			{~marsG.set(\gate, 0);});

		if(msg[4][2]==1,
			{~marsW.set(\gate, 1);},
			{~marsW.set(\gate, 0);});

		if(msg[4][3]==1,
			{~phobosP.set(\gate, 1);
			 ~deimosP.set(\gate, 1);
			},
			{~phobosP.set(\gate, 0);
			 ~deimosP.set(\gate, 0);});

		if(amp>1.0,
			{amp = 1.0},
			{amp = (~minDist*~diameterMars)/msg[1]});

		~marsGrp.set(\amp2, amp);

		~posMars = -1*(msg[2]/pi);
		~posPhobos = -1*(msg[5]/pi);
		~posDeimos = -1*(msg[6]/pi);

		~marsGrp.set(\pan, ~posMars);
		~phobosP.set(\pan, ~posPhobos);
		~deimosP.set(\pan, ~posDeimos);
		~marsPoof.set(\pan, ~posMars);

	},'/Mars');
/*
OSCdef.new(\focus,
	{
		arg msg;
		var focus = msg[1];
		("Focus:" + msg[1]).postln;

		if(focus == 'Sun',
			{~innerSolarGrp.set(\gate, 1);},
			{~innerSolarGrp.set(\gate, 0);})

	},'/focus');
*/
OSCdef.new(\sun,
	{
		arg msg;
		//msg[1] = array of gates
		//msg[1][0] = all gate
		//msg[1][1] = mercury
		//msg[1][2] = venus
		//msg[1][3] = earth
		//msg[1][4] = mars

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

	},'/Sun');
)
(
OSCdef.new(\compare,
	{
		arg msg;
		//msg[1] = first planet to compare
		//msg[2] = second planet to compare

		("First: " + msg[1]).postln;
		("Second: " + msg[2]).postln;

		if(msg[1] == 1 && msg[2] == 1,
			{~mercuryGrp.set(\gate, 1);},
			{~mercuryGrp.set(\gate, 0);});

		if(msg[1] == 2 && msg[2] == 2,
			{~venusGrp.set(\gate, 1);},
			{~venusGrp.set(\gate, 0);});

		if(msg[1] == 3 && msg[2] == 3,
			{~earthGrp.set(\gate, 1);},
			{~earthGrp.set(\gate, 0);});

		if(msg[1] == 4 && msg[2] == 4,
			{~marsGrp.set(\gate, 1);},
			{~marsGrp.set(\gate, 0);});

		if(msg[1] == 5 && msg[2] == 5,
			{~jupiterGrp.set(\gate, 1);},
			{~jupiterGrp.set(\gate, 0);});

		if(msg[1] == 6 && msg[2] == 6,
			{~saturnGrp.set(\gate, 1);},
			{~saturnGrp.set(\gate, 0);});

		if(msg[1] == 7 && msg[2] == 7,
			{~uranusGrp.set(\gate, 1);},
			{~uranusGrp.set(\gate, 0);});

		if(msg[1] == 8 && msg[2] == 8,
			{~neptuneGrp.set(\gate, 1);},
			{~neptuneGrp.set(\gate, 0);});

	},'/Compare');
)

/*if(msg[1]<(~maxDist*~diameterMercury),
	{amp = (~minDist*~diameterMercury)/msg[1]},
	{amp = 0;};
);

if(msg[4]==1,
	{if(msg[1]<(~maxDist*~diameterMars),
		{~marsGrp.set(\gate, 1);},
		{~marsGrp.set(\gate, 0);}
	);},
	{~marsGrp.set(\gate, 0);}
);
*/
/*
(
OSCdef.new(\jupiter,
	{
		arg msg;
		("earthDist:" + msg[1]).postln;
		if(msg[1]<~diameterEarth*10,
		   ~earth.set(\gate, 1),
		   ~earth.set(\gate, 0)
		)
		~earth.set(\amp, ~diameterEarth/msg[1]);
		~earth.set(\pan, msg[2]);
	},'/Jupiter'
    )
)
(
OSCdef.new(\saturn,
	{
		arg msg;
		("saturn:" + msg[1]).postln;
		//func
	},'/Saturn'
    )
)
(
OSCdef.new(\uranus,
	{
		arg msg;
		("saturn:" + msg[1]).postln;
		//func
	},'/Uranus'
    )
)
(
OSCdef.new(\neptune,
	{
		arg msg;
		("neptune:" + msg[1]).postln;
		//func
	},'/Neptune'
    )
)
*/