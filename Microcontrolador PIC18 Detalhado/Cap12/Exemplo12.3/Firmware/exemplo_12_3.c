#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = OFF
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#define L1	LATBbits.LATB0
#define L2	LATBbits.LATB1
#define L3	LATBbits.LATB2
#define L4	LATBbits.LATB3

#pragma code isr = 0x000008
#pragma interrupt ISR
void ISR(void)
{
	unsigned int adres;
	PIR1bits.ADIF = 0;			// apaga o flag de interrupção
	adres = ADRES/4;
	LATB = 0;								// apaga todos os leds
	if (adres>0xBE) L4=1;		// se resultado>0xBE acende L4
		else if (adres>0x7F) L3=1;
			else if (adres>0x3F) L2=1;
				else L1=1;
	ADCON0bits.GO = 1; 
}
#pragma code

void main(void)
{	
	ADCON1 = 0x0F;					// desliga entradas analógicas
	TRISB = 0;						
	ADCON2 = bADFM | bADC_ACQ4 | bADC_CLK_RC;
	ADCON1 = 0x0D;
	ADCON0 = bADC_CH1 | bADC_ON;
	PIE1bits.ADIE = 1;	
	INTCON = bGIE | bPEIE;	// habilita GIE e TMR0IE
	ADCON0bits.GO = 1;			// inicia a primeira conversão
	while(1) Sleep();
}
