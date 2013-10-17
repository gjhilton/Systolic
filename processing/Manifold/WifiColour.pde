class WifiColour extends GUIDevice {

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // GRADIENT PRESETS
  ////////////////////////////////////////////////////////////////////////////////////////////////

  final String YELLOW = "solidyellow.png";
  final String RAINBOW = "rainbow.png";
  final String REDYELLOW = "redyellow.png";
  final String REDBLUE = "redblue.png";
  final String REDYELLOWRED = "redyellowred.png";
  final String GREEN2 = "primarygreen_flipped.png";
  final String GREEN = "primarygreen.png";
  final String BLUE = "blue.png";
  final String BLUES = "blues.png";
  final String BLUESR = "blues_reversed.png";

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // CONFIGURATION: NETWORK
  ////////////////////////////////////////////////////////////////////////////////////////////////

Client client;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // CONFIGURATION: APPEARANCE
  ////////////////////////////////////////////////////////////////////////////////////////////////

  final int GRADIENT_HEIGHT = 512;
  final int GRADIENT_WIDTH = 64;
  final int PADDING = 6;  
  final int FADER_SIZE = 10;
  final int TOTAL_WIDTH = (2 * GRADIENT_WIDTH) + PADDING;
  final int COLOURCHIP_HEIGHT = 50;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // INSTANCE VARIABLES
  ////////////////////////////////////////////////////////////////////////////////////////////////

  PImage LHSimg, RHSimg;
  Controller brightness, crossfader;
  color colour;

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // CONSTRUCTOR & LIFECYCLE
  ////////////////////////////////////////////////////////////////////////////////////////////////

  WifiColour(String name, PApplet p5,  ControlP5 cp5, int left, int top) {
    super(name, cp5, left, top);
    initControls(cp5);
    loadImages(BLUES, BLUESR);
    // client = new Client(p5, "192.168.1.10", 12345);
  }

  void draw() {
    image(LHSimg, left, top);
    image(RHSimg, left + GRADIENT_WIDTH + PADDING, top);
    drawColourChip();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // DRAWING & GEOMETRY
  ////////////////////////////////////////////////////////////////////////////////////////////////

int getRight(){
     return left + (3*PADDING) + (2*GRADIENT_WIDTH) + FADER_SIZE;
 }

  void loadImages(String lhsImage, String rhsImage) {
    LHSimg = loadImage(lhsImage);
    LHSimg.loadPixels();
    RHSimg = loadImage(rhsImage);
    RHSimg.loadPixels();
  }

  void drawColourChip() {
    noStroke();
    fill(colour);
    rect(left, top + GRADIENT_HEIGHT + FADER_SIZE + (2*PADDING), TOTAL_WIDTH, COLOURCHIP_HEIGHT);
  }
  
  void initControls(ControlP5 cp5){
    crossfader = cp5.addSlider("crossfader")
       .setPosition(left, top + GRADIENT_HEIGHT + PADDING )
       .setSize(TOTAL_WIDTH, FADER_SIZE)
       .setRange(0,1)
     ;
     crossfader.getValueLabel().hide();
     crossfader.getCaptionLabel().hide();
     
     brightness = cp5.addSlider("brighness")
       .setPosition(left + (PADDING*2) + (GRADIENT_WIDTH *2) , top)
       .setSize(FADER_SIZE, GRADIENT_HEIGHT)
       .setRange(0,1)
     ;
     brightness.getValueLabel().hide();
     brightness.getCaptionLabel().hide();
     brightness.setValue(1);
 }

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // COLOUR GENERATION
  ////////////////////////////////////////////////////////////////////////////////////////////////

  color getColourFrom (PImage img, float inputValue){
    int line = floor((1 - inputValue) * GRADIENT_HEIGHT);
    int y = 0;
    if (line >0) y = 1+ (GRADIENT_WIDTH * (line-1)); // this *sucks*, guy. use more brain.
    return img.pixels[y];
 }
  
 void updateColour(float inputValue){
    color lhs = getColourFrom(LHSimg,inputValue);
    color rhs = getColourFrom(RHSimg,inputValue);
    float mix = crossfader.getValue();
    float bright = brightness.getValue();
    
    float r = (red(lhs) * (1-mix)) + (red(rhs) * mix);
    r = r * bright;
    float g = (green(lhs) * (1-mix)) + (green(rhs) * mix);
    g = g * bright;
    float b = (blue(lhs) * (1-mix)) + (blue(rhs) * mix);
    b = b * bright;
    colour = color(r,g,b);
    
    // send to remote unit
    sendColour(floor(r),floor(g),floor(b));
 }
 
 void newValue(Device sender) {
      updateColour(sender.normalisedValue);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////
  // COMMUNICATIONS
  ////////////////////////////////////////////////////////////////////////////////////////////////
  
  void sendColour(int r, int g, int b){
  if (r==255) r = 254;
  if (g==255) g = 254;
  if (b==255) b = 254;
  String colorString = r + "," + g + "," + b + "\n";
  if (client!=null) client.write(colorString);
}
  
}

