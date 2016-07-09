#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#define TECLA_1	PORTBbits.RB4
#define TECLA_2	PORTBbits.RB5
#define LED_L1	LATBbits.LATB2

#pragma code isr = 0x000008
#pragma interrupt RBIF_ISR
void RBIF_ISR(void)
{
	INTCONbits.RBIF = 0;		// apaga flag de interrupção
	if (!TECLA_1) LED_L1 = 1;		// se TECLA_1, acende o led
	if (!TECLA_2) LED_L1 = 0;		// se TECLA_2, apaga o led
}

void main(void)
{	
	ADCON1 = 0x0F;			// desliga entradas analógicas
	TRISB = 0x30;			// RB4 e RB5 como entradas, demais pinos como saídas
	INTCON2bits.RBPU = 0;		// habilita pull-ups internos
	INTCONbits.RBIE = 1;		// habilita interrupção de mudança de estado da porta B
	INTCONbits.GIE = 1;		// habilita interrupções globais
	while(1);			// loop infinito
}

