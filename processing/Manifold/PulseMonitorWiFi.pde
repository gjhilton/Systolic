/*

   
   TOO CHUFFING SLOW :-(
   FAIL.


*/

class PulseMonitorWiFi extends PulseMonitor{
  
        Client client;
        String description;
  
	PulseMonitorWiFi(String name, PApplet p5, String ip, int port){
		super(name);
		client = new Client(p5, ip, port);
                description = ("WiFi port at " + ip + ":" + port + "        " + getFrameLock());
	}
 
	void externalEvent(Client client){
		if (client.available() > 0) {
			String inData = client.readStringUntil('\n');
			if (inData != null) parseReceivedData(inData);
		}
client.write("0"); // keep connection open
	}

void exit(){
   client.stop();
}

String describe(){
          return description;
        }

}
