/*****************************************************************/
/*  I2C.C                                                        */
/*  Biblioteca I2C - Comunica��o I2C por software com suporte    */
/*  a mem�rias EEPROM (modo mestre)                              */
/*                                                               */
/*  Autor: F�bio Pereira                                         */
/*                                                               */
/*****************************************************************/

#ifndef scl
	// Defini��es dos pinos de comunica��o
	#define scl  pin_b1		// pino de clock
	#define sda  pin_b0		// pino de dados
	#define EEPROM_SIZE 32768  // tamanho em bytes da mem�ria EEPROM
#endif

#define seta_scl  output_float(scl)		// seta o pino scl
#define apaga_scl  output_low(scl)		// apaga o pino scl
#define seta_sda  output_float(sda)		// seta o pino sda
#define apaga_sda  output_low(sda)		// apaga o pino sda

void I2C_start(void)
// coloca o barramento na condi��o de start
{
	apaga_scl;  // coloca a linha de clock em n�vel 0
	seta_sda;	// coloca a linha de dados em alta imped�ncia (1)
	seta_scl;	// coloca a linha de clock em alta imped�ncia (1)
	apaga_sda;	// coloca a linha de dados em n�vel 0
	apaga_scl;	// coloca a linha de clock em n�vel 0
}
void I2C_stop(void)
// coloca o barramento na condi��o de stop
{
	apaga_scl;	// coloca a linha de clock em n�vel 0
	apaga_sda;	// coloca a linha de dados em n�vel 0
	seta_scl;	// coloca a linha de clock em alta imped�ncia (1)
	seta_sda;	// coloca a linha de dados em alta imped�ncia (1)
}
void i2c_ack()
// coloca sinal de reconhecimento (ack) no barramento
{
	apaga_sda;	// coloca a linha de dados em n�vel 0
	seta_scl;	// coloca a linha de clock em alta imped�ncia (1)
	apaga_scl;	// coloca a linha de clock em n�vel 0
	seta_sda;	// coloca a linha de dados em alta imped�ncia (1)
}
void i2c_nack()
// coloca sinal de n�o reconhecimento (nack) no barramento
{
	seta_sda;	// coloca a linha de dados em alta imped�ncia (1)
	seta_scl;	// coloca a linha de clock em alta imped�ncia (1)
	apaga_scl;	// coloca a linha de clock em n�vel 0
}
boolean i2c_le_ack()
// efetua a leitura do sinal de ack/nack
{
	boolean estado;
	seta_sda; 	// coloca a linha de dados em alta imped�ncia (1)
	seta_scl;	// coloca a linha de clock em alta imped�ncia (1)
	estado = input(sda);	// l� o bit (ack/nack)
	apaga_scl;	// coloca a linha de clock em n�vel 0
	return estado;
}
void I2C_escreve_byte(unsigned char dado)
{
// envia um byte pelo barramento I2C
	int conta=8;
	apaga_scl;		// coloca SCL em 0
	while (conta)
	{
		// envia primeiro o MSB
		if (shift_left(&dado,1,0)) seta_sda; else apaga_sda;
		// d� um pulso em scl
		seta_scl;
		conta--;
		apaga_scl;
	}
	// ativa sda
	seta_sda;
}
unsigned char I2C_le_byte()
// recebe um byte pelo barramento I2C
{
	unsigned char bytelido, conta = 8;
	bytelido = 0;
	apaga_scl;
	seta_sda;
	while (conta)
	{
		// ativa scl
		seta_scl;
		// l� o bit em sda, deslocando em bytelido
		shift_left(&bytelido,1,input(sda));
		conta--;
		// desativa scl
		apaga_scl;
	}
	return bytelido;
}
void escreve_eeprom(byte dispositivo, long endereco, byte dado)
// Escreve um dado em um endere�o do dispositivo
// dispositivo - � o endere�o do dispositivo escravo (0 - 7)
// endereco - � o endere�o da mem�ria a ser escrito
// dado - � a informa��o a ser armazenada
{
	if (dispositivo>7) dispositivo = 7;
   i2c_start();
   i2c_escreve_byte(0xa0 | (dispositivo << 1)); // endere�a o dispositivo
   i2c_le_ack();
   i2c_escreve_byte(endereco >> 8);	// parte alta do endere�o
   i2c_le_ack();
   i2c_escreve_byte(endereco);	// parte baixa do endere�o
   i2c_le_ack();
   i2c_escreve_byte(dado);			// dado a ser escrito
   i2c_le_ack();
   i2c_stop();
   delay_ms(10); // aguarda a programa��o da mem�ria
}
byte le_eeprom(byte dispositivo, long int endereco)
// L� um dado de um endere�o especificado no dispositivo
// dispositivo - � o endere�o do dispositivo escravo (0 - 7)
// endereco - � o endere�o da mem�ria a ser escrito
{
   byte dado;
	if (dispositivo>7) dispositivo = 7;
   i2c_start();
   i2c_escreve_byte(0xa0 | (dispositivo << 1)); // endere�a o dispositivo
   i2c_le_ack();
   i2c_escreve_byte((endereco >> 8));	// envia a parte alta do endere�o
   i2c_le_ack();
   i2c_escreve_byte(endereco);	// envia a parte baixa do endere�o
   i2c_le_ack();
   i2c_start();
	// envia comando de leitura
   i2c_escreve_byte(0xa1 | (dispositivo << 1));
   i2c_le_ack();
   dado = i2c_le_byte();	// l� o dado
	i2c_nack();
   i2c_stop();
   return dado;
}
