#ifndef SHIFTREGISTER_H
#define SHIFTREGISTER_H
#define NB_REGISTERS 1
#define NB_REGISTERED_PIN 8*NB_REGISTERS

class ShiftRegister 
{
  public:
    ShiftRegister(int SER, int RCLK, int SRCLK);
    void write();
    bool set(int index, bool value);
  private:
    int SER;
    int RCLK;
    int SRCLK;
    bool registers[NB_REGISTERED_PIN];
};

#endif
