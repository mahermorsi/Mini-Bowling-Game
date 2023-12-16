#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include "Wire.h"
#include "I2Cdev.h"
RF24 radio(7, 8); // CE, CSN
const byte address[6] = "00001";
int data[3];
#include "MPU6050_6Axis_MotionApps20.h"
MPU6050 mpu;
int16_t ax, ay, az;
int16_t gx, gy, gz;
int buttonNew;
void(* resetFunc) (void) = 0;//declare reset function at address 0

#define SW_pin 4// digital pin connected to switch output

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Wire.begin();
  mpu.initialize();
  pinMode(SW_pin, INPUT);
  digitalWrite(SW_pin, HIGH);
  radio.begin();
  radio.openWritingPipe(address);
  radio.setPALevel(RF24_PA_MIN);
  radio.stopListening();
}

void loop() {
  // put your main code here, to run repeatedly:

  buttonNew = digitalRead(SW_pin);
    data[2] = buttonNew;

   
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  data[0] = map(ax, -17000 , 17000, 0, 179);
  data[1] = map(ay, -17000 , 17000, 0, 179);
  Serial.print(data[0]);
  Serial.print("                        ");
  Serial.print(data[1]);
  Serial.print("                        ");
  Serial.println(data[2]);

  radio.write(&data, sizeof(data));

  delay(10);

}
