#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF
#pragma config CCP2MX = PORTBE

#pragma code isr = 0x000008
#pragma interrupt tmr2_ISR
void tmr2_ISR(void)
{
	static unsigned char dir;
	PIR1bits.TMR2IF = 0;			// apaga flag de interrup��o
	if (!dir)
	{
		if (CCPR2L<255) CCPR2L++; else	// incrementa o ciclo ativo (CCPR2L)
		{	// quando CCPR2L = 255
			CCP2CON |= 0x30;	// for�a ciclo ativo m�ximo (DC2B1 e DC2B0 = 1)
			dir=1;				// muda a dire��o
		}
 	} else 
	{
		if (CCPR2L) CCPR2L--; else	// decrementa ciclo ativo  
		{	// quando CCPR2L = 0
			CCP2CON = bCCP_PWM;	// for�a ciclo m�nimo (DC2B1 e DC2B0 = 0)
			dir=0;				// muda a dire��o
		}
	}
}
#pragma code

void main(void)
{	
	ADCON1 = 0x0F;				// desliga entradas anal�gicas
	TRISB = 0;				// RB0 a RB7 como sa�das	
	T2CON = bTMR2ON | bT2CLK_PRE1 | bT2OUTPS_8;
	CCP2CON = bCCP_PWM;
	INTCON = bGIE | bPEIE; 	// habilita GIE e PEIE
	PIE1 = bTMR2IE;				// habilita TMR2IE
	while(1);				// loop infinito
}
