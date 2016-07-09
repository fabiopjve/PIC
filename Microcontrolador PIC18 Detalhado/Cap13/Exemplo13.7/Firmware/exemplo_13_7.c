#include <p18f4520.h>
#include "pic_simb.h"

#pragma config OSC = XT, WDT = OFF, MCLRE = ON
#pragma config DEBUG = ON, LVP = OFF, PWRT = ON, BOREN = OFF

#define BUZZER	LATAbits.LATA5

rom char *musicas_rtttl[]=	/*  Melodias RTTTL */
{
{"U2Newyears:d=8,o=6,b=125:a5,a5,c,4a5,a5,a5,a5,c,c,e,4c,c,c,e,e,e,g,4e,e,e,a5,e,e,g,e,e,e,e,e,a5,a5,c,a5,a5,a5,a5,c,c,e,c,c,c,e,e,e,g,e,e,e,2a5"},
{"MissionImp:d=4,o=6,b=150:16d5,16d#5,16d5,16d#5,16d5,16d#5,16d5,16d5,16d#5,16e5,16f5,16f#5,16g5,8g5,4p,8g5,4p,8a#5,8p,8c6,8p,8g5,4p,8g5,4p,8f5,8p,8p,8g5,4p,4p,8a#5,8p,8c6,8p,8g5,4p,4p,8f5,8p,8f#5,8p,8a#5,8g5,1d5"},
{"ET:d=2,o=6,b=200:d,a,8g,8f#,8e,8f#,d,1a5,b5,b,8a,8g#,8f#,8g#,e,1c#7,e,d7,8c#7,8b,8a,8g,f,d.,16d,16c#,16d,16e,f,d,d7,1c#7"},
{"Batman:d=8,o=5,b=160:16a,16g#,16g,16f#,16f,16f#,16g,16g#,4a.,p,d,d,c#,c#,c,c,c#,c#,d,d,c#,c#,c,c,c#,c#,d,d,c#,c#,c,c,c#,c#,g6,p,4g6"},
{"Axelf:d=8,o=5,b=160:4f#,a.,f#,16f#,a#,f#,e,4f#,c6.,f#,16f#,d6,c#6,a,f#,c#6,f#6,16f#,e,16e,c#,g#,4f#."},
{"Hogans:d=16,o=6,b=45:f5.,g#5.,c#.,f.,f#,32g#,32f#.,32f.,8d#.,f#,32g#,32f#.,32f.,d#.,g#5.,c#,32c,32c#.,32a#5.,8g#5.,f5.,g#5.,c#.,f5.,32f#5.,a#5.,32f#5.,d#.,f#.,32f.,g#.,32f.,c#.,d#.,8c#."},
{"Jamesbond:d=4,o=5,b=320:c,8d,8d,d,2d,c,c,c,c,8d#,8d#,2d#,d,d,d,c,8d,8d,d,2d,c,c,c,c,8d#,8d#,d#,2d#,d,c#,c,c6,1b.,g,f,1g."},
{"Pinkpanther:d=16,o=5,b=160:8d#,8e,2p,8f#,8g,2p,8d#,8e,p,8f#,8g,p,8c6,8b,p,8d#,8e,p,8b,2a#,2p,a,g,e,d,2e"},
{"Countdown:d=4,o=5,b=125:p,8p,16b,16a,b,e,p,8p,16c6,16b,8c6,8b,a,p,8p,16c6,16b,c6,e,p,8p,16a,16g,8a,8g,8f#,8a,g.,16f#,16g,a.,16g,16a,8b,8a,8g,8f#,e,c6,2b.,16b,16c6,16b,16a,1b"},
{"Adamsfamily:d=4,o=5,b=160:8c,f,8a,f,8c,b4,2g,8f,e,8g,e,8e4,a4,2f,8c,f,8a,f,8c,b4,2g,8f,e,8c,d,8e,1f,8c,8d,8e,8f,1p,8d,8e,8f#,8g,1p,8d,8e,8f#,8g,p,8d,8e,8f#,8g,p,8c,8d,8e,8f"},
{"TheSimpsons:d=4,o=5,b=160:c.6,e6,f#6,8a6,g.6,e6,c6,8a,8f#,8f#,8f#,2g,8p,8p,8f#,8f#,8f#,8g,a#.,8c6,8c6,8c6,c6"},
{"Indiana:d=4,o=5,b=250:e,8p,8f,8g,8p,1c6,8p.,d,8p,8e,1f,p.,g,8p,8a,8b,8p,1f6,p,a,8p,8b,2c6,2d6,2e6,e,8p,8f,8g,8p,1c6,p,d6,8p,8e6,1f.6,g,8p,8g,e.6,8p,d6,8p,8g,e.6,8p,d6,8p,8g,f.6,8p,e6,8p,8d6,2c6"},
{"GarotaIpanema:d=4,o=5,b=160:g.,8e,8e,d,g.,8e,e,8e,8d,g.,e,e,8d,g,8g,8e,e,8e,8d,f,d,d,8d,8c,e,c,c,8c,a#4,2c"},
{"TakeOnMe:d=4,o=4,b=160:8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5,8f#5,8e5,8f#5,8f#5,8f#5,8d5,8p,8b,8p,8e5,8p,8e5,8p,8e5,8g#5,8g#5,8a5,8b5,8a5,8a5,8a5,8e5,8p,8d5,8p,8f#5,8p,8f#5,8p,8f#5,8e5,8e5"},
{"She:d=16,o=5,b=63:32b,4c6,c6,c6,8b,8d6,8c6.,8b,a,32b,2c6,p,c6,c6,b,8d6,8c6,8b,a,4c6.,8c6,b,32c6,4d6,8c6.,b,8a,8g,8f.,e,f,e,32f,2g,8p"},
{"Barbiegirl:d=4,o=5,b=125:8g#,8e,8g#,8c#6,a,p,8f#,8d#,8f#,8b,g#,8f#,8e,p,8e,8c#,f#,c#,p,8f#,8e,g#,f#"},
{"Entertainer:d=4,o=5,b=140:8d,8d#,8e,c6,8e,c6,8e,2c.6,8c6,8d6,8d#6,8e6,8c6,8d6,e6,8b,d6,2c6,p,8d,8d#,8e,c6,8e,c6,8e,2c.6,8p,8a,8g,8f#,8a,8c6,e6,8d6,8c6,8a,2d6"},
{"Xfiles:d=4,o=5,b=125:e,b,a,b,d6,2b.,1p,e,b,a,b,e6,2b.,1p,g6,f#6,e6,d6,e6,2b.,1p,g6,f#6,e6,d6,f#6,2b.,1p,e,b,a,b,d6,2b.,1p,e,b,a,b,e6,2b.,1p,e6,2b."},
{"Autumn:d=8,o=6,b=125:a,a,a,a#,4a,a,a#,a,a,a,a#,4a,a,a#,a,16g,16a,a#,a,g.,16p,a,a,a,a#,4a,a,a#,a,a,a,a#,4a,a,a#,a,16g,16a,a#,a,g."},
{"Spring:d=16,o=6,b=125:8e,8g#,8g#,8g#,f#,e,4b.,b,a,8g#,8g#,8g#,f#,e,4b.,b,a,8g#,a,b,8a,8g#,8f#,8d#,4b.,8e,8g#,8g#,8g#,f#,e,4b.,b,a,8g#,8g#,8g#,f#,e,4b.,b,a,8g#,a,b,8a,8g#,8f#,8d#,4b."}
};
// A array a seguir armazena as notas musicais (frequencia em Hz)
rom unsigned int nota[4][12] =
{// C    C#    D     D#    E     F     F#    G     G#    A     A#    B
   262,  277,  294,  311,  330,  349,  370,  392,  415,  440,  466,  494, // 4a oitava
   523,  554,  587,  622,  659,  698,  740,  784,  830,  880,  932,  988, // 5a oitava
  1047, 1109, 1175, 1244, 1319, 1397, 1480, 1568, 1660, 1760, 1865, 1976, // 6a oitava
  2093, 2218, 2349, 2489, 2637, 2794, 2960, 3136, 3320, 3520, 3728, 3951  // 7a oitava
};
unsigned int valor_recarga, timer_duracao, tempo;
char som_tocando=0, duracao, oitava;

// Interrup��o do CCP1 controla a dura��o do som (base 1ms)
#pragma interruptlow CCP1_ISR
void CCP1_ISR(void)
{
	PIR1bits.CCP1IF = 0;	// apaga flag de interrup��o
	CCPR1 += 1000;		// pr�xima compara��o em 1000us
  	if (timer_duracao) timer_duracao--; 	// decrementa o timer se >0
  	else                                  	// se o timer chegou a 0
  	{
		PIE2bits.CCP2IE = 0;		// desliga interrup��o do CCP2 (p�ra o som)
  		som_tocando = 0;        		// indica que nao h� som tocando
  	}
}
// Interrup��o do CCP2 encarregada de gerar o som
#pragma interrupt CCP2_ISR
void CCP2_ISR(void)
{
	BUZZER = !BUZZER;			// inverte o estado do Buzzer
	PIR2bits.CCP2IF = 0;			// apaga flag de interrup��o
	CCPR2 += valor_recarga;		// configura a pr�xima compara��o
}
#pragma code isr_alta = 0x0008
void ISR_alta_prioridade(void)
{
	_asm GOTO CCP2_ISR _endasm		// interrup��o do CCP2: alta prioridade
}
#pragma code isr_baixa = 0x0018
void ISR_baixa_prioridade(void)
{
	_asm GOTO CCP1_ISR _endasm		// interrup��o do CCP1: baixa prioridade
}
#pragma code
// Gera um som em RA5: freq in Hz e dur em ms
void som(unsigned int freq, unsigned int dur)
{
  	while (som_tocando);      	// se um som estiver tocando, aguarda terminar
  	// o valor de recarga do CCP2 � igual a metade do per�odo total
  	valor_recarga = (1000000/freq)/2;
  	timer_duracao = dur;       	// configura a dura��o do som
	PIE2bits.CCP2IE = 1;		// habilita a interrup��o do CCP2
  	som_tocando = 1;          	// indica que h� um som tocando
}
// Esta fun��o toca uma melodia em formato RTTTL
void toca_musica(rom char *musica)
{
  	unsigned char temp_dur, temp_oitava, nota_atual, flag_ponto;
  	unsigned int duracao_calc;
  	duracao = 4;                 	// dura��o padr�o = 4/4 = 1 batida
  	tempo = 63;                   // tempo padr�o = 63 bpm
  	oitava = 6;                   // oitava padr�o = 6th
  	while (*musica != ':') musica++;  // encontra o primeiro �:�
  	musica++;			// pula o ':'
  	while (*musica!=':')         	// repete at� achar um ':'
  	{
    	if (*musica == 'd')	// se � uma configura��o de dura��o
    	{
      		duracao = 0;		// seta temporariamente a dura��o para zero
      		musica++;			// avan�a para o pr�ximo caractere da string
      		while (*musica == '=') musica++;  // pula o '='
      		while (*musica == ' ') musica++;  // pula os espa�os
      		// se o caractere � um n�mero, seta a dura��o
      		if (*musica>='0' && *musica<='9') duracao = *musica - '0';
      		musica++;			// avan�a para o pr�ximo caractere
      		// se o pr�ximo caractere tamb�m for um n�mero (dura��o com dois d�gitos)
      		if (*musica>='0' && *musica<='9')
      		{ 	// multiplica a dura��o por 10 e soma o caractere
        		duracao = duracao*10 + (*musica - '0');
        		musica++;		// avan�a para o pr�ximo caractere
      		}
      		while (*musica == ',') musica++;  // pula a ','
    	}
    	if (*musica == 'o')	// se � uma configura��o de oitava
    	{
      		oitava = 0;		// seta temporariamente a oitava para zero
      		musica++;			// avan�a para o pr�ximo caractere
      		while (*musica == '=') musica++;  // pula o '='
      		while (*musica == ' ') musica++;  // pula os espa�os
      		// se o caractere � um n�mero, seta a oitava
      		if (*musica>='0' && *musica<='9') oitava = *musica - '0';
      		musica++;			// avan�a para o pr�ximo caractere
      		while (*musica == ',') musica++;  // pula o ','
    	}
    	if (*musica == 'b')	// se � uma configura��o de tempo (batidas por minuto)
    	{
      		tempo = 0;		// seta temporariamente o tempo para zero
      		musica++;			// avan�a para o pr�ximo caractere
      		while (*musica == '=') musica++;  // pula o '='
      		while (*musica == ' ') musica++;  // pula os espa�os
      		// agora l� a configura��o de tempo (at� tr�s d�gitos)
      		if (*musica>='0' && *musica<='9') tempo = *musica - '0';
      		musica++;			// avan�a para o pr�ximo caractere
      		if (*musica>='0' && *musica<='9')
      		{
        		tempo = tempo*10 + (*musica - '0'); // tempo tem dois d�gitos
        		musica++;		// avan�a para o pr�ximo caractere
        		if (*musica>='0' && *musica<='9')
        		{
          		tempo = tempo*10 + (*musica - '0'); // tempo tem tr�s d�gitos
          		musica++;	// avan�a para o pr�ximo caractere
        		}
      		}
      		while (*musica == ',') musica++;  // pula o ','
    	}    
    	while (*musica == ',') musica++;    // pula o ','    
  	}
  	musica++;			// avan�a para o pr�ximo caractere
  	// l� as notas musicais
  	while (*musica)			// repete at� encontrar um caractere nulo
  	{
    	nota_atual = 255;		// nota padr�o = pausa
    	temp_oitava = oitava;	// seta a oitava para o padr�o da melodia
    	temp_dur = duracao;   	// seta a dura��o para o padr�o da melodia
    	flag_ponto = 0;		// apaga o flag de ponto
    	// procura um prefixo de dura��o
    	if (*musica>='0' && *musica<='9')
    	{
      		temp_dur = *musica - '0';
      		musica++;
      		if (*musica>='0' && *musica<='9')
      		{
        		temp_dur = temp_dur*10 + (*musica - '0');
        		musica++;
      		}
    	}
    	// procura por uma nota musical v�lida
    	switch (*musica)
    	{
      		case 'c': nota_atual = 0; break;    // C (do)
      		case 'd': nota_atual = 2; break;    // D (re)
      		case 'e': nota_atual = 4; break;    // E (mi)
      		case 'f': nota_atual = 5; break;    // F (fa)
      		case 'g': nota_atual = 7; break;    // G (sol)
      		case 'a': nota_atual = 9; break;    // A (la)
      		case 'b': nota_atual = 11; break;   // B (si)
      		case 'p': nota_atual = 255; break;  // pausa
    	}
    	musica++;			// avan�a para o pr�ximo caractere
    // procura por um �#� seguindo a nota
    if (*musica=='#')
    {
      	nota_atual++;			// pr�xima nota (A->A#,C->C#,D->D#,F->F#,G->G#)
      	musica++;			// avan�a para o pr�ximo caractere
    }
    // procura por um �.� (aumenta a dura��o da nota em 50%)
    if (*musica=='.')
    {
      	flag_ponto = 1;		// se um �.� for encontrado, seta o flag 
      	musica++;			// avan�a para o pr�ximo caractere
    }
    // procura por um sufixo de oitava    
    if (*musica>='0' && *musica<='9')
    {
      	temp_oitava = *musica - '0';// a oitava temporaria � configurada
      	musica++;			// avan�a para o pr�ximo caractere
    }
    if (*musica=='.')		// um �.� tamb�m pode ser encontrado ap�s a oitava
    {
      	flag_ponto = 1;		// se um �.� for encontrado, seta o flag 
      	musica++;			// avan�a para o pr�ximo caractere
    }
    while (*musica == ',') musica++;    // pula o ','
    // calcula a dura��o da nota
    duracao_calc = (60000/tempo)/(temp_dur);
    duracao_calc *= 4;         // uma nota tem quatro batidas
    // aumenta a dura��o em 50% se o flag de ponto estiver setado
    if (flag_ponto) duracao_calc = (duracao_calc*3)/2;
    // se a nota atual n�o for uma pausa, toca o som
    if (nota_atual<255) som(nota[temp_oitava-4][nota_atual],duracao_calc);
    else
    { 	// se a nota atual for uma pausa (255), aguarda o tempo de dura��o da nota
      	timer_duracao = duracao_calc;
      	som_tocando = 1;        
    }
    while (som_tocando);      // aguarda a nota ser completada
  }
}
void MCU_init(void)
{
	CMCON = 0x07;				// desativa os comparadores anal�gicos
	ADCON1 = 0x0F;				// desativa entradas anal�gicas do ADC
	TRISAbits.TRISA5 = 0;			// pino RA5 (buzzer) como sa�da
	T1CON = bTMR1ON | bT1CLK_PRE1;	// Timer 1 ligado com prescaler = 1 (1MHz)
	CCP1CON = bCCP_COMPARE_INT;		// CCP1 no modo de compara��o (interrup��o)
	CCP2CON = bCCP_COMPARE_INT;		// CCP2 no modo de compara��o (interrup��o)
	PIE1bits.CCP1IE = 1;			// habilita a interrup��o do CCP1
	IPR1bits.CCP1IP = 0;			// baixa prioridade para CCP1
	RCON = bIPEN;				// ativa modo de dupla prioridade
	INTCON = bGIEH | bGIEL;		// habilita interrup��es
}
void main(void)
{
  	unsigned char song_sel;
	MCU_init();
  	while(1)
  	{
    	for (song_sel=0;song_sel<20;song_sel++)
    	{
      		timer_duracao = 250;	// aguarda 250ms antes de come�ar a melodia
      		som_tocando = 1;
      		while (som_tocando);	     
      		toca_musica(musicas_rtttl[song_sel]); // toca a melodia
      		timer_duracao = 2000;	// aguarda dois segundos antes da pr�xima melodia	
      		som_tocando = 1;
      		while (som_tocando);
    	}
  	}
}
