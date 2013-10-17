class PulseMonitor extends Device {

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // FRAME LOCKING
  /////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // if  FRAME_LOCKED == false, history only winds forward when a new value is received
  // - ie the display will be refreshed only at the speed values arrive
  // if  FRAME_LOCKED == true, history steps forward every frame
  // - ie the display will be refreshed at a constant rate regardless of the values that arrive
  //
  // eg if no new values arrive true will freeze, false will flatline
  //
  // nb neither affects the rate at which updates are dispatched
  
  final boolean FRAME_LOCKED = true; 

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // INSTANCE VARIABLES
  ////////////////////////////////////////////////////////////////////////////////////////////////
  
  int maxValue, minValue;
  boolean bangThisFrame = false;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // CONSTRUCTOR
  ////////////////////////////////////////////////////////////////////////////////////////////////

  PulseMonitor(String name) {
    super(name);
    resetMinMax();
    valueHistory = new int[HISTORY_SIZE];
    normalisedValueHistory = new float[HISTORY_SIZE];
    bangHistory = new boolean[HISTORY_SIZE];
    for (int i=0; i<HISTORY_SIZE; i++) {
      valueHistory[i] = 0;
      normalisedValueHistory[i] = 0;
      bangHistory[i] = false;
    }
  } 

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // CALLBACKS
  ////////////////////////////////////////////////////////////////////////////////////////////////
  
  // called every frame
  void step() {
    if (FRAME_LOCKED) windOnHistory();
  }

  // called when a new value arrives
  void update(int newValue) {
    value = newValue;
    normalisedValue = normalise(newValue);
    valueHistory[HISTORY_SIZE-1] = value;
    normalisedValueHistory[HISTORY_SIZE-1] = normalisedValue;
    newValue(this);
    if (!FRAME_LOCKED) windOnHistory();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // IMPLEMENTATION
  ////////////////////////////////////////////////////////////////////////////////////////////////

  void windOnHistory(){
    if (bangThisFrame) {
      bangThisFrame = false;
      bangHistory[HISTORY_SIZE-1] = true;
    } 
    else {
      bangHistory[HISTORY_SIZE-1] = false;
    }
    resetMinMax();
    for (int i = 0; i < HISTORY_SIZE-1; i++) {
      valueHistory[i] = valueHistory[i+1];
      normalisedValueHistory[i] = normalisedValueHistory[i+1];
      if (valueHistory[i] > maxValue) maxValue = valueHistory[i];
      if (valueHistory[i] < minValue) minValue = valueHistory[i];
      bangHistory[i] = bangHistory[i+1];
    }
  }

  void resetMinMax() {
    maxValue = 0;
    minValue = 1024; // arbitrary impossibly large value
  }

  void bang(Device sender) {
    bangHistory[HISTORY_SIZE-1] = true;
    bangThisFrame = true;
    super.bang(sender);
  }

  float normalise(int v) {
    float n = map(float(v), minValue, maxValue, 0.0f, 1.0f);
    n = constrain (n, 0.0f, 1.0f);
    return n;
  }

  void parseReceivedData(String inData) {
    /*
    if (inData.length() != 3) {
       println("invalid data: " + inData  + " " + inData.length());
       return;
    }
    */
   
    inData = trim(inData);

    if (inData.charAt(0) == 'S') {		// leading 'S' for sensor data
      inData = inData.substring(1);		// cut off the leading 'S'
      update(int(inData));		        // convert the string to usable int
      return;
    }

    if (inData.charAt(0) == 'B') {		// leading 'B' for BPM data
      inData = inData.substring(1);		// cut off the leading 'B'
      bang(this);
      return;
    }
  }
  
  String getFrameLock(){
     if (FRAME_LOCKED){
      return "Display updates every frame";
     } 
     return "Display updates on new value";
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // STUBS TO BE OVERRIDDEN
  ////////////////////////////////////////////////////////////////////////////////////////////////

  void externalEvent(Client client) {}
  void externalEvent(Serial port) {}
  String describe() {return "";}
  
}

