{Pan2.ar(Gendy2.ar(6,6,LFPulse.kr(100, 0, 0.4, 1.0), SinOsc.kr(30, 0, 0.5),mul:0.2), 0.0)}.play


(
	SynthDef(
		"electricity", {
			arg pulsefreq = 100, sinfreq = 30;
		    ~ad = LFPulse.kr(pulsefreq, 0, 0.4, 1.0);
		    ~dd = SinOsc.kr(sinfreq, 0, 0.5);
			Out.ar(0,Pan2.ar(Gendy2.ar(6, 6, ~ad, ~dd, mul:0.2), 0.0););
		}
	).add;
)







(
	SynthDef(
		"reverbnoise", {
			arg reverbdepth = 4;
			var s, z, y;
			Out.ar(
				0,
				s = Decay.ar(
					Dust.ar(0.6, 0.2), 0.15, PinkNoise.ar
				);
				z = DelayN.ar(s, 0.048);
				y = Mix.ar(
					CombL.ar(z, 0.1, LFNoise1.kr(Array.fill(6,{Rand(0,0.1)}), 0.04, 0.05), 15)
				);
				reverbdepth.do(
					{ y = AllpassN.ar(y, 0.050, [Rand(0,0.050),Rand(0,0.050)], 1)
				});
				s+y;
			);
		}
	).add;
)

~reverbnoise = Synth("reverbnoise");
~reverbnoise.set("reverbdepth",2);
~reverbnoise.set("reverbdepth",4);
~reverbnoise.free();

(
{
loop({
    play({
        var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));
        Pan2.ar(DynKlang.ar(`[ Array.rand(12, 200.0, 2000.0), 1, mod ]), 1.0.rand)
            * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.rand.wait;
})
}.fork;
)

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;

(
SynthDef('help-dynKlank', {|
    freqs (#[100, 200, 300, 400]),
    amps (#[1, 0.3, 0.2, 0.05]),
    rings (#[1, 1, 1, 2])|

    Out.ar(0, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)

a = Synth('help-dynKlank');



(
{
    var n;
    n=10;

    Resonz.ar(
    Mix.fill(n,{
    var freq, numcps;

    freq= rrand(50,560.3);
    numcps= rrand(2,20);
    Pan2.ar(Gendy2.ar(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq,
        1.0.rand, 1.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0,
        numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
    })
    ,MouseX.kr(100,2000), MouseY.kr(0.01,1.0), 0.3)
    ;
    }.play
)


{Pan2.ar(Gendy2.ar(6,6,LFPulse.kr(100, 0, 0.4, 1.0), SinOsc.kr(30, 0, 0.5),mul:0.2), 0.0)}.play

{Pan2.ar(Gendy1.ar)}.play

{Pan2.ar(Gendy1.ar(6,6,LFPulse.kr(100, 0, 0.4, 1.0), SinOsc.kr(30, 0, 0.5),mul:0.2), 0.0)}.play

(
{
Mix.fill(10,{
var freq;

freq= rrand(130,160.3);
Pan2.ar(SinOsc.ar(Gendy1.ar(6.rand,6.rand,SinOsc.kr(0.1,0,0.49,0.51),
    SinOsc.kr(0.13,0,0.49,0.51),freq ,freq, SinOsc.kr(0.17,0,0.49,0.51),
    SinOsc.kr(0.19,0,0.49,0.51), 12, 12, 200, 400), 0, 0.1), 1.0.rand2)
});
}.play
)

SynthDef("acid", {
		arg outBus=0, gate=1, pitch=50, amp=0.1;
		var env1, env2, out;
		pitch = Lag.kr(pitch, 0.12 * (1-Trig.kr(gate, 0.001)) * gate);
		env1 = EnvGen.ar(Env.new([0, 1.0, 0, 0], [0.001, 2.0, 0.04], [0, -4, -4], 2), gate, amp);
		env2 = EnvGen.ar(Env.adsr(0.001, 0.8, 0, 0.8, 70, -4), gate);
		out = LFPulse.ar(pitch.midicps, 0.0, 0.51, 2, -1);

		out = RLPF.ar(out, (pitch + env2).midicps, 0.3);
		out = out * env1;

		Out.ar(outBus, out.dup);
	}).send(s);

~acid = Synth("acid");
~acid.set(\pitch, 100);
~acid.set(\gate, 1);

(
s.waitForBoot({
    a = Scale.ionian;
	a = Scale.kijazKarKurd;
    p = Pbind(
        \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, \rest], inf),
        \scale, Pfunc({ a }, inf),
        \dur, 0.59
    );

    q = p.play;
})
)

a = Scale.kijazKarKurd;
