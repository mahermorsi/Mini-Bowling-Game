#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include <Servo.h>
#include "Wire.h"
Servo myservo;
Servo myservo2;
#define SPD 50
#define SERVO_PIN 9 // use pin 9 for servo control
#define SERVO2_PIN 6 // use pin 6 for servo control
double c = 90;
RF24 radio(7, 8); // CE, CSN
int data[3];

int buttonOld = 1;
int buttonNew;



int turn = 0;
//vars for wheel #1
#define in3  10
#define in4  1
#define inB  5
//vars for wheel #2
#define inA  3
#define in1  4
#define in2  2



const byte address[6] = "00001";



void setup() {
  radio.begin();
  radio.openReadingPipe(0, address);
  radio.setPALevel(RF24_PA_MIN);
  radio.startListening();
  Wire.begin();
  myservo.attach(SERVO_PIN);
  myservo.write(0);
  myservo2.attach(SERVO2_PIN);
  myservo2.write(0);


  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  pinMode(inB, OUTPUT);

  //wheel number 2
  pinMode(inA, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);





  Serial.begin(9600);
}

void loop() {
  if (radio.available())
    radio.read(&data, sizeof(data));

  buttonNew = data[2];
  if (buttonOld == 0 && buttonNew == 1) {
    Serial.println("************************************");
    turn = (turn + 1) % 4;
  }
  buttonOld = buttonNew;
  
  Serial.print(data[0]);
  Serial.print("                        ");
  Serial.print(data[1]);
  Serial.print("                        ");
  Serial.println(data[2]);

  Serial.println(turn);



  switch (turn) {

    case 1:
      {

        if (data[1] >= 150)  {
          digitalWrite(in4, HIGH);
          digitalWrite(in3, LOW);
          analogWrite(inB, SPD);

          digitalWrite(in2, HIGH);
          digitalWrite(in1, LOW);
          analogWrite(inA, SPD);

        }
        else if (data[1] <= 30)
        {
          digitalWrite(in3, HIGH);
          digitalWrite(in4, LOW);
          analogWrite(inB, SPD);

          digitalWrite(in1, HIGH);
          digitalWrite(in2, LOW);
          analogWrite(inA, SPD);
        }
        else
        {
          digitalWrite(in3, LOW);
          digitalWrite(in4, LOW);
          analogWrite(inB, 0);

          digitalWrite(in1, LOW);
          digitalWrite(in2, LOW);
          analogWrite(inA, 0);
        }
        delay(50);
        break;
      }
    case 2:
      {
        digitalWrite(in3, LOW);
        digitalWrite(in4, LOW);
        analogWrite(inB, 0);

        digitalWrite(in1, LOW);
        digitalWrite(in2, LOW);
        analogWrite(inA, 0);
        //Output to servo
        if (data[0] > 140)
          c += 2.5;
        else if (data[0] < 30)
          c -= 2.5;
        if (c > 180)
          c = 180;
        else if (c < 0)
          c = 0;
        myservo.write(c);


        break;
      }
    case 3:
      {
        myservo2.write(100);
        delay(500);
        myservo2.write(0);
        delay(100);
        turn = 0;
        break;
      }

    default:
      break;
  }







}
