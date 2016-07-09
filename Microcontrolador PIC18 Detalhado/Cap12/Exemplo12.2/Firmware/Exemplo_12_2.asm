	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF
	CONFIG  WDT=ON, WDTPS = 128

#define LED	LATB,0

	org 	0x0000		; vetor de reset
INICIO:
	BCF		TRISB,0		; configura RB0 como saída
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
REPETE:
	BSF		LED			; LED = 0 (apaga o led)
	SLEEP
	BCF		LED			; LED = 1 (acende o led)
	SLEEP
	BRA		REPETE		; repete o loop
	END