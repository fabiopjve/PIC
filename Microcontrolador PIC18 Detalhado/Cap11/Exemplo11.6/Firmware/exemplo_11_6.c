#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF
#define TBLWT {_asm TBLWTPOSTINC _endasm}
// Escreve um byte no endere�o de mem�ria especificado
void flash_byte_write(unsigned long endereco, unsigned char dado)
{
	unsigned char intcon_temp, cnt;
	TBLPTRU = *(((char *)&endereco)+2);	// parte alta do endere�o
	TBLPTRH = *(((char *)&endereco)+1);
	TBLPTRL = *((char *)&endereco);	// parte baixa do endere�o
	cnt = endereco & 0x1F;	// CNT cont�m o offset do endere�o
	TABLAT = 0xFF;		// TABLAT = 0xFF
	// escreve 0xFF nas posi��es de mem�ria que precedem o endere�o desejado
	while (cnt--) TBLWT;	// enquanto CNT>0 escreve 0xFF na flash
	TABLAT = dado;		// agora escreve o dado
	TBLWT;			// escreve o dado na mem�ria
	EECON1 = bEEPGD | bWREN;	// EEPGD = WREN = 1
	intcon_temp = INTCON;	// salva o estado atual do INTCON
	INTCON = 0;		// apaga INTCON, desabilita interrup��es
	EECON2 = 0x55;		// senha de escrita na mem�ria
	EECON2 = 0xAA;
	EECON1bits.WR = 1;	// seta WR, inicia a escrita
	Nop();			// NOP recomendado pelo fabricante
	EECON1bits.WREN = 0;	// apaga WREN
	INTCON = intcon_temp;	// restaura INTCON
}
void main(void)
{
	flash_byte_write(0x402,0xAB);
	while(1);		// loop
}

