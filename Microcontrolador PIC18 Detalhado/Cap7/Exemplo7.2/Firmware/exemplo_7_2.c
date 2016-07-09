#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT, WDT = ON, WDTPS = 1, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#define TECLA_S1	PORTBbits.RB0
#define TECLA_S2	PORTBbits.RB1
#define TECLA_S3	PORTBbits.RB2
#define LED_L1	LATBbits.LATB0
#define LED_L2	LATBbits.LATB1
#define LED_L3	LATBbits.LATB2

void verifica_RCON(void)
{
	if (!RCONbits.TO)	// se o watchdog causou um reset
	{
		ClrWdt();		// apaga TO
		LED_L1=1;		// liga o led L1
	}
	if (!RCONbits.RI)	// se foi um reset por software
	{
		RCONbits.RI=0;	// apaga o flag
		LED_L2=1;		// liga o led L2
	}
	if (!RCONbits.POR)	// se foi um POR
	{
		RCONbits.POR=0;	// apaga o flag
		LED_L3=1;		// liga o led L3
	}
}

void atraso(void)
{
	unsigned char aux;
	for (aux=255;aux;aux--) ClrWdt();
}

void main(void)
{	
	verifica_RCON();	// verifica os flags do RCON
	ADCON1 = 0x0F;		// desliga entradas analógicas
	while(1)
	{
		TRISB = 0;		// todos os pinos da porta B como saídas
		atraso();		// chama a função de atraso
		TRISB = 0x0F;		// pinos RB0 a RB3 como entradas
		if (!TECLA_S1) Reset();	// se S1 pressionada, executa reset por software
		if (!TECLA_S2) while(1);	// se S2 pressionada, entra em loop e espera watchdog
		if (!TECLA_S3) LATB=0;	// se S3 pressionada, apaga os leds
	}
}

