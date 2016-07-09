; Volt�metro Digital de 8 bits
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
DESLOCAMENTO	EQU 0x20
D0		EQU 0x21
D1		EQU 0x22
D2		EQU 0x23
CONTA		EQU 0x24
RESULTADO_L	EQU 0x25
RESULTADO_H	EQU 0x26
DELTA_L	EQU 0x27
DELTA_H	EQU 0x28
ORG 0x0000
	GOTO	INICIO
DECOD_DISPLAY:
	MOVWF	DESLOCAMENTO	; armazena o n�mero na vari�vel deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endere�o da TABELA
	ADDWF	DESLOCAMENTO,F	; adiciona o valor � vari�vel DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endere�o da TABELA
	BTFSC	STATUS,C	; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endere�o da TABELA
	MOVF	DESLOCAMENTO,W	; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
	RETLW	B'10111111'	; n�mero 0
	RETLW	B'10000110'	; n�mero 1
	RETLW	B'11011011'	; n�mero 2
	RETLW	B'11001111'	; n�mero 3
	RETLW	B'11100110'	; n�mero 4
	RETLW	B'11101101'	; n�mero 5
	RETLW	B'11111101'	; n�mero 6
	RETLW	B'10000111'	; n�mero 7
	RETLW	B'11111111'	; n�mero 8
	RETLW	B'11100111'	; n�mero 9
	RETLW	B'11110111'	; d�gito A	
	RETLW	B'11111100'	; d�gito B
	RETLW	B'10111001'	; d�gito C
	RETLW	B'11011110'	; d�gito D
	RETLW	B'11111001'	; d�gito E
	RETLW	B'11110001'	; d�gito F
ATRASO:				; Subrotina de atraso
	ADDLW	1		; soma 1 ao W
	BTFSC	STATUS,Z	; testa se W=0 ...
	RETURN			; se W=0, retorna
	GOTO	ATRASO		; se W diferente de 0, desvia para ATRASO_LOOP
DISPLAY:
	MOVF	D0,W		; copia o d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o d�gito
	MOVWF	PORTB		; ativa os segmentos do display
	BCF	PORTB,7		; ativa display 1
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTB,7		; desativa display 1
	MOVF	D1,W		; copia o pr�ximo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,6		; ativa display 2
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,6		; desativa display 2
	MOVF	D2,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,7		; ativa o display 3
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,7		; desativa o display 3
	RETURN			; retorna
BIN8DEC:
	MOVWF	D0		; copia o n�mero a ser convertido para a vari�vel de
				; unidades
	CLRF	D1		; limpa as dezenas
	CLRF	D2		; limpa as centenas
BIN8DEC_1:
	MOVLW	D'100'		; subtrai 100 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda em W
	BTFSS	STATUS,C	; o resultado � positivo ou zero ?
	GOTO	BIN8DEC_2	; n�o ? ent�o vai para a pr�xima parte
	MOVWF	D0		; sim ? ent�o copia o valor para as unidades ...
	INCF	D2,F		; incrementa um nas centenas
	GOTO	BIN8DEC_1	; e reinicia o ciclo
BIN8DEC_2:
	MOVLW	D'10'		; subtrai 10 decimal do valor ...
	SUBWF	D0,W		; ... a ser convertido e guarda o resultado em W
	BTFSS	STATUS,C	; o resultado � positivo ou zero ?
	RETURN			; n�o ? ent�o retorna, a convers�o terminou
	MOVWF	D0		; sim ? ent�o copia W para as unidades ...
	INCF	D1,F		; incrementa um nas dezenas 
	GOTO	BIN8DEC_2	; e reinicia o ciclo
INICIALIZA_CONV_DELTA:
	BSF	STATUS,RP0	; seleciona o banco 1
	MOVLW	0xEC		;
	MOVWF	VRCON		; configura refer�ncia de tens�o interna
	BCF	TRISA,3		; configura o pino RA3 para sa�da
	BCF	STATUS,RP0	; seleciona o banco 0
	MOVLW	0x05		;
	MOVWF	CMCON		; configura o m�dulo comparador anal�gico
	RETURN			;
CONVERSOR_DELTA:
	CLRF	RESULTADO_L	;
	CLRF	RESULTADO_H	;
	CLRF	DELTA_L		;
	CLRF	DELTA_H		;
	MOVLW	0x03		;
	MOVWF	CMCON		; inicializa o m�dulo comparador anal�gico
CICLO_CONVERSAO:
	BTFSC	CMCON,C1OUT	; verifica a sa�da do comparador 1
	GOTO	REF_MENOR	; se C1OUT=1 vai para REF_MENOR
REF_MAIOR:
	NOP			; gasta 1 ciclo
	BCF	PORTA,3		; coloca a sa�da RA3 em n�vel '1'
	INCFSZ	RESULTADO_L,F	; incrementa o resultado LSB
	GOTO	GASTA2CICLOS	; vai para GASTA2CICLOS
	INCF	RESULTADO_H,F	; incrementa o resultado MSB
	GOTO	FINAL_CICLO	; vai para o final do ciclo
REF_MENOR:
	BSF	PORTA,3		; coloca a sa�da RA3 em '1'
	NOP			; gasta 1 ciclo
	GOTO	GASTA2CICLOS	; gasta mais 2 ciclos
GASTA2CICLOS:
	GOTO	FINAL_CICLO	; vai para o final do ciclo
FINAL_CICLO:
	INCFSZ	DELTA_L,F	; incrementa o contador de passos de convers�o LSB
	GOTO	GASTA5CICLOS	; gasta 5 ciclos
	INCF	DELTA_H,F	; incrementa o contador de passos de convers�o MSB
; o c�digo a seguir determina se a contagem de ciclos ultrapassou 256
	MOVF	DELTA_H,W	; 
	ANDLW	B'00000001'	;
	BTFSC	STATUS,Z	;
	GOTO	CICLO_CONVERSAO	;
	GOTO	FIM_CONVERSAO	;
GASTA5CICLOS:
	GOTO	$+1		; gasta 2 ciclos (desvia para a pr�xima instru��o)
	NOP			; gasta 1 ciclo
	GOTO	CICLO_CONVERSAO	; inicia novo ciclode convers�o
FIM_CONVERSAO:
	MOVLW	0x06		; 
	MOVWF	CMCON		; configura o m�dulo comparador para modo 6
	RETURN			; retorna
INICIO:
; primeiramente vamos inicializar a porta B como sa�da e os pinos 
; RA3, RA6 e RA7 como sa�das, os demais pinos da porta A ser�o configurados
; como entradas
	MOVLW	B'00000101'
	MOVWF	CMCON		; configura os comparadores anal�gicos para modo 5
	BANKSEL	TRISA		;
	MOVLW	B'00000110'	; os pinos RA1 e RA2 como entradas e os demais
	MOVWF	TRISA		; como sa�das
	CLRF	TRISB		; configura a porta B para sa�das
	BANKSEL	PORTB		;
	MOVLW	B'11000000'	; desliga os catodos dos dois ...
 	MOVWF	PORTA		; ... displays
	BSF	PORTB,7		; desliga o catodo do terceiro display
	CLRF	D0		;
	CLRF	D1		;
	CLRF	D2		;
	MOVLW	D'20'		; inicializa o temporizador de convers�o em
	MOVWF	CONTA		; 20 ciclos
	CALL	INICIALIZA_CONV_DELTA
LOOP_PRINCIPAL:
	CALL	DISPLAY		; apresenta o resultado atual no display
	DECFSZ	CONTA,F		; decrementa temporizador de convers�o
	GOTO	LOOP_PRINCIPAL	; se CONTA>0 retorna para o LOOP_PRINCIPAL
	MOVLW	D'20'		; 
	MOVWF	CONTA		; reinicia contador em 20 decimal
	CALL	CONVERSOR_DELTA	; realiza uma convers�o
	MOVF	RESULTADO_L,W	; copia o resultado de 8 bits em W
	CALL	BIN8DEC		; converte o resultado em decimal
	GOTO	LOOP_PRINCIPAL	; retorna para o LOOP_PRINCIPAL
END
