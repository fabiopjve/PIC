#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC=INTIO67, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#define L1	LATBbits.LATB0
#define S2	PORTBbits.RB1
#define S3	PORTBbits.RB2

void atraso(void)
{
	unsigned char cnt1,cnt2;	
	for (cnt1=255;cnt1;cnt1--)	// loop externo
	{
		// se S2 pressionada, inverte IRCF0 (4MHz <-> 8MHz)
		if (!S2) OSCCONbits.IRCF0 = !OSCCONbits.IRCF0;
		// se S3 pressionada, inverte PLLEN (clock*1 ou clock*4)
		if (!S3) OSCTUNEbits.PLLEN = !OSCTUNEbits.PLLEN;
		for (cnt2=255;cnt2;cnt2--); 	// loop interno
	}
}

main()
{
	OSCCON = 0x70;		// clock = INTRC (8MHz)
	TRISBbits.TRISB0 = 0;	// configura RB0 como saída
	ADCON1 = 0x0F;		// desliga entradas analógicas
	while(1)
	{
		LATBbits.LATB0 = 1;	// RB0 = 1
		atraso();		// chama a função de atraso
		LATBbits.LATB0 = 0;	// RB0 = 0
		atraso();		// chama a função de atraso
	}
}
