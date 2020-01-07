#include "shiftregister.h"
#include "Arduino.h"

ShiftRegister::ShiftRegister(int SER, int RCLK, int SRCLK) {
  this->SER=SER;
  this->RCLK=RCLK;
  this->SRCLK=SRCLK;
  for (int i=0;i<NB_REGISTERED_PIN;i++) this->registers[i]=LOW;
  pinMode(this->SER,OUTPUT);
  pinMode(this->RCLK,OUTPUT);
  pinMode(this->SRCLK,OUTPUT);
  this->write();
}


void ShiftRegister::write() {
  digitalWrite(this->RCLK, LOW);
  for(int i = NB_REGISTERED_PIN - 1; i >=  0; i--){
    digitalWrite(this->SRCLK, LOW);
    digitalWrite(this->SER, this->registers[i] ? HIGH : LOW);
    digitalWrite(this->SRCLK, HIGH);
    if (this->registers[i]) {
      Serial.print("HIGH ");
    } else {
      Serial.print("LOW ");
    }
  }
  digitalWrite(this->RCLK, HIGH);
  Serial.println();
}

bool ShiftRegister::set(int index, bool value) {
  bool change=(value!=this->registers[index]);
  this->registers[index]=value;
  return change;
}
