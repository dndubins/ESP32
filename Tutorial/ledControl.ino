//ESP32 Bluetooth sketch
//Adapted from: Evandro Copercini - 2018

#include "BluetoothSerial.h"

String device_name = "my_ESP32_device";

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define ledPin 26 // led connected to GPIO26
#define swPin 25   // momentary switch connected to GPIO25
#define analogPin 33 // to take analog reading (0-4095 divs = 0-3.3V)

BluetoothSerial SerialBT;

void setup() {
  pinMode(ledPin,OUTPUT); // set ledPin to output mode
  pinMode(swPin,INPUT_PULLUP); // set swPin to input pullup mode
  Serial.begin(115200);               // start the serial monitor
  SerialBT.begin(device_name); // Bluetooth device name
  Serial.println("Device started. Ready to pair.");
}

void loop() {
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }
  if (SerialBT.available()) {
    byte BTdata=SerialBT.read();
    if(BTdata=='1'){
      digitalWrite(ledPin,HIGH);
      SerialBT.println("LED ON");
    }else if(BTdata=='0'){
      digitalWrite(ledPin,LOW);
      SerialBT.println("LED OFF");
    }
    Serial.println(BTdata); // parrot the value to the Serial monitor
  }
  if(digitalRead(swPin)==LOW){   // if button pushed
    int reading=analogRead(analogPin);
    SerialBT.println(reading);
    Serial.print(reading);
    delay(500);
  }
  delay(20);
}
