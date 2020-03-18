NetAddr.langPort;
NetAddr.localAddr;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = time (days/s)
//msg[4] = GUI-gate array
	//msg[4][0] = Planet-gate
	//msg[4][1] = Size/day-gate
	//msg[4][2] = Gravity-gate
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

		if(msg[4][1]==1,
			{~mercuryP.set(\gate, 1);},
			{~mercuryP.set(\gate, 0);});

		if(msg[4][2]==1,
			{~mercuryG.set(\gate, 1);},
			{~mercuryG.set(\gate, 0);});

		if(msg[4][3]==1,
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

		if(msg[4][1]==1,
			{~venusP.set(\gate, 1);},
			{~venusP.set(\gate, 0);});

		if(msg[4][2]==1,
			{~venusG.set(\gate, 1);},
			{~venusG.set(\gate, 0);});

		if(msg[4][3]==1,
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

		if(msg[4][1]==1,
			{~earthP.set(\gate, 1);},
			{~earthP.set(\gate, 0);});

		if(msg[4][2]==1,
			{~earthG.set(\gate, 1);},
			{~earthG.set(\gate, 0);});

		if(msg[4][3]==1,
			{~earthW.set(\gate, 1);},
			{~earthW.set(\gate, 0);});

		if(msg[4][4]==1,
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

		if(msg[4][1]==1,
			{~marsP.set(\gate, 1);},
			{~marsP.set(\gate, 0);});

		if(msg[4][2]==1,
			{~marsG.set(\gate, 1);},
			{~marsG.set(\gate, 0);});

		if(msg[4][3]==1,
			{~marsW.set(\gate, 1);},
			{~marsW.set(\gate, 0);});

		if(msg[4][4]==1,
			{~phobosP.set(\gate, 1);
			 ~deimosP.set(\gate, 1);
			},
			{~phobosP.set(\gate, 1);
			 ~deimosP.set(\gate, 1);});

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

OSCdef.new(\focus,
	{
		arg msg;
		var focus = msg[1];
		("Focus:" + msg[1]).postln;

		if(focus == 'Sun',
			{~innerSolarGrp.set(\gate, 1);},
			{~innerSolarGrp.set(\gate, 0);}
		)

	},'/focus');
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
OSCdef.new(\sun,
	{
		arg msg;
		//msg[1] = focusgate
		//msg[2] = focus
		//msg[3] = planetgate
		("Focus:" + msg[1]).postln;

		if(msg[1]==1,
		{if(msg[2] == 'Sun',
			{~innerSolarGrp.set(\gate, 1);},
			{~innerSolarGrp.set(\gate, 0);}
		)},
			{});

		if(msg[3]==1,
			{~mercuryGrp.set(\gate, 1);},
			{~mercuryGrp.set(\gate, 0);}
		);
		if(msg[4]==1,
			{~venusGrp.set(\gate, 1);},
			{~venusGrp.set(\gate, 0);}
		);
		if(msg[5]==1,
			{~earthGrp.set(\gate, 1);},
			{~earthGrp.set(\gate, 0);}
		);
		if(msg[6]==1,
			{~marsGrp.set(\gate, 1);},
			{~marsGrp.set(\gate, 0);}
		);

	},'/sun');
)*/

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