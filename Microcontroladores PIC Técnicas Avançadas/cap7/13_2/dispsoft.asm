; teste de display decodificado por software
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

DESLOCAMENTO	EQU 0x20
ORG 0x0000
; primeiramente vamos inicializar as portas como saídas 
	MOVLW	B'00000111'
	MOVWF	CMCON		; configura os comparadores analógicos para modo 7
	BANKSEL	TRISA
	CLRF	TRISA
	CLRF	TRISB
	BANKSEL	PORTB
; agora que as portas estão devidamente configuradas vamos ao display
	MOVLW	D'5'		; copia em W o número 5
	CALL	DECOD_DISPLAY	; chama a sub-rotina para decodificar o display
	MOVWF	PORTB		; o número 5 é enviado para o 4511
	BSF	PORTB,4		; ativa o display
	SLEEP			; o programa termina aqui
DECOD_DISPLAY:
	MOVWF	DESLOCAMENTO	; armazena o número na variável deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endereço da TABELA
	ADDWF	DESLOCAMENTO,F	; adiciona o valor à variável DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endereço da TABELA
	BTFSC	STATUS,C		; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endereço da 
				; TABELA
	MOVF	DESLOCAMENTO,W	; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
	RETLW	B'00111111'	; número 0
	RETLW	B'00000110'	; número 1
	RETLW	B'01011011'	; número 2
	RETLW	B'01001111'	; número 3
	RETLW	B'01100110'	; número 4
	RETLW	B'01101101'	; número 5
	RETLW	B'01111101'	; número 6
	RETLW	B'00000111'	; número 7
	RETLW	B'01111111'	; número 8
	RETLW	B'01100111'	; número 9
	RETLW	B'01110111'	; dígito A	
	RETLW	B'01111100'	; dígito B
	RETLW	B'00111001'	; dígito C
	RETLW	B'01011110'	; dígito D
	RETLW	B'01111001'	; dígito E
	RETLW	B'01110001'	; dígito F
END
