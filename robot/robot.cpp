#include "robot.h"

#define LED_CUBE_BLUE 7
#define LED_CUBE_RED 6
#define LED_CUBE_GREEN 5
#define LED_TRACKER_1 4
#define LED_TRACKER_2 3
#define LED_TRACKER_3 2
#define LED_TRACKER_4 0
#define LED_TRACKER_5 1

#define TRACKER_1 0
#define TRACKER_2 1
#define TRACKER_3 2
#define TRACKER_4 3
#define TRACKER_5 4

#define NULL_SPEED 90
#define ROTATION_SPEED 45
#define TURN_FACTOR  0.6

#define LEFT_CORRECTION 1
#define RIGHT_CORRECTION 1

Robot::Robot(int right, int left,int SER, int RCLK, int SRCLK,int muxEnable, int muxSigA, int muxSigB, int muxSigC, int muxSignal) {
  this->speed=80;
  this->right=new Servo();
  this->right->attach(right);
  this->right->write(NULL_SPEED);
  this->left=new Servo();
  this->left->attach(left);
  this->left->write(NULL_SPEED);
  this->registers = new ShiftRegister(SER, RCLK, SRCLK);
  this->analogMux = new AnalogMux(muxEnable, muxSigA, muxSigB, muxSigC, muxSignal);
  for (int i=0;i<5;i++) this->trackers[i]=0;

  this->trackersLow[TRACKER_1]=0;
  this->trackersLow[TRACKER_2]=0;
  this->trackersLow[TRACKER_3]=0;
  this->trackersLow[TRACKER_4]=0;
  this->trackersLow[TRACKER_5]=0;

  this->trackersHigh[TRACKER_1]=1023;
  this->trackersHigh[TRACKER_2]=1023;
  this->trackersHigh[TRACKER_3]=1023;
  this->trackersHigh[TRACKER_4]=1023;
  this->trackersHigh[TRACKER_5]=1023;

  for (int i=0;i<5;i++) this->trackersLevel[i]=(this->trackersHigh[i]+this->trackersLow[i])/2;

  for (int i=0;i<8;i++) {
    if (i>0) this->registers->set(i-1, LOW);
    this->registers->set(i, HIGH);
    this->registers->write();
    delay(1000);
  }
  this->registers->set(7, LOW);
  this->registers->write();
  Serial.println("Robot initialization terminated");
}

int Robot::readAnalogMux(int i) {
  return(this->analogMux->read(i));
}
void Robot::calibrateTracker(line target) {
  Serial.println("Debut de calibration");
  long debut=millis();
  this->setCube(blue);
  for (int j=0; j<5; j++) {
    unsigned long start=millis();
    ESP.wdtFeed();
    this->setTrackerLed(j==0, j==1, j==2, j==3, j==4);
    while (millis()<start+1000) {
      for (int i=0; i<5; i++) {
        int value=this->analogMux->read(i);
        if ((target==black) && (value<this->trackersLow[i])) this->trackersLow[i]=value;
        if ((target==white) && (value>this->trackersHigh[i])) this->trackersHigh[i]=value;
        this->trackersLevel[i]=(this->trackersHigh[i]+this->trackersLow[i])/2;
      }
    }
  }
  ESP.wdtFeed();
  this->setTrackerLed(false, false, false, false, false);
  this->setCube(none);
  Serial.print("Calibration terminée:  ");
  Serial.println((millis()-debut));
}

void Robot::readTrackers() {
  for (int i=0; i<5; i++) {
    this->trackers[i]=this->analogMux->read(i);
    
  }
  this->setTrackerLed(
      this->isOnLine(TRACKER_1), 
      this->isOnLine(TRACKER_2),
      this->isOnLine(TRACKER_3),
      this->isOnLine(TRACKER_4),
      this->isOnLine(TRACKER_5));
}

bool Robot::isOnLine(unsigned int index) {
  if (index<5) {
    return (this->trackers[index]>this->trackersLevel[index]);
  } else {
    return false;
  }
}


unsigned int Robot::trackerValue(unsigned int index) {
  if (index<5) {
    unsigned int value=abs(this->trackers[index]-this->trackersLow[index]);
    return (((float) (value*100)) /((float) (this->trackersHigh[index]-this->trackersLow[index])));
  } else {
    return 0;
  }
}

void Robot::testLed(String name) {
  int change =0;
  if (this->registers->set(LED_CUBE_BLUE, name=="cubeblue")) change++;
  if (this->registers->set(LED_CUBE_GREEN, name=="cubegreen")) change++;
  if (this->registers->set(LED_CUBE_RED, name=="cubered")) change++;
  if (this->registers->set(LED_TRACKER_1, name=="tracker1")) change++;
  if (this->registers->set(LED_TRACKER_2, name=="tracker2")) change++;
  if (this->registers->set(LED_TRACKER_3, name=="tracker3")) change++;
  if (this->registers->set(LED_TRACKER_4, name=="tracker4")) change++;
  if (this->registers->set(LED_TRACKER_5, name=="tracker5")) change++;
  if (change>0) this->registers->write();  
}

void Robot::move(int left,int right) {
  if ((left>-101 && left<101) && (right>-101 && right<101)) {
    this->left->write((int) ((((float) (left*90)/(float) 100))+90));  
    this->right->write((int) ((((float) (right*90)/(float) 100))+90));
  } 
}

void Robot::setCube(cubecolor color) {
  bool change=false;
  change = change || this->registers->set(LED_CUBE_BLUE, color==blue);
  change = change || this->registers->set(LED_CUBE_GREEN, color==green);
  change = change || this->registers->set(LED_CUBE_RED, color==red);
  if (change) this->registers->write();
}

void Robot::setTrackerLed(bool leftleft, bool left, bool middle, bool right, bool rightright) {
  bool change=false;
  change = change || this->registers->set(LED_TRACKER_1, leftleft);
  change = change || this->registers->set(LED_TRACKER_2, left);
  change = change || this->registers->set(LED_TRACKER_3, middle);
  change = change || this->registers->set(LED_TRACKER_4, right);
  change = change || this->registers->set(LED_TRACKER_5, rightright);
  if (change) this->registers->write();
}

void Robot::stop() {
  this->left->write(NULL_SPEED);  
  this->right->write(NULL_SPEED);
}

void Robot::forward() {
  this->left->write(NULL_SPEED+this->speed*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED+this->speed*RIGHT_CORRECTION);
}

void Robot::forwardLeft() {
  this->left->write(NULL_SPEED+this->speed*LEFT_CORRECTION*TURN_FACTOR);  
  this->right->write(NULL_SPEED+this->speed*RIGHT_CORRECTION);
}

void Robot::forwardRight() {
  this->left->write(NULL_SPEED+this->speed*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED+this->speed*RIGHT_CORRECTION*TURN_FACTOR);
}

void Robot::backward() {
  this->left->write(NULL_SPEED-this->speed*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED-this->speed*RIGHT_CORRECTION);

}

void Robot::backwardLeft() {
  this->left->write(NULL_SPEED-this->speed*LEFT_CORRECTION*TURN_FACTOR);  
  this->right->write(NULL_SPEED-this->speed*RIGHT_CORRECTION);
}

void Robot::backwardRight() {
  this->left->write(NULL_SPEED-this->speed*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED-this->speed*RIGHT_CORRECTION*TURN_FACTOR);
}

void Robot::rotateLeft() {
  this->left->write(NULL_SPEED-ROTATION_SPEED*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED+ROTATION_SPEED*RIGHT_CORRECTION);
}

void Robot::rotateRight() {
  this->left->write(NULL_SPEED+ROTATION_SPEED*LEFT_CORRECTION);  
  this->right->write(NULL_SPEED-ROTATION_SPEED*RIGHT_CORRECTION);
}
