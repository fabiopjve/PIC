#include <p18f4520.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

#define _4094_ENABLE	PORTCbits.RC0
void MCU_init(void)
{
	TRISC = 0;	// todos os pinos da porta C como saídas
	SSPSTAT = 0;
	SSPCON1 = bSSPEN | bSPI_MST_4; // SPI modo mestre, clock = FOSC/4 = 1MHz
}
void main(void)
{
	unsigned char contador, temp;
	MCU_init();
	contador = 0;
	_4094_ENABLE = 1;
	while(1)
	{
		SSPBUF = contador++;
		for (temp=200; temp; temp--);
	}
}
