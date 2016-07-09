#include <p18f4520.h>
#include <stdio.h>

#pragma config OSC = XT	// oscilador modo XT
#pragma config WDT = OFF	// watchdog desligado
#pragma config MCLRE = OFF	// função MCLR desativada
#pragma config DEBUG = OFF	// modo DEBUG desativado
#pragma config LVP = OFF	// programação por baixa tensão desativada
#pragma config PWRT = ON	// timer de inicialização ligado

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


