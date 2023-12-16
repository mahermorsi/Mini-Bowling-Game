#include <SoftwareSerial.h>
#include <Servo.h>
// WIFI 
SoftwareSerial myserial(9,10);
boolean start_layout = false;
boolean shoot = true;
int layout[5] ;
int count;
//
// Layout 
Servo myservo ;
int angle = 0;
const int StepX = 2;
const int DirX = 5;
const int StepY = 3;
const int DirY = 6;
const int StepZ = 4;
const int DirZ = 7;
int turn = 0;
const int len=14;
byte Pstatus[len+1];
int second_shoot_layout[14] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
// maps from X,Y cells to X,Y Stepps
unsigned int x_stepps[14] = {0,0,0,0,0,10000,10000,10000,20000,20000,20000,30000,30000,30000};
unsigned int y_stepps[14] = {8550,8550+9450,8550+9450+9450,8550+9450+9450+9450,13325,13325+9550,13325+9550+9550,8550,8550+9450,8550+9450+9450,8550+9450+9450+9450,13325,13325+9550,13325+9550+9550};
int shoot_num = 0;
unsigned int WAITING = 30000;
//
void waitUntilShooting(){
  Serial.println("waiting to score");
  delay(WAITING);
  Serial.write("start");
  delay(5000);
  Serial.println(Serial.available());
  while(Serial.available()){
    //read the status
    Serial.println("x");
    Serial.readBytes(Pstatus,len+1);
    //first shoot
    for(int i = 0; i < len+1 ; i = i+1){
      Serial.print(String(Pstatus[i]) + ",");
    }
    Serial.println();
    if(Pstatus[len] == 1 and turn == 0){ 
      //count the score 
      delay(1000);
      Serial.println("got the score for the first shot");
      int hist[14] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
      for(int i = 0;i < 5;i = i+1){
        hist[layout[i]-1] = 1;
      }
      int score = 0;
      for(int i = 0;i < len;i = i+1){
        if(hist[i] == 1 and Pstatus[i] == 1){
          score = score + 1;
        }
        if(hist[i] == 1 and Pstatus[i] == 0){
          second_shoot_layout[i] = 1;
        } 
      }
      Serial.println("sending score to WIFI");
      Serial.println("score_num 1 is :" + String(score));
      //send score
      shoot_num += 1;
      char tmp[3] = {'#','@',char(score +'0')};
      myserial.write(tmp,3);
      delay(5000);
      turn = 1 - turn ;
      MakeLayout4SecondShoot();
    }
    //second shoot
    if(Pstatus[len] == 1 and turn == 1){
      
      delay(1000);
      Serial.println("got the score for the second shot");
      Serial.println("sending score to WIFI");
      int score = 0;
      for(int i = 0;i < len;i = i+1){
        if(second_shoot_layout[i] == 1 and Pstatus[i] == 1){
              score = score + 1;
           }
      }
      Serial.println("score_num 2 is :" + String(score));
      shoot_num += 1;
      char tmp[3] = {'#','#',char(score +'0')};
      myserial.write(tmp,3);
      delay(1000);
      turn = 1 - turn ;
      cleanUp();
    }
    
  }
}
// clean up - to restart the porccess once again
void cleanUp(){
  for(int i = 0;i < len;i = i+1){
      second_shoot_layout[i] = -1;
      Pstatus[i] = 0;
  }
  Pstatus[len] = 0;
  start_layout = true;
  Repeat();
}
void Repeat(){
  Serial.println("repeat : round num " + String(int(shoot_num /4)) +"is DONE!");
  if(shoot_num < 16){
    MakeLayout4FirstShoot();
    delay(1000);
    waitUntilShooting();
  }else{
    Serial.println("the game is done!");
    //need to reset
  }
}
// proccess each cell
//need to change to 10
void proccessNextCell(int cell_number){
  layout[count] = cell_number;
  count = count + 1;
  Serial.println("prcc next cell"+ String(cell_number));
  if(count == 5){
    start_layout = true;
  }
}
void ZandServoMotions(){
  //Z - down
  digitalWrite(DirZ,HIGH);
  delay(1000); // delay for 1 second
  for(int x = 0; x<130; x++) { // loop for 200 steps
    digitalWrite(StepZ,HIGH);
    delayMicroseconds(1800);
    digitalWrite(StepZ,LOW); 
    delayMicroseconds(1800);
  }
  //servo - open                                 
    myservo.write(180);           
             
  //Z - up
  digitalWrite(DirZ,LOW);
  delay(1000); // delay for 1 second
  for(int x = 0; x<130; x++) { // loop for 200 steps
    digitalWrite(StepZ,HIGH);
    delayMicroseconds(1200);
    digitalWrite(StepZ,LOW); 
    delayMicroseconds(1200);
  }
  // servo - close                               
    myservo.write(40);             
 
}
void getNewPin(){
  //servo open                              
    myservo.write(180);           
                     
  
  //Z down
  digitalWrite(DirZ,HIGH);
  delay(1000); // delay for 1 second
  for(int x = 0; x<135; x++) { // loop for 200 steps
    digitalWrite(StepZ,HIGH);
    delayMicroseconds(1200);
    digitalWrite(StepZ,LOW); 
    delayMicroseconds(1200);
  }
  // servo close 
                              
    myservo.write(40);                                   

  //Z up
  digitalWrite(DirZ,LOW);
  delay(1000); // delay for 1 second
  for(int x = 0; x<135; x++) { // loop for 200 steps
    digitalWrite(StepZ,HIGH);
    delayMicroseconds(1200);
    digitalWrite(StepZ,LOW); 
    delayMicroseconds(1200);
  } 
}
// dir == 1 => go
// dir == 0 => back
void XandYMotions(int dir,int cell_number){
  // Go code
  if(dir == 1){
    digitalWrite(DirY,LOW);
    delay(1000); // delay for 1 second
     for(unsigned int x = 0; x< y_stepps[cell_number]; x++) { // loop for 200 steps
      digitalWrite(StepY,HIGH);
      delayMicroseconds(500);
      digitalWrite(StepY,LOW); 
      delayMicroseconds(500);
     }
    digitalWrite(DirX,HIGH);
    delay(8000); // delay for 1 second
     for(unsigned int x = 0; x< x_stepps[cell_number]; x++) { // loop for 200 steps
      digitalWrite(StepX,HIGH);
      delayMicroseconds(500);
      digitalWrite(StepX,LOW); 
      delayMicroseconds(500);
     }
  }
  //Back code
  else if(dir == 0){
    digitalWrite(DirX,LOW);
    delay(1000); // delay for 1 second
     for(unsigned int x = 0; x< x_stepps[cell_number]; x++) { 
      digitalWrite(StepX,HIGH);
      delayMicroseconds(500);
      digitalWrite(StepX,LOW); 
      delayMicroseconds(500);
     }
    digitalWrite(DirY,HIGH);
    delay(1000); // delay for 1 second
     for(unsigned int x = 0; x<y_stepps[cell_number]; x++) { 
      digitalWrite(StepY,HIGH);
      delayMicroseconds(500);
      digitalWrite(StepY,LOW); 
      delayMicroseconds(500);
     }
  }
  else{Serial.println("ERROR : XandYMotions");}
}
// need to chage it
void MakeLayout4FirstShoot(){
  for(int i = 0;i < 5;i = i+1){
    Serial.println("making cell : " +String(layout[i])); 
    getNewPin();
    //go
    XandYMotions(1,layout[i]-1);
    ZandServoMotions();
    //back
    XandYMotions(0,layout[i]-1);  
  }
}
void MakeLayout4SecondShoot(){
  Serial.println("MakeLayout4SecondShoot , layout is :");
  for(int i = 13;i >= 0;i = i-1){
    if(second_shoot_layout[i] == 1){
      Serial.println("making cell : " + String(i));
        getNewPin();
        //go
        XandYMotions(1,i);
        ZandServoMotions();
        //back
        XandYMotions(0,i);
    }  
  }
  waitUntilShooting();
}
/////////////////////

void setup() {
  count = 0;
  myservo.attach(11);
  myservo.write(80); 
  Serial.begin(9600);
  myserial.begin(9600);
  delay(1000);
  pinMode(StepX,OUTPUT);
  pinMode(DirX,OUTPUT);
  pinMode(StepY,OUTPUT);
  pinMode(DirY,OUTPUT);
  pinMode(StepZ,OUTPUT);
  pinMode(DirZ,OUTPUT);
  //digitalWrite(DirZ,HIGH);

}

void loop() {

  // put your main code here, to run repeatedly:
  char x[3] = {'!','!','!'};
  String next_cell ;
  boolean valid_income = false;
  if(start_layout and shoot){
    Serial.println("done! , layout is:");
    shoot = false;
    MakeLayout4FirstShoot();
    x[0] = 'd';
    myserial.write(x,3);
    delay(1000);
    waitUntilShooting();
  }
  else{
    while(myserial.available() and shoot){
      next_cell = myserial.readString();
      valid_income = true;
     Serial.println("got from WIFI : " + next_cell);
      if(next_cell != "" and valid_income and next_cell.toInt() > 0 and next_cell.toInt() < 15){
        
        proccessNextCell(next_cell.toInt());
        x[0] = 'n';
        myserial.write(x,3);
        delay(1000);
      }
    }
  }
}
