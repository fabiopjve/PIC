#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

#pragma romdata meus_dados = 0xF00000
rom unsigned char tabela[5] = 
{0x00, 0x01, 0x02, 0x03, 0x04};
rom unsigned char string[] = {"Teste"};
volatile char temp;

// L� um byte do endere�o especificado da EEPROM interna
unsigned char eeprom_int_read_byte(unsigned char addr)
{
	EEADR = addr;	// EEADR recebe o endere�o passado para a fun��o
	EECON1 = bRD;	// seta o bit de leitura em EECON1
	return (EEDATA);	// retorna o conte�do lido (de EEDATA)
}
void main(void)
{
	temp = eeprom_int_read_byte(0);	// l� o conte�do do endere�o 0 da EEPROM (=0)
	temp = eeprom_int_read_byte(5);	// l� o conte�do do endere�o 5 da EEPROM (=�T�)
	while(1);		// loop
}

