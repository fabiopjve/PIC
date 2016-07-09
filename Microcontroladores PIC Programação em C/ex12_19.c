// Este programa transmite serialmente um c�digo para cada tecla
// pressionada. A tecla S1 envia o n�mero "1", S2 envia o n�mero "2" e
// S3 envia o n�mero "3".

#include <12f675.h>
#use delay(clock=4000000)

// Configura o PIC para clock interno, pinos GP4 e GP5 para IO
// watchdog desligado, Power-up timer ativado, Detector de Brownout
// desligado e MCLR interno (GP3 � I/O)
#fuses INTRC_IO,NOWDT,PUT,NOBROWNOUT,NOMCLR

// inclui defini��es dos registradores do PIC12F675
#include <regs_12f6xx.h>

// valor de calibra��o do dispositivo, sujeito a altera��o conforme o
// lote de fabrica��o do chip
#rom 0x3ff = { 0x34b4 }

// configura��es de comunica��o serial utilizando a biblioteca de
// software descrita neste livro
#define baud_rate 19200
#include <rs232.c>
#bit pino_tx = 0x05.5
#bit pino_rx = 0x05.4
#bit dir_tx  = 0x85.5
#bit dir_rx  = 0x85.4

char tcl;
boolean tecla_pres;

char varre_teclas (void)
// verifica se alguma tecla est� pressionada
{
	if (!input(pin_a0))	return('1'); // verifica a tecla S1
	if (!input(pin_a1))	return('2'); // verifica a tecla S2
	if (!input(pin_a2))	return('3'); // verifica a tecla S3
	// se nenhuma tecla est� pressionada, desliga o flag
	// tecla_pres e retorna o valor 0
	tecla_pres = 0;
	return (0);
}
char teclas (void)
// Rotina principal de verifica��o do teclado
// Verifica se � uma nova tecla e filtra ru�dos
{
	int t;
	t = varre_teclas(); // verifica se h� tecla
	if ((t) && (!tecla_pres))
	// se h� tecla e o flag est� apagado
	{
		tecla_pres = 1; // ativa o flag
		if (t != tcl)
		// se a tecla atual � diferente da tecla
		// anterior
		{
			// filtra o ruido de contato
			delay_ms (50); // aguarda 50ms
			// l� novamente as tecla e verifica
			// se a mesma tecla ainda est� pressionada
			// caso positivo, retorna a tecla
			if (varre_teclas() == t) return (t);
		}
	}
	return (0); // se n�o h� tecla, retorna 0
}
main()
{
// primeiro, l� o valor de calibra��o do oscilador
// e armazena no registrador OSCCAL. As vers�es
// mais recentes do PCM n�o necessitam desta rotina.
/*
#asm
	call 0x03ff
	movwf osccal
#endasm
*/
	cmcon = 0x07; // desativa entradas do comparador anal�gico
	ansel = 0; // configura entradas do A/D para E/S digital
	wpu = 0x07;  // ativa os pull-ups dos pinos 0, 1 e 2
	gppu = 0; // ativa o pull-up do GPIO
	rs232_inicializa();  // inicializa pinos RS232
	rs232_transmite ("Teste de Teclas\r\n");
	tcl = 0; // limpa a tecla atual
	tecla_pres = 0; // desliga o flag de tecla pressionada
	while (true)
	{
		tcl=teclas(); // verifica se h� tecla pressionada
		if (tecla_pres)
		// caso exista tecla pressionada
		{
			// verifica se � a tecla � maior que 0
			if (tcl) rs232_transmite (tcl); // envia a tecla
		}
	}
}
