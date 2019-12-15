#include "algorithm.h"


Algorithm::Algorithm(Robot * robot) {
  this->robot=robot;
  this->running=false;
}

Algorithm::~Algorithm() {
  Serial.println("Deleting Algorithm");
}

void Algorithm::run() {
  Serial.println("Algorithm going to run");
  this->running=true;
}

void Algorithm::stop() {
  Serial.println("Algorithm going to stop");
  this->running=false;
  this->robot->stop();
}
