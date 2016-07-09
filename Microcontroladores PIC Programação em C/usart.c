//************************************************************
//*                                                          *
//*  USART.C                                                 *
//*                                                          *
//*  Biblioteca de manipula��o da USART                      *
//*  Suporta o modo ass�ncrono                               *
//*                                                          *
//*  Autor: F�bio Pereira                                    *
//*                                                          *
//************************************************************

char usart_rx, usart_tx, txreg, rcreg, spbrg;

struct rcsta_reg
	{
		int rx9d : 1;
		int oerr : 1;
		int ferr : 1;
		int aden : 1;
		int cren : 1;
		int sren : 1;
		int rx9  : 1;
		int spen : 1;
	} rcsta;

struct txsta_reg
	{
		int tx9d : 1;
		int trmt : 1;
		int brgh : 1;
		int xxx  : 1;
		int sync : 1;
		int txen : 1;
		int tx9  : 1;
		int csrc : 1;
	} txsta;

// define os endere�os das vari�veis
#locate rcsta = 0x18
#locate txreg = 0x19
#locate rxreg = 0x1a
#locate txsta = 0x98
#locate spbrg = 0x99
#byte r_pir1  = 0x0c	// define o registrador r_pir1
#bit flag_rc = r_pir1.5	// define o flag_rc
// defini��es utilizadas nas fun��es

void usart_inicializa ( int vel, boolean brgh )
/* 
O valor dos par�metros vel e brgh deve ser retirado a partir das 
tabelas de baud rate fornecidas pela Microchip ou no livro: 
Microcontroladores PIC: T�cnicas Avan�adas.
*/

{
	txsta.brgh = brgh;	// seleciona o modo do gerador de baud rate
	spbrg = vel;  		// configura o gerador de baud rate

	// configura os pinos da USART como entradas !!!!!

	#if __device__ == 627
	input (pin_b2);
	input (pin_b3);
	#endif
	#if __device__ == 628
	input (pin_b2);
	input (pin_b3);
	#endif
	#if __device__ == 876
	input (pin_c7);
	input (pin_c6);
	#endif
	#if __device__ == 877
	input (pin_c7);
	input (pin_c6);
	#endif

	txsta.sync = 0;  		// seleciona o modo ass�ncrono
	rcsta.spen = 1;  		// habilita a USART
	txsta.tx9 = 0;   		// seleciona o modo de 8 bits
	txsta.txen = 1;  		// ativa o transmissor da USART
	rcsta.cren = 1;		// modo de recep��o cont�nua
}

void usart_transmite (char dado)
{
	while (!txsta.trmt); 	// aguarda o buffer de transmiss�o esvaziar
	txreg = dado;		// coloca novo caractere para transmiss�o
}

char usart_recebe (void)
{
	while (!flag_rc);	// aguarda a recep��o de caracteres
	return rxreg;		// retorna o caractere recebido
}
