#include <SoftwareSerial.h>
#include <DFRobot_DHT11.h>

#define BT_RXD 2
#define BT_TXD 3
#define POT 0
int temp = 0;
int humi = 0;
#define DHT11_PIN 10


DFRobot_DHT11 DHT;
SoftwareSerial bluetooth(BT_RXD, BT_TXD);   



void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  bluetooth.begin(9600);
}

void loop() {
 
  DHT.read(DHT11_PIN);

  Serial.print("temp:");
  temp = DHT.temperature;
  Serial.println(DHT.temperature);
  bluetooth.println(temp);

  Serial.print("humi:");
  humi = DHT.humidity;
  Serial.println(humi);
  bluetooth.println(humi);

  delay(10000);
  

}
