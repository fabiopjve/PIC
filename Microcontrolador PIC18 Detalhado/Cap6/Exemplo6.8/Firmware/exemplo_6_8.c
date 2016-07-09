#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#define TECLA_1	PORTBbits.RB4
#define TECLA_2	PORTBbits.RB5
#define LED_L1	LATBbits.LATB2

#pragma interrupt INT0_ISR
void INT0_ISR(void)
{
	INTCONbits.INT0IF = 0;	// apaga flag de interrupção
	LED_L1 = 1;		// acende o led
}

#pragma interrupt INT1_ISR
void INT1_ISR(void)
{
	INTCON3bits.INT1IF = 0;	// apaga flag de interrupção
	LED_L1 = 0;		// apaga o led
}

#pragma code isr = 0x000008
void ISR_principal(void)
{
	if (INTCONbits.INT0IF) _asm GOTO  INT0_ISR _endasm
	if (INTCON3bits.INT1IF) _asm GOTO  INT1_ISR _endasm
}
#pragma code

void main(void)
{	
	ADCON1 = 0x0F;		// desliga entradas analógicas
	TRISB = 0x03;		// RB0 e RB1 como entradas, demais pinos como saídas
	INTCON2bits.RBPU = 0;	// habilita pull-ups internos
	INTCON3 = bINT1IE;	// habilita INT1
	INTCON2 = 0x80;		// borda de descida para INT0 e INT1, pull-ups desligados
	INTCON = bGIE | bINT0IE; // habilita GIE e INT0
	while(1);		// loop
}
