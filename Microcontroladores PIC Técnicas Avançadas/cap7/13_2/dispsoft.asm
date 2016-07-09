; teste de display decodificado por software
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

DESLOCAMENTO	EQU 0x20
ORG 0x0000
; primeiramente vamos inicializar as portas como sa�das 
	MOVLW	B'00000111'
	MOVWF	CMCON		; configura os comparadores anal�gicos para modo 7
	BANKSEL	TRISA
	CLRF	TRISA
	CLRF	TRISB
	BANKSEL	PORTB
; agora que as portas est�o devidamente configuradas vamos ao display
	MOVLW	D'5'		; copia em W o n�mero 5
	CALL	DECOD_DISPLAY	; chama a sub-rotina para decodificar o display
	MOVWF	PORTB		; o n�mero 5 � enviado para o 4511
	BSF	PORTB,4		; ativa o display
	SLEEP			; o programa termina aqui
DECOD_DISPLAY:
	MOVWF	DESLOCAMENTO	; armazena o n�mero na vari�vel deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endere�o da TABELA
	ADDWF	DESLOCAMENTO,F	; adiciona o valor � vari�vel DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endere�o da TABELA
	BTFSC	STATUS,C		; testa para ver se a soma anterior transbordou 
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
END
