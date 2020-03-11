NetAddr.langPort;
NetAddr.localAddr;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = time (days/s)
//msg[4] = 1st moon
//msg[5] = 2nd moon

(
OSCdef.new(\mercury,
	{
		arg msg;
		var ampMercury = (3*~diameterMercury)/msg[1];

		("mercuryDist:" + msg[1]);

		if(msg[1]<(20*~diameterMercury),
			{~mercuryP.set(\gate, 1);
			 ~mercuryG.set(\gate, 1);
			},
			{~mercuryP.set(\gate, 0);
			 ~mercuryG.set(\gate, 0);});

		if(ampMercury>1.0,
			{ampMercury = 1.0},
			{ampMercury = (3*~diameterMercury)/msg[1]});

		~mercuryP.set(\amp2, ampMercury);
		~mercuryG.set(\amp2, ampMercury);

		//~mercuryP.set(\reverb, 1-clampedAmp);

		~posMercury = -1*(msg[2]/pi);

		~mercuryP.set(\pan, ~posMercury);
		~mercuryG.set(\pan, ~posMercury);

		~mercuryS.set(\pan, ~posMercury);
		~mercuryPoof.set(\pan, ~posMercury);

	},'/Mercury');

OSCdef.new(\venus,
	{
		arg msg;
		var ampVenus = (3*~diameterVenus)/msg[1];
		("venusDist:" + msg[1]);
		if(msg[1]<(20*~diameterVenus),
			{~venusP.set(\gate, 1);
			 ~venusG.set(\gate, 1);
			 ~venusW.set(\gate, 1);
			},
			{~venusP.set(\gate, 0);
			 ~venusG.set(\gate, 0);
			 ~venusW.set(\gate, 0);}
		);
		if(ampVenus>1.0,
			{ampVenus = 1.0},
			{ampVenus = (3*~diameterVenus)/msg[1]});

		~venusP.set(\amp2, ampVenus);
		~venusG.set(\amp2, ampVenus);
		~venusW.set(\amp2, ampVenus);

		//~venusP.set(\reverb, 1-clampedAmp);

		~posVenus = -1*(msg[2]/pi);

		~venusP.set(\pan, ~posVenus);
		~venusG.set(\pan, ~posVenus);
		~venusW.set(\pan, ~posVenus);

		~venusS.set(\pan, ~posVenus);
		~venusPoof.set(\pan, ~posVenus);

	},'/Venus');

OSCdef.new(\earth,
	{
		arg msg;
		var ampEarth = (10*~diameterEarth)/msg[1];
		("earthAngle:" + msg[2]).postln;
		if(msg[1]<(100*~diameterEarth),
			{~earthP.set(\gate, 1);
			 ~earthG.set(\gate, 1);
			 ~earthW.set(\gate, 1);
			  ~moonP.set(\gate, 1);
			},
			{~earthP.set(\gate, 0);
			 ~earthG.set(\gate, 0);
			 ~earthW.set(\gate, 0);
			  ~moonP.set(\gate, 0);}
		);
		if(ampEarth>1.0,
			{ampEarth = 1.0},
			{ampEarth = (10*~diameterEarth)/msg[1]});

		~earthP.set(\amp2, ampEarth);
		~earthG.set(\amp2, ampEarth);
		~earthW.set(\amp2, ampEarth);
		~earthP.set(\amp2, ampEarth);
		~moonP.set(\amp2, ampEarth);

		//~earthP.set(\reverb, 1-clampedAmp);

		~posEarth = -1*(msg[2]/pi);
		~posMoon = -1*(msg[4]/pi);

		~earthP.set(\pan, ~posEarth);
		~earthG.set(\pan, ~posEarth);
		~earthW.set(\pan, ~posEarth);

		~moonP.set(\pan, ~posMoon);

		~earthS.set(\pan, ~posEarth);
		~earthPoof.set(\pan, ~posEarth);

	},'/Earth');

OSCdef.new(\mars,
	{
		arg msg;
		var ampMars = (3*~diameterMars)/msg[1];
		("marsDist:" + msg[1]);
		if(msg[1]<(20*~diameterMars),
			{~marsP.set(\gate, 1);
			 ~marsG.set(\gate, 1);
			 ~marsW.set(\gate, 1);
			 ~phobosP.set(\gate, 1);
		 	 ~deimosP.set(\gate, 1);
			},
			{~marsP.set(\gate, 0);
			 ~marsG.set(\gate, 0);
			 ~marsW.set(\gate, 0);
			 ~phobosP.set(\gate, 0);
		 	 ~deimosP.set(\gate, 0);}
		);
		if(ampMars>1.0,
			{ampMars = 1.0},
			{ampMars = (3*~diameterMars)/msg[1]});

		~marsP.set(\amp2, ampMars);
		~marsG.set(\amp2, ampMars);
		~marsW.set(\amp2, ampMars);
		~phobosP.set(\amp2, ampMars);
		~deimosP.set(\amp2, ampMars);

		//~marsP.set(\reverb, 1-clampedAmp);

		~posMars = -1*(msg[2]/pi);
		~posPhobos = -1*(msg[4]/pi);
		~posDeimos = -1*(msg[5]/pi);

		~marsP.set(\pan, ~posMars);
		~marsG.set(\pan, ~posMars);
		~marsW.set(\pan, ~posMars);
		~phobosP.set(\pan, ~posPhobos);
		~deimosP.set(\pan, ~posDeimos);

		~marsS.set(\pan, ~posMars);
		~marsPoof.set(\pan, ~posMars);

	},'/Mars');

OSCdef.new(\focus,
	{
		arg msg;
		var focus = msg[1];
		("Focus:" + msg[1]).postln;


		if(focus == 'Sun',
			{~mercuryPoof.set(\gate, 1);
			 ~venusPoof.set(\gate, 1);
			 ~earthPoof.set(\gate, 1);
			 ~marsPoof.set(\gate, 1);

			},
			{~mercuryPoof.set(\gate, 0);
			 ~venusPoof.set(\gate, 0);
			 ~earthPoof.set(\gate, 0);
			 ~marsPoof.set(\gate, 0);
			}
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