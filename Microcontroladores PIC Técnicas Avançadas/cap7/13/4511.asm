; teste de display com 4511
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
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
	MOVWF	PORTB		; o n�mero 5 � enviado para o 4511
	BSF	PORTB,4		; ativa o display
	SLEEP			; o programa termina aqui
END
