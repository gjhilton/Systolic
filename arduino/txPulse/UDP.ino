/////////////////////////////////////////////////////////////////////////////////////////////////
// NETWORK CONFIGURATION
////////////////////////////////////////////////////////////////////////////////////////////////

char ssid[] = "gabbatron"; 
char pass[] = "----------";
int keyIndex = 1;

/////////////////////////////////////////////////////////////////////////////////////////////////
// GLOBALS - WIFI
////////////////////////////////////////////////////////////////////////////////////////////////

int status = WL_IDLE_STATUS;
WiFiUDP Udp;
char packetBuffer[255];
char  ReplyBuffer[] = "ack";

/////////////////////////////////////////////////////////////////////////////////////////////////
// WIFI / UDP LIBRARY FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////

void connectToNetwork(){
  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present"); 
    // don't continue:
    while(true);
  } 
  
  WiFi.config(myStaticIP);
  
  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) { 
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid,1, pass);
  
    // wait 10 seconds for connection:
    delay(10000);
  } 
  Serial.println("Connected to wifi");
  printWifiStatus();
  
  Serial.print("\nListening on port ");
  Serial.println(myStaticIP);

  Udp.begin(listenPort);  
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}
