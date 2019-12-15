#include "algorithmstage1.h"


AlgorithmStage1::AlgorithmStage1(Robot * robot):Algorithm(robot) {
  Serial.println("Creating Algorithm Stage 1");
}

AlgorithmStage1::~AlgorithmStage1() {
  
}

void AlgorithmStage1::tick() {
  if (this->running) {
    Serial.println("Stage 1 : tick");
    if (this->robot->isOnLine(TRACKER_MIDDLE)) this->robot->forward();
    if (this->robot->isOnLine(TRACKER_EXTREM_LEFT)) this->robot->forwardRight();
    if (this->robot->isOnLine(TRACKER_LEFT)) this->robot->forwardRight();
    if (this->robot->isOnLine(TRACKER_RIGHT)) this->robot->forwardLeft();
    if (this->robot->isOnLine(TRACKER_EXTREM_RIGHT)) this->robot->forwardLeft();
    if ((!this->robot->isOnLine(TRACKER_EXTREM_LEFT)) && 
        (!this->robot->isOnLine(TRACKER_LEFT)) && 
        (!this->robot->isOnLine(TRACKER_MIDDLE)) && 
        (!this->robot->isOnLine(TRACKER_RIGHT)) && 
        (!this->robot->isOnLine(TRACKER_EXTREM_RIGHT))) this->robot->stop();
  }
}
