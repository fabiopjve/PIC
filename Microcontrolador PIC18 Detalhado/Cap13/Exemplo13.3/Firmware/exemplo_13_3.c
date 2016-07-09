#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"
#include "meu_lcd16x2.c"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

void MCU_init(void)
{
	LATA = LATB = LATD = TRISA = TRISD = 0;
	TRISB = 0x0F;	
	CMCON = 0x07;			// desliga pinos analógicos do comparador
	ADCON1 = 0x0F;		// desliga pinos analógicos do ADC
}

void main(void)
{
	MCU_init();
	LCD_init(DISPLAY_8X5|_2_LINES,DISPLAY_ON|CURSOR_OFF|CURSOR_NOBLINK);
	LCD_write_char('\f');	// apaga os dados do display
	LCD_pos_xy(0,0); 			// posiciona o cursor na primeira linha e primeira coluna
	LCD_write_string_rom("PIC18 Detalhado"); // escreve string no display
	while(1);
}
