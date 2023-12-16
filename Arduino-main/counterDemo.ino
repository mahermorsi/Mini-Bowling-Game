
//for reading from
//////////////////////
int Pins[] = {36,37,38,39,40,41,42,43,44,45,46,47,48,49}; 
const int len = 14;
byte Pstatus[len+1]  = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};
//set up to 0
int start_counting = 1;
const int StepX = 2;
const int DirX = 5;
boolean rec = false;
//clean up for the next round/shoot
void Broom(){
  digitalWrite(DirX,HIGH);
  delay(1000); // delay for 1 second
   for(int x = 0; x<70; x++) { // loop for 200 steps
    digitalWrite(StepX,HIGH);
    delay(25);
    digitalWrite(StepX,LOW); 
    delay(15);
   }
  delay(500);
  digitalWrite(DirX,LOW);
  delay(1000); // delay for 1 second
   for(int x = 0; x<70; x++) { // loop for 200 steps
    digitalWrite(StepX,HIGH);
    delay(25);
    digitalWrite(StepX,LOW); 
    delay(15);
   }
  delay(1000);
}
void cleanUp(){
  for (int i = 0; i < len; i++){
    Pstatus[i] = 1;
  }
  Pstatus[len] = 0;
}
//
void setup() {
  for (int i = 0; i < len; i++){
    pinMode(Pins[i], INPUT);
  }
  pinMode(StepX,OUTPUT);
  pinMode(DirX,OUTPUT);
  Serial.begin(9600);
  Serial1.begin(9600);

}

void loop() {
 while(Serial1.available()){
  String response  = Seria1.readString();
  if(response == "start"){
    rec = true;
  }
  if (rec){
    for (int i = 0; i < len; i++){
          Pstatus[i] = digitalRead(Pins[i]);
        }
    //start count to calc the score 
      delay(5000);
      Broom();    
      rec = false;
  }
 }
}
