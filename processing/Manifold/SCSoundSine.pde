/*

 (
 SynthDef(\sine, { |outbus = 0, amp = 0.5, freq = 440, pan = 0|
 var data;
 freq = Lag.kr(freq, 0.1);
 data = SinOsc.ar(freq, 0, amp);
 Out.ar(outbus, Pan2.ar(data, pan));
 }).store;
 )
 
 */

class SCSoundSine extends SCSound {

  SCSoundSine(String name, ControlP5 cp5, int left, int top) {
    super(name, "sine", cp5, left, top);
    // println("sine: left" + left);
    addFreq();
    addAmp();
    addPan();

    initAllProperties();
  }

  void addFreq() {
    String name = "freq";
    float limitMax = 700;
    float limitMin = 60;
    float maxVal = 100; 
    float minVal = 60; 
    float value = 80;
    addProperty(name, limitMax, limitMin, maxVal, minVal, value, 0);
  }
  
  int getRight() {
    // println (name + " called getRight on scs");
    return left + 120;
  }
  
}

