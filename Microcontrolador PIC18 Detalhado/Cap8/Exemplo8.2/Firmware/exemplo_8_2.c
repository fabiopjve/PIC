#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = OFF
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#pragma code isr = 0x000008
#pragma interrupt ISR
void ISR(void)
{
	INTCONbits.TMR0IF = 0;	// apaga o flag de interrupção
	TMR0H = 0x85;
	TMR0L = 0xEE;
	LATBbits.LATB0 = !LATBbits.LATB0;	// inverte o estado do led
}
#pragma code

void main(void)
{	
	ADCON1 = 0x0F;				// desliga entradas analógicas
	TRISBbits.TRISB0 = 0;		// RB0 como saída
	TMR0H = 0x85;
	TMR0L = 0xEE;
	T0CON = bTMR0ON | bT0CLK_PRE32;
	INTCON = bGIE | bTMR0IE;	// habilita GIE e TMR0IE
	while(1);				// aguarda uma interrupção
}
