#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <bcm2835.h>
#include <signal.h>
#define PACKETSIZE 65
#define SERIALSIZE 4

/************************************
You neet to add below to /boot/config.txt and reboot, if you use this program.
  enable_uart=1
  core_freq=400 #PI3
  dtoverlay=gpio-no-irq
  arm_freq=1000 #PI3
  arm_freq_min=1000 #PI3

If you don't write gpio-no-irq in config.txt and reboot, 
raspberry pi will be hung up.
https://www.airspayce.com/mikem/bcm2835/
************************************/

//https://www.airspayce.com/mikem/bcm2835/group__constants.html
#define PIN RPI_BPLUS_GPIO_J8_07 

unsigned int CNT=0;
unsigned int COUNTER=0; 

void signal_callback_handler(int signum){
    printf("\n Detect Ctrl+C Interrupt\n",signum);
//    bcm2835_gpio_write(PIN_OUT, LOW);
    bcm2835_spi_end();
    bcm2835_close();
    printf("Program exit\n");
    exit(0);
}

void BCM2835_Read(){
unsigned char data_rx[PACKETSIZE+5]={}; 
unsigned char buf65[65];
int i;
    	bcm2835_spi_transfern(data_rx, PACKETSIZE);
	memcpy(&CNT,data_rx,SERIALSIZE);
	memcpy(buf65,data_rx+SERIALSIZE,PACKETSIZE-SERIALSIZE);
	buf65[PACKETSIZE-SERIALSIZE]='\0';
	printf("%d:%s:%d\n",CNT,buf65,COUNTER);
	++COUNTER;
}

int main(void){
    time_t     now;
    struct tm  *ts;
    char buf[256];
///////////////////////////////////////////////////////////////////////////////////////
    if (!bcm2835_init()){
      printf("bcm2835_init failed. Are you running as root??\n");
      return 1;
    }
 
    if (!bcm2835_spi_begin()){
      printf("bcm2835_spi_begin failed. Are you running as root??\n");
      return 1;
    }
    bcm2835_spi_begin();
    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);      // The default
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE0);                   // The default
    bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_128);   // The default
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);                      // The default
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);      // the default
//BCM2835_SPI_CLOCK_DIVIDER_128   3.125MHz on RPI3 
//https://www.airspayce.com/mikem/bcm2835/group__constants.html#ggaf2e0ca069b8caef24602a02e8a00884ea7794f568a5d4e7b47324581a54056e56
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///// You can check the pi assignment of gpio using "gpio  readall"
///////////////////////////////////////////////////////////////////

// Set RPI pin to be an input
bcm2835_gpio_fsel(PIN, BCM2835_GPIO_FSEL_INPT);
//  with a pulldown
//bcm2835_gpio_set_pud(PIN, BCM2835_GPIO_PUD_DOWN);//BCM2835_GPIO_PUD_UP
bcm2835_gpio_ren(PIN);
//////////////////////////////

signal(SIGINT, signal_callback_handler);
printf("press ^C to exit program ...\n");

bcm2835_gpio_set_eds(PIN); //Enabling is  Very Important!!!! 
while(1){
if(bcm2835_gpio_eds(PIN)){
//  Now clear the eds flag by setting it to 1
//	printf("Event detect for pin 7(GPIO4)\n");
 BCM2835_Read();
 bcm2835_gpio_set_eds(PIN);
 usleep(1000);
}
}
bcm2835_spi_end();
bcm2835_close();
return 0;
}

