#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"
#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF
volatile unsigned char eeprom_int_num_byte_write;
volatile unsigned char *eeprom_wr_data_ptr;
unsigned char teste[5]={0x12,0x34,0x56,0x78,0x9A};
#pragma interrupt EEPROM_ISR
void EEPROM_ISR(void)
{
	PIR2bits.EEIF = 0;	// apaga o flag de interrupção
	// retorna se não houverem mais bytes para escrever
	if (!eeprom_int_num_byte_write) return; 
	EEDATA = *eeprom_wr_data_ptr++;	// novo dado a ser escrito
	EECON2 = 0x55;		// senha de escrita na EEPROM
	EECON2 = 0xAA;
	EECON1bits.WR = 1;	// seta WR e inicia a escrita na EEPROM
	EEADR++;		// incrementa o endereço da EEPROM
	eeprom_int_num_byte_write--;		// decrementa o contador de bytes
}
#pragma code isr_baixa = 0x0008
void ISR_baixa_prioridade(void)
{
	if (PIR2bits.EEIF) _asm BRA EEPROM_ISR _endasm
}
#pragma code
// Escreve “num” bytes apontados por “*data” na EEPROM a partir do endereço especifi-
// cado por “addr”
void eeprom_int_byte_write(char addr, char *data, char num)
{
	while (EECON1bits.WR);	// se uma escrita estiver em andamento, aguarda
	EEADR = addr;		// configura o endereço inicial da escrita
	eeprom_wr_data_ptr = data;	// configura o ponteiro de dados
	eeprom_int_num_byte_write = num;	// número de bytes a serem escritos
	EECON1 = bWREN;			// configura EECON1 para escrita na EEPROM
	PIR2bits.EEIF = 1;		// seta flag de interrupção da EEPROM
	PIE2bits.EEIE = 1;		// habilita a interrupção da EEPROM
}
void main(void)
{
	INTCON = bGIE | bPEIE;	// habilita as interrupções
	eeprom_int_byte_write(0,teste,5);	// escreve 5 bytes do array teste na EEPROM
	while(1);		// loop
}
