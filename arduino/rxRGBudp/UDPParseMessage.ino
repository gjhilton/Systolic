// parse the received message

void serviceUDP(){
  int packetSize = Udp.parsePacket();
  if(packetSize) {   
    int len = Udp.read(packetBuffer,255);
    if (len >0) packetBuffer[len]=0;
    parse();

    Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    Udp.write(ReplyBuffer);
    Udp.endPacket();
   }
}

void parse(){
 String s = packetBuffer;
 int firstboundary, secondboundary; 
 firstboundary = s.indexOf(',');
 secondboundary = s.lastIndexOf(',');
  
 if ((firstboundary > 0) && (secondboundary >0) && (firstboundary+1 < secondboundary) && (secondboundary<(s.length()-1))){
    // woo 
    int r = s.substring(0,firstboundary).toInt();
    int g = s.substring(firstboundary+1,secondboundary).toInt();
    int b = s.substring(secondboundary+1).toInt();
    setRGB(r,g,b);
 }
 
}
