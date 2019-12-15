#ifndef ALGORITHMSTAGE1_H
#define ALGORITHMSTAGE1_H


#include "algorithm.h"

class AlgorithmStage1: public Algorithm {
  public :
    AlgorithmStage1(Robot * robot);
    ~AlgorithmStage1();
    void tick();
};

#endif
