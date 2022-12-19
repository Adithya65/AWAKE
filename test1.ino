 #include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>


#include "MAX30105.h"
#include "spo2_algorithm.h"
#include <basicMPU6050.h>

MAX30105 particleSensor;
basicMPU6050<> imu;
//----------------------------------------

  String t;
#define ON_Board_LED 2  //--> Defining an On Board LED, used for indicators when the process of connecting to a wifi router

#define MAX_BRIGHTNESS 255

#if defined(__AVR_ATmega328P__) || defined(__AVR_ATmega168__)
//Arduino Uno doesn't have enough SRAM to store 100 samples of IR led data and red led data in 32-bit format
//To solve this problem, 16-bit MSB of the sampled data will be truncated. Samples become 16-bit data.
uint16_t irBuffer[100]; //infrared LED sensor data
uint16_t redBuffer[100];  //red LED sensor data
#else
uint32_t irBuffer[100]; //infrared LED sensor data
uint32_t redBuffer[100];  //red LED sensor data
#endif



//----------------------------------------SSID dan Password wifi mu gan.
const char* ssid = "Jio"; //--> Nama Wifi / SSID.
const char* password = "ninakenthina"; //-->  Password wifi .
//----------------------------------------

//----------------------------------------Host & httpsPort
const char* host = "script.google.com";
const int httpsPort = 443;
//----------------------------------------



WiFiClientSecure client; //--> Create a WiFiClientSecure object.

// Timers auxiliar variables
long now = millis();
long lastMeasure = 0;

String GAS_ID = "AKfycby7JjiRVJ3QsuDDULC4-HEscGteRSRfOIUS8YW-A5EQlfa35UoV20dXRzlH_0ZSmIry "; //--> spreadsheet script ID

int bufferLength; //data length
int32_t SPO2; //SPO2 value
int8_t validSPO2; //indicator to show if the SPO2 calculation is valid
int32_t heartRate; //heart rate value
int8_t validHeartRate; //indicator to show if the heart rate calculation is valid

byte pulseLED = 11; //Must be on PWM pin
byte readLED = 13; //Blinks with each data read

//============================================ void setup
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(500);
  

  WiFi.begin(ssid, password); //--> Connect to your WiFi router
  Serial.println("");
    
  pinMode(ON_Board_LED,OUTPUT); //--> On Board LED port Direction output
  digitalWrite(ON_Board_LED, HIGH); //--> 

  //----------------------------------------Wait for connection
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    //----------------------------------------Make the On Board Flashing LED on the process of connecting to the wifi router.
    digitalWrite(ON_Board_LED, LOW);
    delay(250);
    digitalWrite(ON_Board_LED, HIGH);
    delay(250);
    //----------------------------------------
  }
  //----------------------------------------
  digitalWrite(ON_Board_LED, HIGH); //--> Turn off the On Board LED when it is connected to the wifi router.
  //----------------------------------------If successfully connected to the wifi router, the IP Address that will be visited is displayed in the serial monitor
  Serial.println("");
  Serial.print("Successfully connected to : ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  //----------------------------------------

  client.setInsecure();

  imu.setup();
  
  // Start console
  Serial.begin(38400);
  Serial.begin(38400); // initialize serial communication at 38400 bits per second:

  pinMode(pulseLED, OUTPUT);
  pinMode(readLED, OUTPUT);

  // Initialize sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) //Use default I2C port, 400kHz speed
  {
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    while (1);
  }

  
  byte ledBrightness = 60; //Options: 0=Off to 255=50mA
  byte sampleAverage = 4; //Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 2; //Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  byte sampleRate = 100; //Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 411; //Options: 69, 118, 215, 411
  int adcRange = 4096; //Options: 2048, 4096, 8192, 16384

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); //Configure sensor with these settings
}
//==============================================================================
//============================================================================== void loop
void loop() {

  now = millis();
  // Publishes new temperature and humidity every 2 seconds
//  if (now - lastMeasure > 2000) {
 //   lastMeasure = now;
// }

bufferLength = 100; //buffer length of 100 stores 4 seconds of samples running at 25sps

  //read the first 100 samples, and determine the signal range
  for (byte i = 0 ; i < bufferLength ; i++)
  {
    while (particleSensor.available() == false) //do we have new data?
      particleSensor.check(); //Check the sensor for new data

    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    particleSensor.nextSample(); //We're finished with this sample so move to next sample

    Serial.print(F("red="));
    Serial.print(redBuffer[i], DEC);
    Serial.print(F(", ir="));
    Serial.println(irBuffer[i], DEC);
  }

  //calculate heart rate and SpO2 after first 100 samples (first 4 seconds of samples)
  maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &SPO2, &validSPO2, &heartRate, &validHeartRate);

  //Continuously taking samples from MAX30102.  Heart rate and SpO2 are calculated every 1 second
  while (1)
  {
    //dumping the first 25 sets of samples in the memory and shift the last 75 sets of samples to the top
    for (byte i = 10; i < 100; i++)
    {
      redBuffer[i - 10] = redBuffer[i];
      irBuffer[i - 10] = irBuffer[i];
    }

    //take 10 sets of samples before calculating the heart rate.
    for (byte i = 90; i < 100; i++)
    {
      while (particleSensor.available() == false) //do we have new data?
        particleSensor.check(); //Check the sensor for new data

      digitalWrite(readLED, !digitalRead(readLED)); //Blink onboard LED with every data read

      redBuffer[i] = particleSensor.getRed();
      irBuffer[i] = particleSensor.getIR();
      particleSensor.nextSample(); //We're finished with this sample so move to next sample

      //send samples and calculation result to terminal program through UART
      Serial.print(F("red="));
      Serial.print(redBuffer[i], DEC);
      Serial.print(F(", ir="));
      Serial.print(irBuffer[i], DEC);

      Serial.print(F(", HR="));
      Serial.print(heartRate, DEC);

      Serial.print(F(", HRvalid="));
      Serial.print(validHeartRate, DEC);

      Serial.print(F(", SPO2="));
      Serial.print(SPO2, DEC);

      Serial.print(F(", SPO2Valid="));
      Serial.println(validSPO2, DEC);

      //-- Raw output:
  // Accel
  Serial.print("Ax=");
  Serial.print( imu.rawAx() );
  Serial.print( " " );
  Serial.print("Ay=");
  Serial.print( imu.rawAy() );
  Serial.print( " " );
  Serial.print("Az=");
  Serial.print( imu.rawAz() );
  Serial.print( "    " );
  
  // Gyro
  Serial.print("Gx=");
  Serial.print( imu.rawGx() );
  Serial.print( " " );
  Serial.print("Gy=");
  Serial.print( imu.rawGy() );
  Serial.print( " " );
  Serial.print("Gz=");
  Serial.print( imu.rawGz() );
  Serial.print( "    " ); 
  
  // Temp
  Serial.print("Temp=");
  Serial.print( imu.rawTemp() );
  Serial.println();
    }

    //After gathering 10 new samples recalculate HR and SP02
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &SPO2, &validSPO2, &heartRate, &validHeartRate);
  }
  sendData1( heartRate, validHeartRate,  SPO2, validSPO2, imu.rawAx(), imu.rawAy(),imu.rawAz(), imu.rawGx(), imu.rawGy(), imu.rawGz(), imu.rawTemp() );
  
}
//*****
//==============================================================================

void sendData1(int heartRate,int validHeartRate,int SPO2,int validSPO2,float  rawAx1,float  rawAy1,float  rawAz1,float  rawGx1,float  rawGy1,float  rawGz1,float  rawTemp1) {
  //corrected
  Serial.println("==========");
  Serial.print("connecting to ");
  Serial.println(host);
  
  //----------------------------------------Connect to Google host
  if (!client.connect(host, httpsPort)) {
    Serial.println("connection failed");
    return;
  }
  //----------------------------------------

  //----------------------------------------Proses dan kirim data  


 
  String string_hr =  String (heartRate ); 
  String string_validhr =  String(validHeartRate ); 
  String string_spo2 =  String(SPO2 ); 
  String string_validspo2 =  String(validSPO2 ); 
  String string_Ax =  String(rawAx1 ); //corrected
  String string_Ay =  String( rawAy1);
  String string_Az =  String( rawAz1 );
  String string_Gx =  String( rawGx1 );
  String string_Gy =  String( rawGy1 );
  String string_Gz =  String( rawGz1 );
  String string_temp =  String(imu.rawTemp() );
  String url = "/macros/s/" + GAS_ID + "/exec?HR=" + string_hr + "&HR_Valid="+string_validhr + "&SPO2="+string_spo2 + "&HR_Valid="+string_validhr + "&SPO2_Valid="+string_validspo2 + "&Ax="+string_Ax + "&Ay="+string_Ay + "&Az="+string_Az + "&Gx="+string_Gx + "&Gy="+string_Gy + "&Gz="+string_Gx ; //  2 variables 
  Serial.print("requesting URL: ");
  Serial.println(url);

  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
         "Host: " + host + "\r\n" +
         "User-Agent: BuildFailureDetectorESP8266\r\n" +
         "Connection: close\r\n\r\n");

  Serial.println("request sent");
  //----------------------------------------

  //---------------------------------------
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      Serial.println("headers received");
      break;
    }
  }
  String line = client.readStringUntil('\n');
  if (line.startsWith("{\"state\":\"success\"")) {
    Serial.println("esp8266/Arduino CI successfull!");
  } else {
    Serial.println("esp8266/Arduino CI has failed");
  }
  Serial.print("reply was : ");
  Serial.println(line);
  Serial.println("closing connection");
  Serial.println("==========");
  Serial.println();
  //----------------------------------------
} 
//===============================================
