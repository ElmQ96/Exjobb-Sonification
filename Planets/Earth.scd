(
~massEarth =  261.63;//C4
~rotationEarth = 1;
~invrotationEarth = 1;
~gravityEarth = 1;
~orbitEarth = 0.08333330167;

Synth.new(\wind, [\amp, 0.06]);
~earth = Synth.new(\mod, [
		\freq, ~massEarth,
		\rate, ~rotationEarth,
		\pan, 0,
		\reverb, 0.5]);
)