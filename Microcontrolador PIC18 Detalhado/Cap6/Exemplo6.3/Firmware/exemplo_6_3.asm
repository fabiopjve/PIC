  LIST P=18F4520
	#include <P18F4520.INC>

; Bits de configura��o
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF

#define LED	LATB,0
#define TECLA	PORTB,0

	org 	0x0000		; vetor de reset
INICIO:
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
REPETE:
	BSF		TRISB,0		; configura RB0 como entrada
	BTFSC	TECLA		; testa a tecla S1
	BRA		S1_LIBERADA		
	BRA		S1_PRESSIONADA
ATRASO:			; atraso ap�s acender/apagar o led
	MOVLW	0		; inicia W com 0
LOOP:
	ADDLW  1		; soma 1 ao W
	BNZ    LOOP		; repete at� que W volte a ser 0
	BRA		REPETE		; volta para o teste da tecla
S1_PRESSIONADA:
	BCF		TRISB,0		; configura RB0 como sa�da
	BSF		LED		; liga o led
	BRA		ATRASO		; vai para o atraso
S1_LIBERADA:
	BCF		TRISB,0		; configura RB0 como sa�da
	BCF		LED		; apaga o led
	BRA		ATRASO		; vai para o atraso
	END

