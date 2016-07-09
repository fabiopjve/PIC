/************************************************************************/
/*  1WIRE.C - Biblioteca de comunica��o 1-wire                          */
/*                                                                      */
/*  Autor: F�bio Pereira                                                */
/*                                                                      */
/************************************************************************/

// defini��o do pino de comunica��o
// Para utilizar outro pino, basta incluir uma nova defini��o antes
// de incluir este arquivo na aplica��o desejada
#ifndef pino_1w
	#define pino_1w pin_d0	  // define o pino RD0 como comunica��o 1-wire
#endif

#inline
void seta_saida_1w (void)
// coloca a sa�da em la imped�ncia
{
	output_float (pino_1w);
}

#inline
void limpa_saida_1w (void)
// coloca a sa�da em n�vel 0
{
	output_low (pino_1w);
}

boolean reset_1w(void)
// reseta os dispositivos no barramento
{
	boolean presente;
	limpa_saida_1w ();
	delay_us(480);
	seta_saida_1w ();
	delay_us(60);
	presente = input (pino_1w);
	delay_us (240);
	return (presente);
	// 0 = dispositivo presente
	// 1 = nenhum dispositivo detectado
}

void alimenta_barramento_1w (void)
// for�a o barramento em n�vel alto
// utilizado com dispositivos alimentados no modo parasita
{
	output_high (pino_1w);
	delay_ms(1000);
	seta_saida_1w();
}

boolean le_bit_1w (void)
// l� um bit do barramento 1-wire
{
	// d� um pulso na linha, inicia quadro de leitura
	limpa_saida_1w ();		// coloca saida em zero
	seta_saida_1w ();		// retorna a sa�da a um
	delay_us (15);			// aguarda o dispositivo colocar
					// o dado na sa�da
	return (input(pino_1w));	// retorna o dado
}

void escreve_bit_1w (boolean bit)
// escreve um bit no barramento 1-wire
{
	limpa_saida_1w ();
	if (bit) seta_saida_1w (); // coloca dado 1 na saida
	delay_us (120);
	seta_saida_1w ();
}

byte le_byte_1w (void)
// l� um byte do barramento 1-wire
{
	byte i, dado = 0;
	// l� oito bits iniciando pelo bit menos significativo
	for (i=0;i<8;i++)
	{
		if (le_bit_1w ()) dado|=0x01<<i;
		delay_us(90);  // aguarda o fim do quadro de leitura
				// do bit atual
	}
	return (dado);
}

void escreve_byte_1w (char dado)
// escreve um byte no barramento 1-wire
{
	byte i, temp;
	// envia o byte iniciando do bit menos significativo
	for (i=0; i<8; i++)
	{
		temp = dado>>i;	// desloca o dado 1 bit � direita
		temp &= 0x01;		// isola o bit 0 (LSB)
		escreve_bit_1w (temp);	// escreve o bit no barramento
	}
}
