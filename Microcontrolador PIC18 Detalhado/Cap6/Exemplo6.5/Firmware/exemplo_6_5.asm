	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF

#define TECLA_1	PORTB,4
#define TECLA_2	PORTB,5
#define LED	LATB,2

	org 	0x0000			; vetor de reset
	GOTO	INICIO			; desvia para o início do programa
	org 	0x0008
TRATA_RBIF:
	BCF		INTCON,RBIF		; apaga o flag da interrupção RBIF
	BTFSS	TECLA_1			; testa a tecla 1
	BSF		LED				; liga o led
	BTFSS	TECLA_2			; testa a tecla 2
	BCF		LED				; desliga o led
	RETFIE	FAST			; retorna da interrupção
INICIO:
	MOVLW	0x0F	
	MOVWF	ADCON1			; configura os pinos do A/D para o modo digital
	MOVLW	0x30		
	MOVWF	TRISB			; RB4 e RB5 como entradas, demais pinos como saídas
	BCF		INTCON2,RBPU	; habilita pull-ups da porta B
	BSF		INTCON,RBIE		; habilita a interrupção de mudança de estado da porta B
	BSF		INTCON,GIE		; habilita as interrupções globais
FIM:
	BRA		FIM		; loop infinito
	END

