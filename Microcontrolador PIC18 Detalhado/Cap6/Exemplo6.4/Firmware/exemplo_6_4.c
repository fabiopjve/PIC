#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT, WDT = OFF, MCLRE = OFF
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON

#define TECLA_S1	PORTBbits.RB0
#define LED_L1	LATBbits.LATB0

void atraso(void)
{
	unsigned char aux;
	for(aux=255; aux; aux--);
}

void main(void)
{
	ADCON1 = 0x0F;			// desliga entradas analógicas
	while(1)
	{
		TRISBbits.TRISB0 = 1;		// configura RB0 como entrada
		if (!TECLA_S1)
		{					// se a tecla S1 estiver pressionada
			TRISBbits.TRISB0 = 0;	// configura RB0 como saída
			LED_L1 = 1;
		} else
		{					// se a tecla S1 estiver liberada
			TRISBbits.TRISB0 = 0;	// configura RB0 como saída
			LED_L1 = 0;
		}
		atraso();			// chama a função de atraso
	}
}

