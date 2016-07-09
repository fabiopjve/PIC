; Freq�enc�metro Digital e Contador de Eventos
; O timer 0 � utilizado para fornecer a base de tempo de 1 segundo
; O timer 1 � utilizado para fazer a contagem prim�ria dos pulsos de entrada
LIST  P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
;
; *******************************************************************************
; Defini��o das vari�veis
;
FLAGS		EQU 0x20	; armazenamento de flags (MODO e ATUALIZA)
FT4		EQU 0x21	; freq��ncia tempor�ria 4
FT5		EQU 0x22	; freq��ncia tempor�ria 5
FT6		EQU 0x23	; freq��ncia tempor�ria 6
A0		EQU 0x24	; freq��ncia tempor�ria LSB do timer 1
A1		EQU 0x25	; freq��ncia tempor�ria MSB do timer 1
F4		EQU 0x26	; freq��ncia 4
F5		EQU 0x27	; freq��ncia 5
F6		EQU 0x28	; freq��ncia 6
DISP0		EQU 0x29	; d�gito 0 do display
DISP1		EQU 0x2A	; d�gito 1 do display
DISP2		EQU 0x2B	; d�gito 2 do display
DISP3		EQU 0x2C	; d�gito 3 do display
DISP4 		EQU 0x2D	; d�gito 4 do display
DISP5		EQU 0x2E	; d�gito 5 do display
DISP6		EQU 0x2F	; d�gito 6 do display
TEMP		EQU 0x30	; vari�vel tempor�ria
W_TEMP		EQU 0x31	; W tempor�rio
STATUS_TEMP 	EQU 0x32	; STATUS tempor�rio
TEMP0		EQU 0x33	; vari�vel tempor�ria
TEMP1		EQU 0x34	; vari�vel tempor�ria
B0		EQU 0x35	; vari�vel tempor�ria utilizada na subtra��o
B1		EQU 0x36	; vari�vel tempor�ria utilizada na subtra��o
T0_CONTA	EQU 0x37	; contador de interrup��es do timer 0
;******************************************************
; s�mbolos
;******************************************************
#DEFINE	D0 PORTB,7		; catodo do display D0
#DEFINE	D1 PORTA,7		; catodo do display D1
#DEFINE	D2 PORTA,6		; catodo do display D2
#DEFINE	D3 PORTA,3		; catodo do display D3
#DEFINE	D4 PORTA,2		; catodo do display D4
#DEFINE	D5 PORTA,1		; catodo do display D5
#DEFINE	D6 PORTA,0		; catodo do display D6
#DEFINE	ATUALIZA FLAGS,0	; flag de atualiza��o
#DEFINE	MODO FLAGS,1		; flag de modo
T0_VAL	EQU D'18'		; valor inicial da vari�vel de contagem do timer 0
T0_INI	EQU D'40'		; valor inicial do timer 0
ORG 0x0000
	GOTO	INICIO
ORG 0x0004
	SALVA_CONTEXTO		; macro para salvar o conte�do de W e STATUS
	BTFSC	INTCON,T0IF	; testa a interrup��o do timer 0
	GOTO	TRATA_TIMER0	; se T0IF=1, desvia para TRATA_TIMER0
	BTFSC	PIR1,TMR1IF	; testa a interrup��o do timer 1
	GOTO	TRATA_TIMER1	; se TMR1IF=1, desvia para TRATA_TIMER1
FIM_INT:
	RESTAURA_CONTEXTO	; macro para restaurar os valores de W e STATUS
	BSF	T1CON,TMR1ON	; liga o timer 1
	RETFIE			; retorna da interrup��o
TRATA_TIMER1:
	BCF	PIR1,TMR1IF	; limpa o flag de interrup��o do timer 1
	BCF	T1CON,TMR1ON	; desliga o timer 1
	MOVLW	0xD8		; inicializa o timer 1 ...
	MOVWF	TMR1H		; ... 
	MOVLW	0xF0		; ...
	MOVWF	TMR1L		; com o valor 0xD8F0 (ou 55536 decimal)
	INCF	FT4,F		; incrementa FT4
	MOVLW	D'10'		; verifica se FT4 ...
	XORWF	FT4,W		; ... � igual ...
	BTFSS	STATUS,Z	; ... a 10 ...
	GOTO	FIM_INT		; se n�o �, vai para o final da interrup��o
	CLRF	FT4		; se �, apaga o FT4 ...
	INCF	FT5,F		; ... e incrementa o FT5
	MOVLW	D'10'		; verifica se FT5 ...
	XORWF	FT5,W		; ... � igual ...
	BTFSS	STATUS,Z	; ... a 10 ...
	GOTO	FIM_INT		; se n�o �, vai para o final da interrup��o
	CLRF	FT5		; se �, apaga o FT5 ...
	INCF	FT6,F		; ... e incrementa o FT6
	MOVLW	D'10'		; verifica se FT6 ...
	XORWF	FT6,W		; ... � igual ...
	BTFSS	STATUS,Z	; ... a 10 ...
	GOTO	FIM_INT		; se n�o �, vai para o final da interrup��o
	CLRF	TMR1L		; se �, apaga o timer 1 ...
	CLRF	TMR1H		; ...
	CLRF	FT4		; FT4 ...
	CLRF	FT5		; FT5 ...
	CLRF	FT6		; FT6 ...
	GOTO	FIM_INT		; vai para o final da interrup��o
TRATA_TIMER0:
	BCF	INTCON,T0IF	; apaga o flag da interrup��o do timer 0
	MOVLW	T0_INI		;
	MOVWF	TMR0		; reinicia o timer 0 para 39 decimal
	DECF	T0_CONTA	; decrementa a vari�vel de contagem do timer 0
	BTFSS	STATUS,Z	; verifica se T0_CONTA=0
	GOTO	FIM_INT		; se n�o �, vai para o fim da interrup��o
	MOVLW	T0_VAL		; 
	MOVWF	T0_CONTA	; se �, reinicial a vari�vel em 18
	MOVF	TMR1L,W		; copia o valor LSB do timer 1 para ...
	MOVWF	A0		; ... o A0
	MOVF	TMR1H,W		; copia o valor MSB do timer 1 para ...
	MOVWF	A1		; ... o A1
	MOVF	FT4,W		; copia o valor de FT4 ...
	MOVWF	F4		; para F4
	MOVF	FT5,W		; copia o valor de FT5 ...
	MOVWF	F5		; para F5
	MOVF	FT6,W		; copia o valor de FT6 ...
	MOVWF	F6		; para F6
	BSF	ATUALIZA	; ativa flag de atualiza��o dos valores
	BTFSC	MODO		; testa qual o modo de funcionamento
	GOTO	FIM_INT		; se modo=1 (contador) ent�o retorna
				; se modo=0, (frequenc�metro)
	MOVLW	0xD8		; inicializa o timer 1 ...
	MOVWF	TMR1H		; ... 
	MOVLW	0xF0		; ...
	MOVWF	TMR1L		; com o valor 0xD8F0 (ou 55536 decimal)
	CLRF	FT4		; apaga contadores
	CLRF	FT5		; ...
	CLRF	FT6		; ...
	GOTO	FIM_INT		; vai para o final da interrup��o
DECOD_DISPLAY:
	MOVWF	TEMP		; armazena o n�mero na vari�vel deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endere�o da TABELA
	ADDWF	TEMP,F		; adiciona o valor � vari�vel DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endere�o da TABELA
	BTFSC	STATUS,C	; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endere�o da TABELA
	MOVF	TEMP,W		; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
; a tabela seguinte foi modificada devido ao uso do pino RB6 como uma entrada
	RETLW	B'00111111'	; n�mero 0
	RETLW	B'00000110'	; n�mero 1
	RETLW	B'10011011'	; n�mero 2
	RETLW	B'10001111'	; n�mero 3
	RETLW	B'10100110'	; n�mero 4
	RETLW	B'10101101'	; n�mero 5
	RETLW	B'10111101'	; n�mero 6
	RETLW	B'00000111'	; n�mero 7
	RETLW	B'10111111'	; n�mero 8
	RETLW	B'10100111'	; n�mero 9
	RETLW	B'10110111'	; d�gito A	
	RETLW	B'10111100'	; d�gito B
	RETLW	B'00111001'	; d�gito C
	RETLW	B'10011110'	; d�gito D
	RETLW	B'10111001'	; d�gito E
	RETLW	B'10110001'	; d�gito F
ATRASO:				; Sub-rotina de atraso
	ADDLW	1		; soma 1 ao W
	BTFSC	STATUS,Z	; testa se W=0 ...
	RETURN			; se W=0, retorna
	GOTO	ATRASO		; se W diferente de 0, desvia para ATRASO_LOOP
DISPLAY:
; apresenta o primeiro d�gito no display D0
	MOVF	DISP0,W		; copia o d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o d�gito
	MOVWF	PORTB		; ativa os segmentos do display
	BCF	D0		; ativa display D0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D0		; desativa display D0
; apresenta o segundo d�gito no display D1
	MOVF	DISP1,W		; copia o pr�ximo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D1		; ativa display D1
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D1		; desativa display D1
; apresenta o terceiro d�gito no display D2
	MOVF	DISP2,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D2		; ativa o display D2
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D2		; desativa o display D2
; apresenta o quarto d�gito no display D3
	MOVF	DISP3,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D3		; ativa o display D3
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D3		; desativa o display D3
; apresenta o quinto d�gito no display D4
	MOVF	DISP4,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D4		; ativa o display D4
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D4		; desativa o display D4
; apresenta o sexto d�gito no display D5
	MOVF	DISP5,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D5		; ativa o display D5
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D5		; desativa o display D5
; apresenta o s�timo d�gito no display D6
	MOVF	DISP6,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	D6		; ativa o display D6
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	D6		; desativa o display D6
	RETURN			; retorna
; Sub-rotina de atualiza��o dos valores a serem apresentados no
; display.
ATUALIZACAO:
	BCF	ATUALIZA	; apaga flag de solicita��o de
				; atualiza��o de valores
	MOVF	F6,W		; copia a contagem de F6
	MOVWF	DISP6		; para o DISP6
	MOVF	F5,W		; copia a contagem de F5
	MOVWF	DISP5		; para o DISP5
	MOVF	F4,W		; copia a contagem de F4
	MOVWF	DISP4		; para o DISP4
; primeiramente, devemos subtrair 55536 do valor em A0 e A1:
	MOVLW	0xD8		;
	MOVWF	B1		;
	MOVLW	0xF0		;
	MOVWF	B0		;
	CALL	SUB16B		;
; a rotina a seguir converte o valor armazenado em A0 e A1 para decimal
; e armazena os d�gitos decimais em DISP0 a DISP3
	CLRF	DISP0		; apaga as unidades
	CLRF	DISP1		; apaga as dezenas
	CLRF	DISP2		; apaga as centenas
	CLRF	DISP3		; apaga as milhares
BIN16DEC_3:
	MOVF	A0,W		; copia o LSB bin�rio ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB bin�rio ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	0xE8		;
	MOVWF	B0		;
	MOVLW	0x03		;
	MOVWF	B1		; B=03E8 (1000 decimal)
	CALL	SUB16B		; subtrai 1000 decimal do valor bin�rio
	BTFSS	STATUS,C		; testa se o resultado � positivo ou zero
	GOTO	BIN16DEC_4	; n�o ? ent�o vai para a pr�xima fase
	INCF	DISP3,F		; sim ? ent�o incrementa as milhares 
	GOTO	BIN16DEC_3	; reinicia o ciclo
BIN16DEC_4:
	MOVF	TEMP0,W		; retorna o valor anterior ...
	MOVWF	A0		; ... de A0
	MOVF	TEMP1,W		; retorna o valor anterior ...
	MOVWF	A1		; ... de A1
BIN16DEC_5:
	MOVF	A0,W		; copia o LSB bin�rio ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB bin�rio ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	D'100'		;
	MOVWF	B0		;
	CLRF	B1		; B=100 decimal
	CALL	SUB16B		; subtrai 100 decimal do valor bin�rio (A)
	BTFSS	STATUS,C		; testa se o resultado � positivo ou zero
	GOTO	BIN16DEC_6	; n�o ? ent�o vai para a pr�xima fase
	INCF	DISP2,F		; sim ? ent�o incrementa as centenas
	GOTO	BIN16DEC_5	; reinicia o ciclo
BIN16DEC_6:
	MOVF	TEMP0,W		; retorna o valor anterior ...
	MOVWF	A0		; ... de A0
	MOVF	TEMP1,W		; retorna o valor anterior ...
	MOVWF	A1		; ... de A1
BIN16DEC_7:
	MOVF	A0,W		; copia o LSB bin�rio ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB bin�rio ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	D'10'		;
	MOVWF	B0		;
	CLRF	B1		; B=10 decimal
	CALL	SUB16B		; subtrai 10 decimal do valor bin�rio (A)
	BTFSS	STATUS,C		; testa se o resultado � positivo ou zero
	GOTO	BIN16DEC_8	; n�o ? ent�o vai para fase final
	INCF	DISP1,F		; sim ? ent�o incrementa as dezenas
	GOTO	BIN16DEC_7	; reinicia o ciclo
BIN16DEC_8:
	MOVF	TEMP0,W		; copia o valor tempor�rio restante ...
	MOVWF	DISP0		; ... para as unidades
	RETURN			; retorna
SUB16B:
	MOVF	B0,W
	SUBWF	A0,F
	MOVLW	0x01
	BTFSS	STATUS,C
	SUBWF	A1,F
	BTFSS	STATUS,C
	GOTO	EMPRESTA
	MOVF	B1,W
	SUBWF	A1,F
FIM_SUB16B:
	MOVF	A0,F
	BTFSC	STATUS,Z
	MOVF	A1,F
	RETURN
EMPRESTA:
	MOVF	B1,W
	SUBWF	A1,F
	BCF	STATUS,C
	GOTO	FIM_SUB16B
;******************************************************************************
; Aqui se inicia o programa. Primeiramente as vari�veis e dispositivos internos
; s�o inicializados ...
INICIO:
	MOVLW	B'00000111'
	MOVWF	CMCON		; configura os comparadores anal�gicos para modo 7
	BANKSEL	TRISA		;
	CLRF	TRISA		; configura a porta A como sa�da
	CLRF	TRISB		; configura a porta B como sa�da
	BSF	TRISA,5		; RA5 � entrada
	BSF	TRISB,6		; RB6 � entrada
	BANKSEL	PORTB		;
	MOVLW	B'11111111'	; desliga os catodos dos ...
 	MOVWF	PORTA		; ... displays
	CLRF	DISP0		; apaga as vari�veis
	CLRF	DISP1		; ...
	CLRF	DISP2		; ...
	CLRF	DISP3		; ...
	CLRF	DISP4		; ...
	CLRF	DISP5		; ...
	CLRF	DISP6		; ...
	CLRF	FT4		; ...
	CLRF	FT5		; ...
	CLRF	FT6		; ...
	BCF	ATUALIZA	; apaga o flag de notifica��o de atualiza��o
	BCF	MODO		; seleciona o modo 0 (frequenc�metro)
	MOVLW	T0_VAL		;
	MOVWF	T0_CONTA	;
; a temporiza��o de 1 segundo � conseguida utilizando-se o timer 0: ele � 
; programado para utilizar o prescaler com divis�o 1:256, al�m disso, o timer 0
; � inicializado com o valor 39 decimal, o que faz com ele realize apenas
; 217 contagens por ciclo. Desta forma teremos um total de 4Mhz/4/256/217=18,0011
; interrup��es por segundo. A rotina de tratamento do timer 0 deve ent�o pro-
; videnciar a contagem at� 18, antes de efetuar a totaliza��o dos valores.
	MOVLW	B'00000011'	; configura o timer 1 para clock externo, presca-
	MOVWF	T1CON		; ler 1:1 e modo s�ncrono
	BANKSEL	OPTION_REG	;
	MOVLW	B'10000111'	; configura o timer 0 para clock interno com
	MOVWF	OPTION_REG	; prescaler dividindo por 256
	MOVLW	B'00000001'	;
	MOVWF	PIE1		;
	BANKSEL	INTCON		;
	MOVLW	B'11100000'	;
	MOVWF	INTCON		;
	MOVLW	0xD8		; inicializa o timer 1 ...
	MOVWF	TMR1H		; ... 
	MOVLW	0xF0		; ...
	MOVWF	TMR1L		; com o valor 0xD8F0 (ou 55536 decimal)
	MOVLW	T0_INI		;
	MOVWF	TMR0		;
; no loop principal o programa permanecer� apresentando os valores no display
LOOP_PRINCIPAL:
	BTFSC	ATUALIZA	; verifica se o valor deve ser atualizado
	CALL	ATUALIZACAO	; sim ? ent�o atualiza os valores
	CALL	DISPLAY		; mostra display
; Agora verifica qual a posi��o da chave de sele��o de modo, e seleciona o modo
; de acordo.
; Se RA5=1 modo contador, neste caso o flag MODO � setado
; Se RA5=0 modo freq�enc�metro, neste caso o flag MODO � apagado
	BCF	MODO		; apaga MODO
	BTFSC	PORTA,5		;
	BSF	MODO		; se RA5=1, seta MODO
	GOTO	LOOP_PRINCIPAL	; retorna para o LOOP_PRINCIPAL
END
