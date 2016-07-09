#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT, WDT = OFF, MCLRE = OFF
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON

void main(void)
{
	TRISBbits.TRISB1 = 0;	// configura RB1 como saída
	TRISBbits.TRISB0 = 1;	// configura RB0 como entrada
	ADCON1 = 0x0F;	// desliga entradas analógicas
	while(1)
	{
		if (!PORTBbits.RB0) LATBbits.LATB1 = 1; else LATBbits.LATB1 = 0;
	}
}
