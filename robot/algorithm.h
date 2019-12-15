#ifndef ALGORITHM_H
#define ALGORITHM_H

#include "robot.h"

class Algorithm {
  public :
    Algorithm(Robot * robot);
    virtual ~Algorithm();
    virtual void run();
    virtual void stop();
    virtual void tick()=0;
    
  protected : 
    Robot * robot;
    bool running;
};

#endif
