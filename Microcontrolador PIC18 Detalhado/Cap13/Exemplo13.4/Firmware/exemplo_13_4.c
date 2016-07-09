#include <p18f4520.h>
#include <stdio.h>
#include "pic_simb.h"
#include "meu_lcd16x2.c"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = OFF, LVP = OFF, PWRT = ON, BOREN = OFF

unsigned int media, soma, timeout;
const char custom_char[] =
{
	0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, // 1 coluna  |
	0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, // 2 colunas ||
	0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, // 3 colunas |||
	0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, // 4 colunas ||||
	0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F  // 5 colunas |||||
};

#pragma interrupt ADC_ISR
void ADC_ISR(void)
{
	PIR1bits.ADIF = 0;		// apaga flag de interrupção
	soma = soma + ADRES - media;	// acumula o resultado da conversão A/D		
	if (timeout) timeout--;	// decrementa timer de atualização do display
}

#pragma code isr_baixa = 0x0008
void ISR_baixa_prioridade(void)
{
	if (PIR1bits.ADIF) _asm BRA ADC_ISR _endasm
}
#pragma code

// Função de gráfico de barras no LCD
// "pix" = número de pixels a ser plotado (0 a 80)
void LCD_bargraph(char pix)
{
	char contador = 16; 		// número de colunas no display
	while (pix && contador)
	{
		if (pix>=5)			// se o número de pixels for maior que 5 ...
		{
			LCD_write_char(4);	// desenha um quadrado cheio na coluna atual ...
			contador--;		// decrementa contador de colunas ...
			pix -= 5;			// e diminui 5 pixels do total
		} else			// se restam menos de 5 pixels ...
		{
			LCD_write_char(pix-1);	// desenha um quadrado parcial ...
			pix = 0;			// nenhum pixel restante ...
			contador--;		// decrementa o contador de colunas
		}
	}
	while (contador--) LCD_write_char(' ');// se restam colunas, preenche com espaços
}

void MCU_init(void)
{
	LATA = LATB = LATD = 0;
	TRISA = 0x02;		// pino 2 da porta A como entrada
	TRISB = 0x0F;
	TRISD = 0;
	CMCON = 0x07;		// desliga pinos analógicos do comparador
	ADCON1 = 0x0D;		// RA0 e RA1 como entradas analógicas
	ADCON0 = bADC_CH1 | bADC_ON;	// ADC ligado, canal 1 selecionado
	ADCON2 = bADFM | bADC_ACQ8 | bADC_CLK_DIV8;
	T1CON = bT1CLK_PRE1;	// Timer 1 ligado com prescaler = 1
	// evento de comparação em CCP2 inicia uma conversão A/D	
	CCP2CON = bCCP_COMPARE_SPECIAL; 
	CCPR2 = 999;		// ciclo de 1ms
	PIE1 = bADIE;		// habilita interrupção do ADC
	INTCON = bGIE | bPEIE;
}

void main(void)
{
	char aux;
	soma = media = timeout = 0;
	MCU_init();
	LCD_init(DISPLAY_8X5|_2_LINES,DISPLAY_ON|CURSOR_OFF|CURSOR_NOBLINK);
	// Configura o caractere especial na CGRAM
	LCD_send_byte(0,0x40); // configura AC para apontar o início da CGRAM
	for (aux=0; aux<sizeof(custom_char); aux++)
		LCD_send_byte(1,custom_char[aux]); // envia os bytes do caractere
	LCD_write_char('\f'); // apaga o display
	LCD_pos_xy(0,0); // posiciona o cursor na primeira coluna da primeira linha
	LCD_write_string_rom("LCD Bargraph"); // escreve no display
	T1CONbits.TMR1ON = 1;	// liga timer 1
	while(1)
	{
		aux = INTCON;		// salva estado atual de INTCON
		INTCON = 0;		// desabilita interrupções
		media = soma / 8;	// calcula a média das conversões
		INTCON = aux;		// restaura interrupções
		if (!timeout)		// se decorreu o timeout
		{
			LCD_pos_xy(0,1);		// posiciona o cursor
			LCD_bargraph(media/13);		// desenha barra
			timeout = 50;			// novo timeout em 50ms
		}
	}
}

