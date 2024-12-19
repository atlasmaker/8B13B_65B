#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <pigpio.h>
#include <string.h>
#define PACKETSIZE 65
#define SERIALSIZE 4
#define PI_CE 0 // CS
#define  CLOCK_SPEED  3500000      //SPI SCLK 
/*

You need to install pigpio, if you use this program.

sudo apt install pigpio

*/
unsigned char data_rx[PACKETSIZE+5]={};
unsigned char buf65[PACKETSIZE+5];
unsigned int CNT=0;
unsigned int COUNTER=0; 
int F=1,F_SEND=1;
int fd_spi;

static void de0_spi_read(int gpio, int level, uint32_t tick){
int i;
if(F==0) {printf("multi interrupt|\n");return;}
if(level == 1){
	F=0;
	spiRead(fd_spi, data_rx, PACKETSIZE);
	memcpy(&CNT,data_rx,SERIALSIZE);
	memcpy(buf65,data_rx+SERIALSIZE,PACKETSIZE-SERIALSIZE);
	buf65[PACKETSIZE]='\0';
	printf("%d:%s:%d\n",CNT,buf65,COUNTER);
	//printf("RX %6d:%s\n",COUNTER,&data_rx+SERIALSIZE);
	++COUNTER;
	F=1;
}
}

int main(void){
    time_t     now;
    struct tm  *ts;
    char buf[256];
//////////////////////Definition of GPIO //////////////////////////
int setup = 0;
//gpioCfgBufferSize(500);
//gpioCfgClock(1,0,0);
if((setup=gpioInitialise())<0){return 1;} ; /// Very Important!!!!!
printf("gpioInitialise() succeeded\n");
printf("Please wait 2 sec\n"); sleep(2);
gpioSetMode(4,PI_INPUT); //wiringPi pin7
gpioSetMode(23,PI_INPUT);//wiringPi pin4
if(setup != -1) gpioSetAlertFunc( 4,(void *)de0_spi_read );
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///// You can check the pi assignment of gpio using "gpio  readall"
///////////////////////////////////////////////////////////////////


/////////////////Definition of SPO ////////////////////////////////	
if((fd_spi=spiOpen(PI_CE, CLOCK_SPEED, 0)) < 0){
  printf("spiOpen failed\n");
  return EXIT_FAILURE;
}
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
now = time(NULL);
 ts = localtime(&now);
 strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", ts);
while(1){
usleep(100);
}
spiClose(fd_spi);
gpioTerminate();
printf("\n");
return 0;
}
