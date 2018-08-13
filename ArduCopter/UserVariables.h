/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-
// user defined variables

#ifdef USERHOOK_VARIABLES
#define BUFFERSIZE 120


//Thesis - Port variables *******************************
AP_HAL::UARTDriver *uartC = hal.uartC; 
const int channel5_Trigger = 1800;
const int OFFSET_OUTPUT = 54;
const int OUTPUT_4 = 4+OFFSET_OUTPUT;


//Thesis - Global variables *****************************
int Rx = 0;
int counter = 0;
bool moduleConnected = false;
int moduleConnectedCounter = 0;

char* message = new char[BUFFERSIZE];
char* last_message = new char[BUFFERSIZE];
bool connection_established = false;
bool digital_state = false;


//Thesis - Functions ************************************
void send_data(void);
void clean_connect_data(void);
void rb_put(char car);
char rb_get(void);
int rb_status(void);
void InitRingBuffer(void);
void clean_last_message(void);


#endif  // USERHOOK_VARIABLES


