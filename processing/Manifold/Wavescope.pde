import processing.serial.*;

class Wavescope extends GUIDevice {

  final float SCALE_FACTOR = 1;
  final boolean DRAW_RAW = true;
  final boolean DRAW_NORMALISED = true;
  final boolean DRAW_BANG = true;
  final int MARGIN = 10;
  final int SCOPE_RHS = floor((MARGIN*2) + (HISTORY_SIZE * SCALE_FACTOR));
  final float ARBITRARY_RAW_DRAW_SCALE = 0.5; // scale the drawing by something, anything to fit it in the window

  color rawColour = color(255, 0, 0);

  Wavescope(String name, ControlP5 cp5, int left, int top) {
    super(name, cp5, left, top);
  }

  int getRight() {
    return left + HISTORY_SIZE;
  }

  int getBottom() {
    return top + HISTORY_SIZE;
  }

  void draw() {
    stroke(52, 52, 52);
    fill(0, 0, 0);
    rect(left, top, HISTORY_SIZE * SCALE_FACTOR, HISTORY_SIZE);
    noFill();

    if (DRAW_RAW) {
      stroke(250, 0, 0);
      beginShape();
      for (int x = 1; x < HISTORY_SIZE-1; x++) {    
        vertex((x*SCALE_FACTOR)+MARGIN, (2*MARGIN) + HISTORY_SIZE - ((parent.valueHistory[x]*ARBITRARY_RAW_DRAW_SCALE)));
      }
      endShape();
    }

    if (DRAW_NORMALISED) {
      stroke(52, 52, 52);
      beginShape();
      for (int x = 1; x < HISTORY_SIZE-1; x++) { 
        vertex((x*SCALE_FACTOR)+MARGIN, (2*MARGIN) + HISTORY_SIZE - (HISTORY_SIZE * parent.normalisedValueHistory[x]));
      }
      endShape();
    }
   
    if (DRAW_BANG) {
      stroke(255, 255, 255);
      for (int x = 1; x < HISTORY_SIZE-1; x++) {
        if  (parent.bangHistory[x] == true) {
          float xpos = (x*SCALE_FACTOR)+MARGIN;
          float ypos = (2*MARGIN);
          line(xpos, ypos, xpos, ypos + HISTORY_SIZE);
        }
      }
    }
  }
}

