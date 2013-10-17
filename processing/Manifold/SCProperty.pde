class SCProperty {

  final static int MODE_MANUAL = 0;
  final static int MODE_BANG = 1;
  final static int MODE_WAVE = 2;

  int top, left, mode;
  String name;
  SCSound sound;
  float limitMax, limitMin, maxVal, minVal, value;
  ControlP5 cp5;
  Controller valueSlider, minbox, maxbox;
  RadioButton modeSelect;

  SCProperty(
  SCSound sound, 
  String name, 
  ControlP5 cp5, 
  int left, 
  int top, 
  float limitMax, 
  float limitMin, 
  float maxVal, 
  float minVal, 
  float value,
  int mode)
  {
    this.sound = sound;
    this.name = name;
    this.top = top;
    this.left = left;
    this.limitMax = limitMax;
    this.limitMin =  limitMin;
    this.maxVal =  maxVal;
    this.minVal =  minVal;
    this.value = value;
    this.cp5 = cp5;
    this.mode = mode;
    initControls();
  } 

  void newValue(float inputValue) {
    if (mode == MODE_WAVE) {
      float range = maxVal-minVal;
      float v = minVal + (range * inputValue);
      if (v != valueSlider.getValue()) {
        valueSlider.setValue(v);
        sendValue(); // FIXME probably redundant?
      }
    }
  }

  void sendValue() {
    float v =  valueSlider.getValue();
    sound.synth.set(name, v);
  }

  void initControls() {    

    float rangeSensitivity = 0.005 * (limitMax - limitMin);

    // max value box
    maxbox = cp5.addNumberbox(sound.name+ "_" + name+"_max")
      .setPosition(left, 5)
        .setSize(40, 14)
          .setRange(limitMin, limitMax)
            .setValue(maxVal)
              .setMultiplier(rangeSensitivity)
                .setDirection(Controller.HORIZONTAL)
                  .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent theEvent) {
                      if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
                        maxVal = maxbox.getValue();
                        //float min = minbox.getValue();
                        float v = valueSlider.getValue();
                        if (v > maxVal) valueSlider.setValue(maxVal);
                        //if (v < min) valueSlider.setValue(min);
                        valueSlider.setMax(maxVal);
                        //valueSlider.setMin(min);
                        valueSlider.getValueLabel().align(ControlP5.CENTER, ControlP5.TOP).setPaddingX(0);
                      }
                    }
                  }
    );
    maxbox.getCaptionLabel().hide();

    // main vertical slider
    valueSlider = cp5.addSlider(sound.name+ "_" + name+"_value")
      .setPosition(left, top)
        .setRange(minVal, maxVal)
          .setValue(value)
            .setSize(40, 512)
              .setSliderMode(Slider.FLEXIBLE)
                .setBroadcast(true);
    valueSlider.getValueLabel().align(ControlP5.CENTER, ControlP5.TOP).setPaddingX(0);
    valueSlider.getCaptionLabel().hide();
    valueSlider.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
          sendValue();
        }
      }
    }
    );

    // min value box
    minbox = cp5.addNumberbox(sound.name+ "_" + name+"_min")
      .setPosition(left, top + 512 + 1)
        .setSize(40, 14)
          .setRange(limitMin, limitMax)
            .setValue(minVal)
              .setMultiplier(rangeSensitivity)
                .setDirection(Controller.HORIZONTAL)
                  .addCallback(new CallbackListener() {
                    public void controlEvent(CallbackEvent theEvent) {
                      if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
                        //float max = maxbox.getValue();
                        minVal = minbox.getValue();
                        float v = valueSlider.getValue();
                        //if (v > max) valueSlider.setValue(max);
                        if (v < minVal) valueSlider.setValue(minVal);
                        //valueSlider.setMax(max);
                        valueSlider.setMin(minVal);
                        valueSlider.getValueLabel().align(ControlP5.CENTER, ControlP5.TOP).setPaddingX(0);
                      }
                    }
                  }
    );
    ;
    minbox.getCaptionLabel().setText(name).align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
;

    modeSelect = cp5.addRadioButton(sound.name+ "_" + name+"_mode")
        .setPosition(left, top + 542)
        .setSize(12, 12)
        .setItemsPerRow(5)
        .setSpacingColumn(2)
        .setNoneSelectedAllowed(false)
        .addItem(sound.name + "_" + name +"_automate0", MODE_MANUAL)
        .addItem(sound.name + "_" + name +"_automate1", MODE_BANG)
        .addItem(sound.name + "_" + name +"_automate2", MODE_WAVE)
        
        .activate(mode)
        ;

    for (Toggle t:modeSelect.getItems()) {
      t.captionLabel().hide();
      t.addCallback(new CallbackListener() {
         public void controlEvent(CallbackEvent theEvent) {
              if (theEvent.getAction()==ControlP5.ACTION_PRESSED) {
                   mode = (int(modeSelect.getValue()));
              }
         }
     });
    }
  }

  void randomise() {
    float r = maxVal - minVal;
    float v = minVal + random(r);
    valueSlider.setValue(v);
  }

  String getControlNameForProperty(String property, String suffix) {
    return sound.name + "_" + name + "_" + suffix;
  }

  int getRight() {
    return left + 41;
  }

  void bang (Device sender) {
    if (mode == MODE_BANG) randomise();
  }
}

