import processing.net.*;
import oscP5.*;
import netP5.*;
import controlP5.*;
import supercollider.*;
import java.util.ArrayList;

PulseMonitor pulse;
WifiColourUDP costume;
BangRamp bangramp;
Wavescope scope;
ControlP5 cp5;
SCSound sine, sineb, bass, bassb;
UDP udp;
ArrayList<SCSound> sounds = new ArrayList<SCSound>();

int nextAvailableX = 0;

final int BACKGROUND_COLOUR = 36;
final int BAUDRATE = 115200;
final int FRAMERATE = 100;
final int PADDING = 10;
final int HEIGHT = 630;
final int WIDTH = 1350;
// final String SENSOR_IP = "127.0.0.1";
//final int SENSOR_PORT = 12345;
//final String SENSOR_IP = "192.168.1.11";
//final int SENSOR_PORT = 10002;
final boolean USE_SERIAL_SENSOR = false;
final boolean USE_AUDIO = true;

void setup() {

  // GUI
  frameRate(FRAMERATE);
  size(WIDTH, HEIGHT);
  cp5 = new ControlP5(this);
  nextAvailableX = PADDING; 
  int y = PADDING * 2;

  // input devices
  if (USE_SERIAL_SENSOR) {
    pulse = new PulseMonitorSerial("pulse", this, BAUDRATE);
  } 
  else {
    // pulse = new PulseMonitorWiFi("pulse", this, SENSOR_IP, SENSOR_PORT);
    udp = new UDP( this, 6000 );
    udp.listen( true );
    pulse = new PulseMonitorUDP("pulse", this,udp);
  }
  cp5.addTextlabel("pulselabel").setPosition(10, 6).setText(pulse.describe());

  bangramp = new BangRamp("ramp", cp5,10,545);
  wire(bangramp,pulse);

  // output devices
  scope = new Wavescope("scope", cp5, nextAvailableX, y);
  wireGUI(scope, pulse);

  // colour devices
  costume = new WifiColourUDP("costume", this, cp5, nextAvailableX, y);
  wireGUI(costume,pulse);

  // audio devices
  if (USE_AUDIO) {          
    
    sine = new SCSoundSine("Ssine", cp5, nextAvailableX, y);
    wireAudio(sine, pulse);
    
    sineb = new SCSoundSine("SineB", cp5, nextAvailableX, y);
    wireAudio(sineb, pulse);
    
    bass = new SCSoundAnalogueBass("Analogue bass", cp5, nextAvailableX, y);
    wireAudio(bass, pulse);
    
  }
}

void draw() {
  background(BACKGROUND_COLOUR);
  pulse.step();
  scope.draw();
  costume.draw();
}

void exit() {
  pulse.exit();
  if (USE_AUDIO) {
    for (SCSound s : sounds) {
      s.exit();
    }
  }
  super.exit();
}

// convenience methods for adding devices

void wire(Device child, Device parent) {
  parent.addChild(child);
}

void wireGUI(GUIDevice child, Device parent) {
  wire(child, parent);
  nextAvailableX = child.getRight() + PADDING; // HACK. side effect not great, but it's a convenient place to do it :(
}

void wireAudio(SCSound child, Device parent) {
  wireGUI(child, parent);
  sounds.add(child);
}

// hack hack hack - clientEvent & serialEvent only called in applet context so forward to Device...

void clientEvent(Client client) {
  if (pulse != null) { // sometimes pulse is null when this gets called as sketch launches, which causes crashery
    pulse.externalEvent(client);
  }
}

void serialEvent(Serial port) {
  pulse.externalEvent(port);
}

