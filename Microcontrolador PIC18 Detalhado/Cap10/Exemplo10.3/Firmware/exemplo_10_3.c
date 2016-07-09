#include <p18f4520.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

#define L1		LATBbits.LATB0

#pragma interrupt EUSART_RX_ISR
void EUSART_RX_ISR(void)
{
	TXREG = RCREG+1;	// retransmite o dado recebido (+1)
	L1 = !L1;	// muda o estado do led L1
}

#pragma code isr_baixa = 0x0008
void ISR_baixa_prioridade(void)
{
	if (PIR1bits.RCIF) _asm BRA EUSART_RX_ISR _endasm
}
#pragma code

void MCU_init(void)
{
	TRISCbits.TRISC6 = 0;	// pino RC6(TX) como saída
	TRISBbits.TRISB0 = 0;	// pino RB0 (led) como saída
	TXSTA = bTXEN | bBRGH;	// TXSTA = 0x24 -> TXEN=1 e BRGH=1
	RCSTA = bSPEN | bCREN;	// RCSTA = 0x80 -> SPEN=1 e CREN=1
	SPBRG = 25;			// configura a velocidade da EUSART (9600 bps)
	PIE1bits.RCIE = 1;		// habilita a interrupção de recepção da EUSART
	INTCON = bGIE | bPEIE;	// habilita interrupções
}

void main(void)
{
	MCU_init();			// inicializa o microcontrolador
	while(1);			// aguarda uma interrupção
}
