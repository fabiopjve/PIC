// Este programa ir� ecoar na tela do terminal os caracteres digitados
// pelo usu�rio. Lembre-se que a transmiss�o / recep��o � feita pelos
// pinos da USART !!!

#include <16f877.h>
#use delay(clock=4000000)
#fuses HS,NOWDT,PUT,NOBROWNOUT,NOLVP
#include <usart.c>
main()
{
	usart_inicializa (12,1); // velocidade: 19200
	usart_transmite ("testando USART \r\n");
	while (true) usart_transmite(usart_recebe());
}
