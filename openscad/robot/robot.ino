
const int STOP=0;
const int FORWARD=1;
const int TURNING_LEFT=2;
const int TURNING_RIGHT=3;

int state=0;
bool readingCode=false;
bool clockSignal=false;
int code=0;
int step=0;

bool lines[5]={false,false,false,false,false};

void setup() {
  // put your setup code here, to run once:

}


void readLines() {
  
}

void turnRight() {
  state=TURNING_RIGHT;
  
}

void turnLeft() {
  state=TURNING_LEFT;
  
}

void goForward() {
  state=FORWARD;
  
}

void stop() {
  state=STOP;
  
}

int tracker() {
  int value=0;
  for (int i=0;i<3; i++) value+= lines[i+1] ? pow(2,i) : 0;
  return value;
}

void loop() {
  // put your main code here, to run repeatedly:
  readLines();
  if (state!=STOP) {
    int position=tracker();
    switch(position) {
      case 0 : //000
        if (!lines[0] && !lines[4]) {
          //station
        } else {
          //stop
        }
        break;
      case 1 ://100
      case 3 ://110
        if (state!=TURNING_RIGHT) turnRight();
        break;
      case 2 ://010
        if (state!=FORWARD) goForward();
        break;
      case 4 ://001
      case 6 ://011
        if (state!=TURNING_LEFT) turnLeft();
        break;
    }
    if (!readingCode) {
      if (position==5) {
        //101
        readingCode=true;
        clockSignal=false;
        code=0;
        step=0;
      } else {
        if (position==7) {
          //111
        }
      }
    } else {
      if (position!=5) {
        if (position==7) {
          //111
          readingCode=false;
        } else {
          if (clockSignal!=lines[4]) {
            clockSignal=lines[4];
            code+=lines[0] ? pow(2,step): 0;
            step++;
          }
        }
      }
    }
  }

}
