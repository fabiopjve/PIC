#include <p18f4520.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

void MCU_init(void)
{
	TRISCbits.TRISC6 = 0;		// configura RC6(TX) como saída
	TXSTA = bTXEN | bBRGH;	// TXSTA = 0x24 -> TXEN=1 e BRGH=1
	RCSTA = bSPEN;				// RCSTA = 0x80 -> SPEN=1
	SPBRG = 25;	// configura a velocidade da EUSART (9600bps para Fosc = 4MHz)
}

void EUSART_envia_string(char *string)
{
	while (*string)
	{
		while (!PIR1bits.TXIF);	// aguarda espaço no buffer de TX
		TXREG = *string;			// envia um caractere
		string++;				// avança para o próximo caractere
	}
}

void main(void)
{
	char str[11]="Ola Mundo!";
	MCU_init();
	EUSART_envia_string(str);
	while(1);
}
