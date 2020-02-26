s.boot;

NetAddr.langPort;
NetAddr.localAddr;

s.meter;

//msg[1] = distance (amp)
//msg[2] = angle (pan)
//msg[3] = Focus (gate)

(
OSCdef.new(\mercury,
	{
		arg msg;
		var clampedAmp = (3*~diameterMercury)/msg[1];
		("mercuryDist:" + msg[1]);
		if(msg[1]<(20*~diameterMercury),
			{~mercury.set(\gate, 1)},
			{~mercury.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterMercury)/msg[1]});
		~mercury.set(\amp, clampedAmp);
		~mercury.set(\reverb, 1-clampedAmp);
		~mercury.set(\pan, msg[2]);
	},'/Mercury'
    )
)
(
OSCdef.new(\venus,
	{
		arg msg;
		var clampedAmp = (3*~diameterVenus)/msg[1];
		("venusDist:" + msg[1]);
		if(msg[1]<(20*~diameterVenus),
			{~venus.set(\gate, 1)},
			{~venus.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterVenus)/msg[1]});
		~venus.set(\amp, clampedAmp);
		~venus.set(\reverb, 1-clampedAmp);
		~venus.set(\pan, msg[2]);
	},'/Venus'
    )
)
(
OSCdef.new(\earth,
	{
		arg msg;
		var clampedAmp = (3*~diameterEarth)/msg[1];
		("earthAngle:" + msg[2]).postln;
		if(msg[1]<(20*~diameterEarth),
			{~earth.set(\gate, 1)},
			{~earth.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterEarth)/msg[1]});
		~earth.set(\amp, clampedAmp);
		~earth.set(\reverb, 1-clampedAmp);
		~earth.set(\pan, msg[2]);

	},'/Earth'
    )
)
(
OSCdef.new(\mars,
	{
		arg msg;
		var clampedAmp = (3*~diameterMars)/msg[1];
		("marsDist:" + msg[1]);
		if(msg[1]<(20*~diameterMars),
			{~mars.set(\gate, 1)},
			{~mars.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterMars)/msg[1]});
		~mars.set(\amp, clampedAmp);
		~mars.set(\reverb, 1-clampedAmp);
		~mars.set(\pan, msg[2]);
	},'/Mars'
    )
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
(
OSCdef.new(\focus,
	{
		arg msg;
		//func
		var focus = msg[1];
		//("FOCUS:" + msg[1]).postln;
		//case
			//{ focus == 'Mercury' } { \no }
			//{ focus == 'Venus' } { \wrong }
			//{ focus == 'Earth } { \wrong }
			//{ focus == 'Mars' } { \wrong }
			//{ focus == 'Jupiter' } { \wrong }
			//{ focus == 'Saturn' } { \true }
			//{ focus == 'Uranus' } { \wrong }
			//{ focus == 'Neptune' } { \wrong }

		if(focus == 'Sun',
			{~mercuryS.set(\gate, 1);
			 ~venusS.set(\gate, 1);
			 ~earthS.set(\gate, 1);
			 ~marsS.set(\gate, 1);
			},
			{~mercuryS.set(\gate, 0);
			 ~venusS.set(\gate, 0);
			 ~earthS.set(\gate, 0);
			 ~marsS.set(\gate, 0);
			}
		)

	},'/focus'
    )
)