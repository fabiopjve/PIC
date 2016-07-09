;Display multiplexado
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
DESLOCAMENTO	EQU 0x20
D0		EQU 0x21
D1		EQU 0x22
D2		EQU 0x23
ORG 0x0000
	GOTO	INICIO
DECOD_DISPLAY:
	MOVWF	DESLOCAMENTO	; armazena o n�mero na vari�vel deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endere�o da TABELA
	ADDWF	DESLOCAMENTO,F	; adiciona o valor � vari�vel DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endere�o da TABELA
	BTFSC	STATUS,C	; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endere�o da 
				; TABELA
	MOVF	DESLOCAMENTO,W	; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
	RETLW	B'00111111'	; n�mero 0
	RETLW	B'00000110'	; n�mero 1
	RETLW	B'01011011'	; n�mero 2
	RETLW	B'01001111'	; n�mero 3
	RETLW	B'01100110'	; n�mero 4
	RETLW	B'01101101'	; n�mero 5
	RETLW	B'01111101'	; n�mero 6
	RETLW	B'00000111'	; n�mero 7
	RETLW	B'01111111'	; n�mero 8
	RETLW	B'01100111'	; n�mero 9
	RETLW	B'01110111'	; d�gito A	
	RETLW	B'01111100'	; d�gito B
	RETLW	B'00111001'	; d�gito C
	RETLW	B'01011110'	; d�gito D
	RETLW	B'01111001'	; d�gito E
	RETLW	B'01110001'	; d�gito F
ATRASO:				; Sub-rotina de atraso
	ADDLW	1		; soma 1 ao W
	BTFSC	STATUS,Z	; testa se W=0 ...
	RETURN			; se W=0, retorna
	GOTO	ATRASO		; se W diferente de 0, desvia para ATRASO_LOOP
DISPLAY:
	MOVF	D0,W		; copia o d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o d�gito
	MOVWF	PORTB		; ativa os segmentos do display
	BCF	PORTA,2		; ativa display 3
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,2		; desativa display 3
	MOVF	D1,W		; copia o pr�ximo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica o display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,1		; ativa display 2
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,1		; desativa display 2
	MOVF	D2,W		; copia o �ltimo d�gito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,0		; ativa o display 1
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,0		; desativa o display 1
	RETURN			; retorna

INICIO:
; primeiramente vamos inicializar as portas como sa�das 
	MOVLW	B'00000111'
	MOVWF	CMCON		; configura os comparadores anal�gicos para modo 7
	BANKSEL	TRISA		;
	CLRF	TRISA		; configura a porta A para sa�das
	CLRF	TRISB		; configura a porta B para sa�das
	BANKSEL	PORTB		;
	MOVLW	B'00000111'	; desliga os catodos dos tr�s ...
 	MOVWF	PORTA		; ... displays
	MOVLW	D'3'		; display 1=3
	MOVWF	D2		;
	MOVLW	D'2'		; display 2=2
	MOVWF	D1		;
	MOVLW	D'1'		; display 3=1
	MOVWF	D0		;

LOOP_PRINCIPAL:
	CALL	DISPLAY		; mostra display
	GOTO	LOOP_PRINCIPAL	; 
END
