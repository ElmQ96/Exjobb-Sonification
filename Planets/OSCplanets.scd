NetAddr.langPort;
NetAddr.localAddr;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = time (days/s)
//msg[4] = GUI-gate
//msg[5] = 1st moon
//msg[6] = 2nd moon

(
~minDist = 3;
~maxDist = 500;
)

(
OSCdef.new(\mercury,
	{
		arg msg;
		var ampMercury = (~minDist*~diameterMercury)/msg[1];


		if(msg[4]==1,
			{if(msg[1]<(~maxDist*~diameterMercury),
				{~mercuryGrp.set(\gate, 1);},
				{~mercuryGrp.set(\gate, 0););
			},
			{~mercuryGrp.set(\gate, 0);}
		);

		if(ampMercury>1.0,
			{ampMercury = 1.0},
			{ampMercury = (~minDist*~diameterMercury)/msg[1]});

		~mercuryGrp.set(\amp2, ampMercury);

		~posMercury = -1*(msg[2]/pi);

		~mercuryGrp.set(\pan, ~posMercury);
		~mercuryPoof.set(\pan, ~posMercury);

	},'/Mercury');

OSCdef.new(\venus,
	{
		arg msg;
		var ampVenus = (~minDist*~diameterVenus)/msg[1];

		if(msg[4]==1,
			{if(msg[1]<(~maxDist*~diameterVenus),
					{~venusGrp.set(\gate, 1);},
					{~venusGrp.set(\gate, 0);}
			);},
			{~venusGrp.set(\gate, 0);}
		);

		if(ampVenus>1.0,
			{ampVenus = 1.0},
			{ampVenus = (~minDist*~diameterVenus)/msg[1]});

		~venusGrp.set(\amp2, ampVenus);

		~posVenus = -1*(msg[2]/pi);

		~venusGrp.set(\pan, ~posVenus);
		~venusPoof.set(\pan, ~posVenus);

	},'/Venus');

OSCdef.new(\earth,
	{
		arg msg;

		var ampEarth = (~minDist*~diameterEarth)/msg[1];
		//("earthAngle:" + msg[2]).postln;

		if(msg[4]==1,
			{if(msg[1]<(~maxDist*~diameterEarth),
					{~earthGrp.set(\gate, 1);},
					{~earthGrp.set(\gate, 0);}
			);},
			{~earthGrp.set(\gate, 0);}
		);

		if(ampEarth>1.0,
			{ampEarth = 1.0},
			{ampEarth = ((~minDist*~diameterEarth)/msg[1])});

		~earthGrp.set(\amp2, ampEarth);

		~posEarth = -1*(msg[2]/pi);
		~posMoon = -1*(msg[5]/pi);

		~earthGrp.set(\pan, ~posEarth);
		~moonP.set(\pan, ~posMoon);
		~earthPoof.set(\pan, ~posEarth);

	},'/Earth');


OSCdef.new(\mars,
	{
		arg msg;
		var ampMars = (~minDist*~diameterMars)/msg[1];

		if(msg[4]==1,
			{if(msg[1]<(~maxDist*~diameterMars),
					{~marsGrp.set(\gate, 1);},
					{~marsGrp.set(\gate, 0);}
			);},
			{~marsGrp.set(\gate, 0);}
		);

		if(ampMars>1.0,
			{ampMars = 1.0},
			{ampMars = (~minDist*~diameterMars)/msg[1]});

		~marsGrp.set(\amp2, ampMars);

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