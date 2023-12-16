#include <ESP8266WebServer.h>

const char* ssid     = "ESP8266 Access Point";         // The SSID (name) of the Wi-Fi network you want to connect to
const char* password = "0123456789";// The password of the Wi-Fi network
ESP8266WebServer server(80);
int count = 0;
int layout  ;
boolean serial_av = false;
boolean start_waiting = false;
int score1 = -1000;
int score2 = -2000;
int turn = -1;
int x = 0;
///////////////////////////////
void handleCell1(){
  layout =  1;
  count = count + 1;
  Serial.write("1");
  server.send(201);
  delay(2000);
}
void handleCell2(){
  layout =  2;
  count = count + 1;
    Serial.write("2");
  server.send(202);
  delay(2000);
}
void handleCell3(){
  layout =  3;
  count = count + 1;
    Serial.write("3");
  server.send(203);
  delay(2000);
}
void handleCell4(){
  layout =  4;
  count = count + 1;
    Serial.write("4");
  server.send(204);
  delay(2000);
}
void handleCell5(){
  layout =  5;
  count = count + 1;
    Serial.write("5");
  server.send(205);
  delay(2000);
}
void handleCell6(){
  layout =  6;
  count = count + 1;
    Serial.write("6");
  server.send(206);
  delay(2000);
}
void handleCell7(){
  layout =  7;
  count = count + 1;
    Serial.write("7");
  server.send(207);
  delay(2000);
}
void handleCell8(){
  layout =  8;
  count = count + 1;
    Serial.write("8");
  server.send(208);
  delay(2000);
}
void handleCell9(){
  layout =  9;
  count = count + 1;
    Serial.write("9");
  server.send(209);
  delay(2000);
}
void handleCell10(){
  layout =  10;
  count = count + 1;
    Serial.write("10");
  server.send(210);
  delay(2000);
}
void handleCell11(){
  layout =  11;
  count = count + 1;
    Serial.write("11");
  server.send(211);
  delay(2000);
}
void handleCell12(){
  layout =  12;
  count = count + 1;
  Serial.write("12");
  server.send(212);
  delay(2000);
}
void handleCell13(){
  layout =  13;
  count = count + 1;
  Serial.write("13");
  server.send(213);
  delay(2000);
}
void handleCell14(){
  layout =  14;
  count = count + 1;
  Serial.write("14");
  server.send(214);
  delay(2000);
}
void handleWaiting(){
  if(start_waiting and count == 5){
    Serial.println("from wifi : done wating...");
      server.send(500);
      delay(1000);
  }else{
      server.send(501);
      delay(1000);
  }

}
//start with #
void handleScore0(){
  //Serial.println("handle 0");
  if(turn == 0){
    Serial.println("sending score 1 : " + String(score1+200));
    server.send(score1+200);
    turn = -1;
  }else{
    server.send(199);
    turn = -1;
  }
}
//start with ##
void handleScore1(){
  //Serial.println("handle 1");
  if(turn == 1){
    Serial.println("sending score 2 : " + String(score2+200));
    server.send(score2+200);
    turn = -1;
  }else{
    server.send(199);
    turn = -1;
  }
}
//////////////////////////////
void getScore(char tmp[3]){
  int start = 1;
  if(tmp[1] == '#'){
    start = 2;
  }
  int s = tmp[2]-'0';
  //Serial.println("WIFI got score 1 : " + String(s));
  if(start == 1){
    Serial.println("calc 1 : got " + String(s));
    score1 = s;
    score2= -2000;
    turn = 0;
  }else{
    Serial.println("calc 2 : got " + String(s));
    score2 = s;
    score1= -1000;
    turn = 1;
  }
}
//////////////////////////////
void setup() {
  count = 0;
  layout = 100;
  Serial.begin(9600);
  delay(15);
  WiFi.disconnect();
  //WiFi.mode(WIFI_STA);
  WiFi.softAP(ssid, password); 
  // handle each cell
  server.on("/1",handleCell1);
  server.on("/2",handleCell2);
  server.on("/3",handleCell3);
  server.on("/4",handleCell4);
  server.on("/5",handleCell5);
  server.on("/6",handleCell6);
  server.on("/7",handleCell7);
  server.on("/8",handleCell8);
  server.on("/9",handleCell9);
  server.on("/10",handleCell10);
  server.on("/11",handleCell11);
  server.on("/12",handleCell12);
  server.on("/13",handleCell13);
  server.on("/14",handleCell14);
  server.on("/*",handleWaiting);
  server.on("/x0",handleScore0);
  server.on("/x1",handleScore1);
  // open the server
  server.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  server.handleClient();
   delay(500);
   char response[3] ;
   boolean valid = false;
   serial_av = Serial.available();
   while(serial_av){
       Serial.readBytes(response,3);
      valid = true;
      //Serial.println("wIFI got : " + String(response[0]));
      if(valid){
        serial_av = false;
        
        if(response[0] == 'd'){
          Serial.println("from wifi got done");
           start_waiting = true;
        }
        if(response[0] == '#'){
          Serial.println("got score " + String(x));
          x = x + 1;
          getScore(response);
        }
      }else{
        serial_av = Serial.available();
      }
    }
  }
