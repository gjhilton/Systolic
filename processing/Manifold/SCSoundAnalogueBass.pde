/*

 (
 
 SynthDef(\moogbasstone2,{|out= 0 freq = 440 amp = 0.1 gate=1 attackTime= 0.2 fenvamount=0.5 cutoff= 1000 gain=2.0 pan=0.0|
 
 var osc, filter, env, filterenv;
 osc = Mix(Pulse.ar(freq.lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));
 
 filterenv = EnvGen.ar(Env.adsr(attackTime,0.0,1.0,0.2),gate,doneAction:2);
 filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)),gain);
 
 env = EnvGen.ar(Env.adsr(0.001,0.3,0.9,0.2),gate,doneAction:2);
 
 Out.ar(out,Pan2.ar((0.7*filter+(0.3*filter.distort))*env*amp,pan));
 
 }).add;
 
 )
 
 */

class SCSoundAnalogueBass extends SCSound {

  SCSoundAnalogueBass(String name, ControlP5 cp5, int left, int top) {
    super(name, "moogbasstone2", cp5, left, top);
    addFreq();
    addAmp();
    addCutoff();
    addEnv();    
    addPan();
    initAllProperties();
  }

  void addFreq() {
    String name = "freq";
    float limitMax = 300;
    float limitMin = 20;
    float maxVal = 100; 
    float minVal = 10; 
    float value = 60;
    addProperty(name, limitMax, limitMin, maxVal, minVal, value, 0);
  }

  void addCutoff() {
    String name = "cutoff";
    float limitMax = 2000;
    float limitMin = 20;
    float maxVal = 2000; 
    float minVal = 20; 
    float value = 100;
    addProperty(name, limitMax, limitMin, maxVal, minVal, value, 0);
  }

  void addEnv() {
    String name = "fenvamount";
    float limitMax = 1;
    float limitMin = 0;
    float maxVal = 1; 
    float minVal = 0; 
    float value = 0.5;
    addProperty(name, limitMax, limitMin, maxVal, minVal, value, 0);
  }

  void exit() {
    synth.free();
  }
}

