#include <Servo.h> 

Servo right;
Servo left;


const int SR = 4;
const int SL = 5;

const int SHIFT_SER =13;
const int SHIFT_RCLK =15;
const int SHIFT_SRCLK = 12;


int led=0;

const int L1 = 2;
const int L2 = 3;
const int L3 = 9;
const int L4 = 10;
//const int L5 = 12;
//const int L6 = 13;
const int L7 = 14;
//const int L8 = 15;

boolean registers[8];

void clearRegisters(){
  for(int i = 0 ;i <8; i++){
     registers[i] = LOW;
  }
} 


void writeRegisters(){
 
  digitalWrite(SHIFT_RCLK, LOW);
 
  for(int i = 8 - 1; i >=  0; i--){
    digitalWrite(SHIFT_SRCLK, LOW);
 
    int val = registers[i];
 
    digitalWrite(SHIFT_SER, val);
    digitalWrite(SHIFT_SRCLK, HIGH);
 
  }
  digitalWrite(SHIFT_RCLK, HIGH);
 
}

void setup() 
{ 
  Serial.begin(115200);
  Serial.print(" .... hello there !");
  pinMode(SHIFT_SER, OUTPUT);
  pinMode(SHIFT_RCLK, OUTPUT);
  pinMode(SHIFT_SRCLK, OUTPUT);
  /*pinMode(L1, OUTPUT);
  pinMode(L2, OUTPUT);
  pinMode(L3, OUTPUT);
  pinMode(L4, OUTPUT);
  pinMode(L5, OUTPUT);
  pinMode(L6, OUTPUT);
  pinMode(L7, OUTPUT);
  pinMode(L8, OUTPUT);*/
  
  right.attach(4);
  right.write(0);  // set servo to mid-point
  left.attach(5);
  left.write(0);  // set servo to mid-point
  Serial.print("setup done");
} 

void loop() {

  registers[led]=LOW;
  led++;
  if (led>7) led=0;
  registers[led]=HIGH;
  writeRegisters();
  right.write(0);
  left.write(0);
  delay(3000);

  registers[led]=LOW;
  led++;
  if (led>7) led=0;
  registers[led]=HIGH;
  writeRegisters();
  right.write(180);
  left.write(180);
  delay(3000);
  
  /*Serial.print("   ON   ");
  digitalWrite(L1, HIGH);
  digitalWrite(L2, HIGH);
  digitalWrite(L3, HIGH);
  digitalWrite(L4, HIGH);
  digitalWrite(L5, HIGH);
  digitalWrite(L6, HIGH);
  digitalWrite(L7, HIGH);
  digitalWrite(L8, HIGH);
   right.write(0);
   left.write(0);
    delay(3000);
    
  Serial.print("   OFF   ");
  digitalWrite(L1, LOW);
  digitalWrite(L2, LOW);
  digitalWrite(L3, LOW);
  digitalWrite(L4, LOW);
  digitalWrite(L5, LOW);
  digitalWrite(L6, LOW);
  digitalWrite(L7, LOW);
  digitalWrite(L8, LOW);
  right.write(180);
   left.write(180);
   delay(3000);*/
} 
