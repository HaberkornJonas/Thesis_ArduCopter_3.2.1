/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-



#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up

    port = hal.uartC;
}
#endif


#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
    if (g.rc_6.radio_in > LED_TRIGGER){
      hal.gpio->write(LED_A4, HAL_GPIO_LED_ON); // turn on the LED
    }
    if(g.rc_6.radio_in < LED_TRIGGER){
      hal.gpio->write(LED_A4, HAL_GPIO_LED_OFF); // turn off the LED
    }

    if(connection_established) {
        while(port->available()) {
            char data = hal.uartC->read();
            rb_put(data);
        } 
        hal.uartC->printf("ok");
    }else {
        if(port->available()) {
            connection_established = true;
        }
        hal.uartC->printf("ok");
    }

    if(Rx==1){
        send_data();
    }
}
#endif


#ifdef USERHOOK_50HZLOOP
void userhook_50Hz()
{
    // put your 50Hz code here
}
#endif


#ifdef USERHOOK_MEDIUMLOOP
void userhook_MediumLoop()
{
    // put your 10Hz code here
}
#endif


#ifdef USERHOOK_SLOWLOOP
void userhook_SlowLoop()
{
    // put your 3.3Hz code here    

    //Communication Test
    //const Location loc = current_loc;
    //hal.console->printf_P(PSTR("\nThesis mes nr:%d: / lng:%lf: / lat:%lf: / alt:%lf: / Module nr:%d: / param1:%d: / param2:%d: / param3:%d:;\n"), counter++, (loc.lng/(double)1E7), (loc.lat/(double)1E7), (double)(loc.alt/(double)100), module_number, 0, 10, 100);
}
#endif

#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here

    // sends the text to the Ground Station Control, usually used for important messages (ex: errors) 
    //gcs_send_text_P(SEVERITY_HIGH, PSTR("\nTEST gcs longue ligne\nLine 2\nLine 3\nLine 4"));
}
#endif



void send_data(){
    const Location loc = current_loc;
    int i = 0;
    char tmp;
    do {
        tmp = rb_get();
        message[i] = tmp;
        i++;
    }while(tmp != '\0');
    while(i < BUFFERSIZE) {
        message[i] = ' ';
        i++;
    }
    if(message[0] == ':')
    {
        module_number = message[1]-'0';
        //hal.console->printf_P(PSTR("\Test:%.7f:/:%.7f:\n"), (double)(gps.location().lng/(double)10000000), (double)(gps.location().lat/(double)10000000));
        hal.console->printf_P(PSTR("\nThesis:%d:/:%.7f:/:%.7f:/:%.2f:/%s"), counter++, (double)(loc.lng/(double)1E7), (double)(loc.lat/(double)1E7), (double)(loc.alt/(double)100), message);
    }
    Rx = 0;
}




struct ringbuffer
{
	char buf[BUFFERSIZE];
	int put_ix;
	int get_ix;
	int anzahlZeichen;
};

struct ringbuffer ringbuf;

void rb_put(char c)
{
	ringbuf.buf[ringbuf.put_ix] = c;
	ringbuf.put_ix = (ringbuf.put_ix + 1)%BUFFERSIZE;
	ringbuf.anzahlZeichen++;
	if(c == '\0')
	{
		Rx=1;
	}
}

char rb_get()
{
	if(ringbuf.anzahlZeichen <= 0)
		return -1;
	ringbuf.anzahlZeichen--;
	int tmp = ringbuf.get_ix;
	ringbuf.get_ix = (ringbuf.get_ix + 1)%BUFFERSIZE;
	return ringbuf.buf[tmp];
}

void InitRingBuffer()
{
	int i =0;
	for(; i < BUFFERSIZE; i++)
	{
		ringbuf.buf[i]='0';
	}
	ringbuf.put_ix = 0;
	ringbuf.get_ix = 0;
	ringbuf.anzahlZeichen = 0;
}


