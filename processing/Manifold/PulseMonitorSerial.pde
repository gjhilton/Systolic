import processing.serial.*;

class PulseMonitorSerial extends PulseMonitor{

        Serial port;
  
	PulseMonitorSerial(String name, PApplet p5,int baudrate){
		super(name);
		initPort(p5,baudrate);
	}
 
 	void initPort(PApplet p5, int baudrate){
		port = new Serial(p5, Serial.list()[0], baudrate);
		port.clear();
		port.bufferUntil('\n'); 
 	}
  
	void externalEvent(Serial port){ 
		String inData = port.readStringUntil('\n');
		parseReceivedData(inData);
println(inData);
	}

        void exit(){
          port.stop();
        }
        
        String describe(){
          return ("Serial port at " + BAUDRATE + "kbs.       " + getFrameLock());
        }
}
