#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF
#pragma config CCP2MX = PORTBE

#define L1	LATBbits.LATB0
#define L2	LATBbits.LATB1

#pragma code isr = 0x000008
#pragma interrupt ISR
void ISR(void)
{
	if (PIR1bits.CCP1IF)
	{	// interrupção do CCP1
		PIR1bits.CCP1IF = 0;	// apaga flag de interrupção
		CCPR1 += 40000;			// soma o período ao CCP1
		L1 = !L1;				// inverte o estado do led L1
	}
	if (PIR2bits.CCP2IF)
	{	// interrupção do CCP2
		PIR2bits.CCP2IF = 0;	// apaga flag de interrupção
		CCPR2 += 20000;			// soma o período ao CCP2
		L2 = !L2;				// inverte o estado do led L2
	}
}
#pragma code

void main(void)
{	
	ADCON1 = 0x0F;					// desliga entradas analógicas
	TRISB = 0;					// RB0 a RB7 como saídas
	T1CON = bTMR1ON | bT1CLK_PRE8;	// Timer 1 ligado com prescaler = 8	
	CCP1CON = bCCP_COMPARE_INT;		// CCP1 no modo de comparação (interrupção)
	CCP2CON = bCCP_COMPARE_INT;		// CCP2 no modo de comparação (interrupção)
	L1 = L2 = 0;					// LEDs desligados
	INTCON = bGIE | bPEIE; 		// habilita GIE e PEIE
	PIE1 = bCCP1IE;					// habilita CCP1IE
	PIE2 = bCCP2IE;					// habilita CCP2IE
	while(1);					// loop infinito
}
