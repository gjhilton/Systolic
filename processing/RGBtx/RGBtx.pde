import hypermedia.net.*;

UDP udp;
PImage img;

void setup() {
  size(500, 500);
  background(0);
  drawSpectrum();
  udp = new UDP( this, 6000 );
  udp.listen( true );
  frameRate(10);
}

void drawSpectrum(){
  img = loadImage("spectrum.png"); 
  image(img, 0, 0, width, height);
}

void syncColour(){
  color targetColor = get(mouseX, mouseY);
  int r = int(red(targetColor));
  int g = int(green(targetColor));
  int b = int(blue(targetColor));
  sendColour(r,g,b);
}

void mouseReleased() {
   syncColour();
}
 
void sendColour(int r, int g, int b){
  if (r==255) r = 254;
  if (g==255) g = 254;
  if (b==255) b = 254;
  String colorString = r + "," + g + "," + b;
  String ip       = "192.168.1.10";  // the remote IP address
  int port        = 12345;    // the destination port

 // udp.send(colorString, ip, port );   // the message to send
 udp.send(colorString, ip, port );
}

void draw(){
    syncColour();
}

