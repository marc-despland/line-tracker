#ifndef ROBOT_H
#define ROBOT_H

#include "Arduino.h"
#include "shiftregister.h"
#include "analogmux.h"
#include <Servo.h> 

#define TRACKER_EXTREM_LEFT 0
#define TRACKER_LEFT 1
#define TRACKER_MIDDLE 2
#define TRACKER_RIGHT 3
#define TRACKER_EXTREM_RIGHT 4

enum line { white, black};

enum cubecolor {
  red,
  green,
  blue,
  none
};

class Robot
{
  public:
    Robot(int right, int left,int SER, int RCLK, int SRCLK,int muxEnable, int muxSigA, int muxSigB, int muxSigC, int muxSignal);
    void setCube(cubecolor color);
    void calibrateTracker(line target);
    void readTrackers();
    bool isOnLine(unsigned int index);
    unsigned int trackerValue(unsigned int index);
    void testLed(String name);
    void move(int left, int right);
    int readAnalogMux(int i);

    void stop();
    void forward();
    void forwardLeft();
    void forwardRight();
    void backward();
    void backwardLeft();
    void backwardRight();
    void rotateLeft();
    void rotateRight();
    
  private:
    void setTrackerLed(bool leftleft, bool left, bool middle, bool right, bool rightright);
    Servo * right;
    Servo * left;
    ShiftRegister * registers;
    AnalogMux * analogMux;
    int trackers[5];
    int trackersLow[5];
    int trackersHigh[5];
    int trackersLevel[5];
    int speed;
};

#endif
