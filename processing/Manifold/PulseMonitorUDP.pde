import hypermedia.net.*;

class PulseMonitorUDP extends PulseMonitor {

  UDP udp;
  String inStr = "";

  PulseMonitorUDP(String name, PApplet p5, UDP udp) {
    super(name);
    this.udp = udp;
  }

  void step() {
    requestValue();
    super.step();
  }

  void requestValue() {
    String ip       = "192.168.1.11";  // the remote IP address
    int port        = 8888;    // the destination port
    udp.send("0", ip, port );   // the message to send
  }
  


}

// this function needs to be in applet scope

String inStr = "";

void receive( byte[] data ) {
  for (int i=0; i < data.length; i++) {
    if (char(data[i]) == '\n') {
      pulse.parseReceivedData(inStr);
      inStr = "";
    } else {
      inStr = inStr + char(data[i]);
    }
  }
  
  }

