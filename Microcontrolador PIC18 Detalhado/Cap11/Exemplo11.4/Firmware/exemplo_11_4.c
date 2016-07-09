#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

#pragma romdata meus_dados = 0x400
const rom char teste[5]={10,20,30,40,50};
const rom char string[]={"Esta é uma string"};

void flash_page_erase(unsigned long endereco)
{
	unsigned char intcon_temp;
	TBLPTRU = *(((char *)&endereco)+2);	// parte alta do endereço
	TBLPTRH = *(((char *)&endereco)+1);	
	TBLPTRL = *((char *)&endereco);	// parte baixa do endereço
	EECON1 = bEEPGD | bFREE | bWREN;	// EEPGD = FREE = WREN = 1
	intcon_temp = INTCON;		// salva o estado atual do INTCON
	INTCON = 0;			// apaga INTCON, desabilita interrupções
	EECON2 = 0x55;			// senha de escrita na memória
	EECON2 = 0xAA;
	EECON1bits.WR = 1;		// seta WR, inicia a escrita
	Nop();				// NOP recomendado pelo fabricante
	EECON1bits.WREN = 0;		// apaga WREN
	INTCON = intcon_temp;		// restaura INTCON
}

void main(void)
{
	flash_page_erase(0x400);	// apaga a página do endereço 0x000400
	while(1);		// loop
}

