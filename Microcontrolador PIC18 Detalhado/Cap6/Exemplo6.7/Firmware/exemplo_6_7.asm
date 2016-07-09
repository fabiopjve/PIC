	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF

#define LED LATB,2

	org 	0x0000		; vetor de reset
	GOTO	INICIO		; desvia para o início do programa
	org 	0x0008
	BTFSC	INTCON,INT0IF	; verifica se a interrupção foi INT0
	BRA		TRATA_INT0	; desvia para a ISR da INT0
	BTFSC	INTCON3,INT1IF	; verifica se a interrupção foi INT1
	BRA		TRATA_INT1	; desvia para a ISR da INT1
	RETFIE	FAST
TRATA_INT0:
	BCF		INTCON,INT0IF	; apaga o flag da interrupção INT0
	BSF		LED			; liga o led
	RETFIE	FAST		; retorna da interrupção
TRATA_INT1:
	BCF		INTCON3,INT1IF	; apaga o flag da interrupção INT1
	BCF		LED			; desliga o led
	RETFIE	FAST		; retorna da interrupção
INICIO:
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
	MOVLW	0x03		; WREG = 00000011 binário
	MOVWF	TRISB		; RB0 e RB1 como entradas, demais pinos como saídas
	MOVLW	0x80		; WREG = 10000000 binário
	MOVWF	INTCON2		; borda de descida para INT0 e INT1, pull-ups desligados
	MOVLW	0x08		; WREG = 00001000 binário
	MOVWF	INTCON3		; habilita INT1
	MOVLW	0x90		; WREG = 1001000 binário
	MOVWF	INTCON		; habilita GIE e INT0
FIM:
	BRA		FIM		; loop infinito
	END
