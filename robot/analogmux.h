#ifndef ANALOGMUX_H
#define ANALOGMUX_H

#include "Arduino.h"

class AnalogMux {
  public:
    AnalogMux(int enable, int sigA, int sigB, int sigC, int signal);
    int read(unsigned int index);
  private:
    int enable;
    int sigA;
    int sigB;
    int sigC;
    int signal;
};

#endif
