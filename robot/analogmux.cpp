#include "analogmux.h"


AnalogMux::AnalogMux(int enable, int sigA, int sigB, int sigC, int signal) {
  this->enable=enable;
  this->sigA=sigA;
  this->sigB=sigB;
  this->sigC=sigC;
  this->signal=signal;
  if (this->enable>0) {
    Serial.println("AnalogMux : Enable pin connected");
    pinMode(this->enable, OUTPUT);
    digitalWrite(this->enable, LOW);
  }
  pinMode(this->sigA, OUTPUT);
  pinMode(this->sigB, OUTPUT);
  pinMode(this->sigC, OUTPUT);
  //pinMode(this->signal, INPUT);
}


int AnalogMux::read(unsigned int index) {
  if (index >8) return -1;
  //if (this->enable>0) digitalWrite(this->enable, HIGH);
  int result = index / 4;
  digitalWrite(this->sigC, result==1);
  result= (index % 4) / 2;
  digitalWrite(this->sigB, result==1);
  result= (index % 2);
  digitalWrite(this->sigA, result==1);
  //if (this->enable>0) digitalWrite(this->enable, LOW);
  delay(1);
  return analogRead(this->signal);
}
