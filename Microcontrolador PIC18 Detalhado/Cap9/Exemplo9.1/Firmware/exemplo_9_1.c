#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

void MCU_init(void)
{
	LATB = TRISB = 0;	// pinos da porta B como saídas
	CMCON = 0x02;		// comparador no modo 2 
}
unsigned char adc_4bits(void)
{
	unsigned char passo=15, cnt;
	CVRCON = bCVREN | bCVROE | bCVRR;	// configura referência interna (DAC)
	while (passo)
	{
		CVRCON ^= passo;			// coloca o valor atual de passo no DAC
		for (cnt=10;cnt;cnt--);	// um atraso para acomodação do DAC
		// se a saída CVREF>Vin o conversor avança, caso contrário termina
		if (CMCONbits.C2OUT) CVRCON ^= passo; else break;
		passo--;
	}
	return passo;
}

void main(void)
{
	MCU_init();
	while (1) LATB = adc_4bits();	// faz uma conversão e mostra nos LEDs na porta B
}
