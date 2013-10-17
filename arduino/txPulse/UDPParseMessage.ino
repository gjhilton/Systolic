// parse the received message

void serviceUDP(){
  int packetSize = Udp.parsePacket();
  if(packetSize) {   
    int len = Udp.read(packetBuffer,255);
    if (len >0) packetBuffer[len]=0;

    Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    String s = "S";
    s += Signal;
    s += "\n";
    s.toCharArray(ReplyBuffer, 255);
    Udp.write(ReplyBuffer);
    Udp.endPacket();
    Serial.println(s);
   }
}
