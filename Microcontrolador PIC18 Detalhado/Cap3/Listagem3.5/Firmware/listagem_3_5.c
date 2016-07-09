#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT	// oscilador modo XT
#pragma config WDT = OFF	// watchdog desligado
#pragma config MCLRE = OFF	// fun��o MCLR desativada
#pragma config DEBUG = OFF	// modo DEBUG desativado
#pragma config LVP = OFF	// programa��o por baixa tens�o desativada
#pragma config PWRT = ON	// timer de inicializa��o ligado

unsigned int cnt;

main()
{
	cnt = 0;
	while (1)
	{
		printf("contagem = %u\r\n",cnt);
		cnt++;
	}
}


