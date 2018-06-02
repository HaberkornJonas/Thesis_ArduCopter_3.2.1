/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
// user defined variables

#ifdef USERHOOK_VARIABLES
#define BUFFERSIZE 120


//P5 - APM Output ***************************************
int LED_TRIGGER_HIGH = 1700;
int LED_TRIGGER_LOW = 1200;
int LED_TRIGGER = 1500;
bool buzzer_state = true;

bool state_LED = true;
const int OFFSET_OUTPUT = 54;
const int LED_A4 = 4+OFFSET_OUTPUT;



//Thesis - Port variables *******************************
AP_HAL::UARTDriver *port = hal.uartC;
const uint32_t _baudrates[] PROGMEM = {4800U, 38400U, 115200U, 57600U, 9600U};


//Thesis - Global variables *****************************
int Rx;
int counter = 0;

char* message = new char[BUFFERSIZE];
bool connection_established = false;
int module_number = 0;


//Thesis - Functions ************************************
void send_data(void);
void rb_put(char car);
char rb_get(void);
int rb_status(void);
void InitRingBuffer(void);


//Thesis - Test variables
float* longitude = new float[7]{8.214750 , 8.215750 , 8.216750 , 8.216750 , 8.215750 , 8.213750 , 8.213750 };
float* latitude  = new float[7]{47.477111, 47.477111, 47.476111, 47.475111, 47.475111, 47.476111, 47.477111};
float* altitude  = new float[7]{400      , 410      , 420      , 430      , 430      , 420      , 410      };


#endif  // USERHOOK_VARIABLES


