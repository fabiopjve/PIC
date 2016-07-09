	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF

	org 	0x0000		; vetor de reset
	BRA		INICIO

AGUARDA_TX:
	BTFSS	PIR1,TXIF		; verifica se TXIF está setado
	BRA		$-1		; se TXIF=0, retorna para o teste acima
	RETURN			; caso TXIF=1, retorna da subrotina

INICIO:
	BCF		TRISC,6		; configura pino RC6(TX) como saída
	MOVLW	0x24
	MOVWF	TXSTA		; TXSTA -> TXEN=1 e BRGH=1
	MOVLW	0x80
	MOVWF 	RCSTA		; RCSTA -> SPEN=1
	MOVLW	.25
	MOVWF	SPBRG		; SPBRG = 25 (9600bps para Fosc = 4MHz)
	MOVLW	'P'
	MOVWF 	TXREG		; envia P
	CALL	AGUARDA_TX	; aguarda o buffer estar vazio
	MOVLW	'I'
	MOVWF 	TXREG		; envia I
	CALL	AGUARDA_TX	; aguarda o buffer estar vazio
	MOVLW	'C'
	MOVWF 	TXREG		; envia C
	CALL	AGUARDA_TX	; aguarda o buffer estar vazio
	MOVLW	'1'
	MOVWF 	TXREG		; envia 1
	CALL	AGUARDA_TX	; aguarda o buffer estar vazio
	MOVLW	'8'
	MOVWF 	TXREG		; envia 8
	CALL	AGUARDA_TX	; aguarda o buffer estar vazio
FIM:
	BRA		FIM
	END
