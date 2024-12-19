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
  core_freq=500 #PI4
  dtoverlay=gpio-no-irq 
  arm_freq=1000 #PI3 and PI4
  arm_freq_min=1000 #PI3 and PI4


When using BCM2835 library, "dtoverlay=gpio-no-irq" must be 
written to avoid crashing your Raspberry Pi.
https://www.airspayce.com/mikem/bcm2835/

Timing must be considered when changing core_freq (see also 
Timing Controller in DE0NanoSoc_TXRX.v). Changing core_freq 
to a slower speed, the frequency of the SCLK in SPI will 
be down. Therefore, the packet length becomes longer.
************************************/

//https://www.airspayce.com/mikem/bcm2835/group__constants.html
#define PIN RPI_BPLUS_GPIO_J8_16

unsigned int COUNTER=0; 
unsigned int COUNTER_SEND=0; 
unsigned int COUNTER_TIMING=0; 


void BCM2835_Send(){
unsigned char data_tx_s[PACKETSIZE+5];
 static unsigned char buf65[PACKETSIZE+5];
 memcpy(data_tx_s,&COUNTER_SEND,SERIALSIZE);//Serial No
 memcpy(buf65,"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY",PACKETSIZE-SERIALSIZE);
 strncpy(data_tx_s+4,buf65,PACKETSIZE-SERIALSIZE);
 data_tx_s[PACKETSIZE]='\0';
 data_tx_s[PACKETSIZE+1]='\0';
 printf("%d:%s\n",COUNTER_SEND,&data_tx_s[SERIALSIZE]);
 bcm2835_spi_writenb(data_tx_s, PACKETSIZE);
 ++COUNTER_SEND;
}
 
void signal_callback_handler(int signum){
    printf("\n Detect Ctrl+c Interrupt\n",signum);
    bcm2835_spi_end();
    bcm2835_close();
    printf("Program exit\n");
    exit(0);
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

//////////////////////////////
// Set RPI pin to be an input
bcm2835_gpio_fsel(PIN, BCM2835_GPIO_FSEL_INPT);
//  with a pulldown
//bcm2835_gpio_set_pud(PIN, BCM2835_GPIO_PUD_DOWN);//BCM2835_GPIO_PUD_UP
bcm2835_gpio_ren(PIN);
//////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////
now = time(NULL);
 ts = localtime(&now);
 strftime(buf, sizeof(buf), "%a %Y-%m-%d %H:%M:%S %Z", ts);

signal(SIGINT, signal_callback_handler);
printf("press ^C to exit program ...\n");

bcm2835_gpio_set_eds(PIN); //Enabling is Very Important!!!! 
while(1){
	if(bcm2835_gpio_eds(PIN)){
	// Now clear the eds flag by setting it to 1
	// printf("Event detect for pin 16(GPIO23)\n");
       	bcm2835_gpio_set_eds(PIN);
        BCM2835_Send();
        usleep(100);
	}

}

printf("\n");
bcm2835_spi_end();
bcm2835_close();
return 0;
}
