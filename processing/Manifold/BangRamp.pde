class BangRamp extends GUIDevice {

  Controller decayKnob;
  
  BangRamp(String name, ControlP5 cp5, int left, int top) {
    super(name, cp5, left, top);
    initGUI(cp5);
  }

  void bang(Device sender) {
    super.bang(sender);
    // println("Bangramper!");
  }
  
  void initGUI(ControlP5 cp5){
   decayKnob = cp5.addKnob("decay")
               .setRange(0,255)
               .setValue(20)
               .setPosition(left,top)
               .setRadius(32)
               .setDragDirection(Knob.VERTICAL)
               ;
  }
  
}

