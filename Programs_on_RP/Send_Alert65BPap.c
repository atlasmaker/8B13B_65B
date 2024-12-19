#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <pigpio.h>
#include <string.h>

/*
You need to install pigpio, if you use this program.

sudo apt install pigpio

*/

#define PACKETSIZE 65
#define SERIALSIZE 4
#define PI_CE   0 // CS
#define  CLOCK_SPEED  3500000      //SPI SCLK
unsigned char data_tx_s[PACKETSIZE]={};
unsigned char buf65[PACKETSIZE];

unsigned int COUNTER=0; 
unsigned int COUNTER_SEND=0; 
unsigned int COUNTER_TIMING=0; 
int F=1,F_SEND=1;
int fd_spi;

static void de0_spi_send(int gpio, int level, uint32_t tick){
if(F_SEND==0) return; 
if(level==1){
F_SEND=0;
memcpy(data_tx_s,&COUNTER_SEND,SERIALSIZE);// Serial 
memcpy(buf65,"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY",PACKETSIZE-SERIALSIZE);
buf65[PACKETSIZE-SERIALSIZE]='\0';
	strncpy(data_tx_s+4,buf65,PACKETSIZE-SERIALSIZE);
	spiWrite(fd_spi,data_tx_s,PACKETSIZE);
	printf("%d:%s\n ",COUNTER_SEND,&data_tx_s[SERIALSIZE]);
	++COUNTER_SEND;
	F_SEND=1;
}
}
 

int main(void){
    time_t     now;
    struct tm  *ts;
    char buf[256];
//////////////////Definition of GPIO/////////////////////////////////
int setup = 0;
//gpioCfgBufferSize(500);
//gpioCfgClock(1,0,0);
if((setup=gpioInitialise())<0){return 1;} ; /// Very Important!!!!!
printf("gpioInitialise() succeeded\n");
printf("Please wait 2 sec\n"); sleep(2);
gpioSetMode(4,PI_INPUT); //wiringPi pin7
gpioSetMode(23,PI_INPUT);//wiringPi pin4
if(setup != -1)   gpioSetAlertFunc( 23, (void *)de0_spi_send );
///////////////////////////////////////////////////////////////////
///// You can check the pi assignment of gpio using "gpio  readall"
///////////////////////////////////////////////////////////////////


/////////////////Definition of SPI////////////////////////////////	
if((fd_spi=spiOpen(PI_CE, CLOCK_SPEED, 0)) < 0){
  printf("spiOpen failed\n");
  return EXIT_FAILURE;
}
now = time(NULL);
 ts = localtime(&now);
 strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", ts);

while(1){
sleep(1);
}
spiClose(fd_spi);
gpioTerminate();
printf("\n");

return 0;
}
