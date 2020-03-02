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
			{~mercuryP.set(\gate, 1)},
			{~mercuryP.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterMercury)/msg[1]});
		~mercuryP.set(\amp, clampedAmp);
		~mercuryP.set(\reverb, 1-clampedAmp);

		~mercuryPos = -1*(msg[2]/pi);
		~mercuryP.set(\pan, ~mercuryPos);
		~mercuryS.set(\pan, ~mercuryPos);
		~mercuryPoof.set(\pan, ~mercuryPos);

	},'/Mercury'
    );


OSCdef.new(\venus,
	{
		arg msg;
		var clampedAmp = (3*~diameterVenus)/msg[1];
		("venusDist:" + msg[1]);
		if(msg[1]<(20*~diameterVenus),
			{~venusP.set(\gate, 1)},
			{~venusP.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterVenus)/msg[1]});
		~venusP.set(\amp, clampedAmp);
		~venusP.set(\reverb, 1-clampedAmp);

		~venusPos = -1*(msg[2]/pi);
		~venusP.set(\pan, ~venusPos);
		~venusS.set(\pan, ~venusPos);
		~venusPoof.set(\pan, ~venusPos);

	},'/Venus'
    );

OSCdef.new(\earth,
	{
		arg msg;
		var clampedAmp = (10*~diameterEarth)/msg[1];
		("earthAngle:" + msg[2]).postln;
		if(msg[1]<(100*~diameterEarth),
			{~earthP.set(\gate, 1)},
			{~earthP.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (10*~diameterEarth)/msg[1]});
		~earthP.set(\amp, clampedAmp);
		~earthP.set(\reverb, 1-clampedAmp);

		~earthPos = -1*(msg[2]/pi);
		~earthP.set(\pan, ~earthPos);
		~earthS.set(\pan, ~earthPos);
		~earthPoof.set(\pan, ~earthPos);

	},'/Earth'
    );

OSCdef.new(\mars,
	{
		arg msg;
		var clampedAmp = (3*~diameterMars)/msg[1];
		("marsDist:" + msg[1]);
		if(msg[1]<(20*~diameterMars),
			{~marsP.set(\gate, 1)},
			{~marsP.set(\gate, 0)}
		);
		if(clampedAmp>1.0,
			{clampedAmp = 1.0},
			{clampedAmp = (3*~diameterMars)/msg[1]});
		~marsP.set(\amp, clampedAmp);
		~marsP.set(\reverb, 1-clampedAmp);

		~marsPos = -1*(msg[2]/pi);
		~marsP.set(\pan, ~marsPos);
		~marsS.set(\pan, ~marsPos);
		~marsPoof.set(\pan, ~marsPos);

	},'/Mars'
    );

OSCdef.new(\focus,
	{
		arg msg;
		//func
		var focus = msg[1];
		("FOCUS:" + msg[1]).postln;
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

	},'/focus'
    );
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