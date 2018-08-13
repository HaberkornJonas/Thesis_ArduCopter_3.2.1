/// -*- tab-width: 4; Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil -*-


#ifdef USERHOOK_INIT
void userhook_init()
{
    // put your initialisation code here
    // this will be called once at start-up

}
#endif


#ifdef USERHOOK_FASTLOOP
void userhook_FastLoop()
{
    // put your 100Hz code here
    if (g.rc_5.radio_in > channel5_Trigger){
      hal.gpio->write(OUTPUT_4, HAL_GPIO_LED_ON);
      digital_state = true;
    }else{
      hal.gpio->write(OUTPUT_4, HAL_GPIO_LED_OFF);
      digital_state = false;
    }

    if(connection_established) {
        while(uartC->available()) {
            char data = uartC->read();
            rb_put(data);
        } 
        uartC->printf("%d",digital_state);
    }else {
        while(uartC->available()) {
            connection_established = true;
            char data = uartC->read();
            rb_put(data);
        }
        if(connection_established)
            clean_connect_data();
        uartC->printf("%d",digital_state);
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

    const Location loc = current_loc;
    if(moduleConnectedCounter < 10)
        moduleConnectedCounter++;
    else
    {
        hal.console->printf_P(PSTR("\nAPM:%d:/:%.7f:/:%.7f:/:%.2f:/:%lu:/:0:/:0:;\n"), counter++, (double)(loc.lng/(double)1E7), (double)(loc.lat/(double)1E7), (double)(loc.alt/(double)100), millis());
        connection_established = false;
        clean_last_message();
    }
}
#endif


#ifdef USERHOOK_SUPERSLOWLOOP
void userhook_SuperSlowLoop()
{
    // put your 1Hz code here

}
#endif


void send_data(){
    const Location loc = current_loc;
    int i = 0;
    char before_last = 'a';
    char tmp;
    do {
        tmp = rb_get();
        message[i] = tmp;
        i++;
    }while(tmp != '\0');
    before_last = message[i-2];
    while(i < BUFFERSIZE) {
        message[i] = ' ';
        i++;
    }
    if(message[0] == ':' && before_last != 'a')
    {
        hal.console->printf_P(PSTR("\nAPM:%d:/:%.7f:/:%.7f:/:%.2f:/:%lu:/%s"), counter++, (double)(loc.lng/(double)1E7), (double)(loc.lat/(double)1E7), (double)(loc.alt/(double)100), millis(), message);
        if(message[1] == '1')
        {
            for(i = 0; i < BUFFERSIZE; i++)
            {
                last_message[i] = message[i];
            }
        }
    }
    else
    {
        if(before_last != 'a')
        {
            hal.console->printf_P(PSTR("\nAPM:%d:/:%.7f:/:%.7f:/:%.2f:/:%lu:/%s"), counter++, (double)(loc.lng/(double)1E7), (double)(loc.lat/(double)1E7), (double)(loc.alt/(double)100), millis(), last_message);
        }
    }
    Rx = 0;
}


void clean_connect_data(){
    int i = 0;
    char tmp;
    do {
        tmp = rb_get();
        message[i] = tmp;
        i++;
    }while(tmp == '\0');
}


void clean_last_message()
{
    for(int i=0; i<BUFFERSIZE; i++)
    {
        last_message[i] = '\0';
    }
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
    if(c == '$')
        clean_connect_data();
    else
    {
	    ringbuf.buf[ringbuf.put_ix] = c;
	    ringbuf.put_ix = (ringbuf.put_ix + 1)%BUFFERSIZE;
	    ringbuf.anzahlZeichen++;
	    if(c == '\0')
	    {
		    Rx=1;
	    }
    }
    moduleConnectedCounter = 0;
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



