	LIST P=18F4520
	#include <P18F4520.INC>

; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF

	org 	0x0000	; vetor de reset
INICIO:
	BCF		TRISB,1	; configura RB1 como saída
	BSF		TRISB,0	; configura RB0 como entrada
	MOVLW	0x0F	
	MOVWF	ADCON1	; configura os pinos do A/D para o modo digital
REPETE:
	BTFSC	PORTB,0	; testa a tecla S1
	BRA		S1_LIBERADA
S1_PRESSIONADA:
	BSF		LATB,1	; liga o led
	BRA		REPETE
S1_LIBERADA:
	BCF		LATB,1	; apaga o led
	BRA		REPETE
	END
