#include <p18f4520.h>

#pragma config OSC = XT	// oscilador modo XT
#pragma config WDT = OFF	// watchdog desligado
#pragma config MCLRE = OFF	// fun��o MCLR desativada
#pragma config DEBUG = OFF	// modo DEBUG desativado
#pragma config LVP = OFF	// programa��o por baixa tens�o desativada
#pragma config PWRT = ON	// timer de inicializa��o ligado

void atraso(void)
{
	unsigned char cnt1,cnt2;	
	for (cnt1=255;cnt1;cnt1--)	// loop externo
		for (cnt2=255;cnt2;cnt2--);	// loop interno
}

main()
{
	TRISBbits.TRISB0 = 0;	// configura RB0 como sa�da
	ADCON1 = 0x0F;	// desliga entradas anal�gicas
	while(1)
	{
		LATBbits.LATB0 = 1;	// RB0 = 1
		atraso();	// chama a fun��o de atraso
		LATBbits.LATB0 = 0;	// RB0 = 0
		atraso();	// chama a fun��o de atraso
	}
}

