/************************************************************************/
/*  RS232.C     Biblioteca de Comunica��o serial ass�ncrona por         */
/*					 software                               */
/*                                                                      */
/*  Autor: Fabio Pereira                                                */
/*                                                                      */
/*  Velocidade : 9600 Bps, 1 Start, 1 Stop, Sem paridade                */
/*                                                                      */
/*  Estas rotinas funcionam sem modifica��o para velocidades de 9600 e  */
/*  19200 Bps.                                                          */
/*                                                                      */
/************************************************************************/

// Defini��es de comunica��o
/* 
   Para alterar a velocidade de comunica��o, basta alterar o valor da
   constante baud_rate
*/
#ifndef baud_rate
const long int baud_rate = 9600;
#endif
const int tempo_bit_dado = 1000000/baud_rate-10; // tempo do bit de dado
const int tempo_bit_start = 1500000/baud_rate;  // tempo do bit de start

// Defini��es dos pinos de comunica��o
// Para utilizar outros pinos, basta incluir novas defini��es
// no arquivo do programa onde esta biblioteca for inclu�da
#bit pino_tx = 0x06.0	// pino de transmiss�o � o RB0
#bit pino_rx = 0x06.1	// pino de recep��o � o RB1
#bit dir_tx  = 0x86.0	// dire��o do pino de tx
#bit dir_rx  = 0x86.1	// dire��o do pino de rx

void rs232_inicializa (void)
{
	dir_tx = 0;	// pino de tx como sa�da
	pino_tx = 1;	// coloca o pino de tx em n�vel 1
	dir_rx = 1;	// configura o pino de rx como entrada
}
void rs232_transmite (char dado)
{
	boolean result;
	int conta;
	// primeiro o bit de start
	pino_tx = 0;
	delay_us(tempo_bit_dado);	// aguarda o tempo de start
	conta = 8;			// s�o 8 bits de dados
	while (conta)
	{
		// desloca o dado � direita e dependendo do resultado
		// seta ou n�o a sa�da
		if (shift_right ( &dado, 1, 0)) pino_tx=1; else pino_tx=0;
		delay_us ( tempo_bit_dado);	// aguarda o tempo do bit de dado
		conta--;	// decrementa um no n�mero de bits a transmitir
	}
	pino_tx = 1;			// seta a sa�da TX (bit de stop)
	delay_us(tempo_bit_dado);	// aguarda o tempo de 1 bit
}

char rs232_recebe (void)
{
	int conta,dado;
	while (pino_rx);		// aguarda o bit de start
	delay_us(tempo_bit_start);	// aguarda o tempo de start
	conta = 8;			// s�o 8 bits de dados
	dado = 0;			// apaga o dado recebido
	while (conta)
	{
		shift_right( &dado, 1, pino_rx);	// insere o bit recebido
							// deslocando � direita a
// vari�vel com o dado 
// recebido
		delay_us(tempo_bit_dado);		// aguarda o tempo de 1 bit
		conta--;			// decrementa o n�mero de bits
	}
	delay_us(tempo_bit_dado);		// aguarda o tempo de 1 bit
	return dado;				// retorna o dado recebido
}
