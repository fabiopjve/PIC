	LIST P=18F4520
	#include <P18F4520.INC>
	#include "pic_simb.inc"

; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF,BOREN=OFF

	org 	0x0000		; vetor de reset
	GOTO	INICIO
	org		0x0008		; vetor de interrupção
	BCF		INTCON,T0IF	; apaga o flag de interrupção do timer 0
	MOVLW	0x85
	MOVWF	TMR0H		; TMR0H = 0x85
	MOVLW	0xEE
	MOVWF	TMR0L		; TMR0L = 0xEE
	BTG		LATB,0		; inverte o estado do pino RB0
	RETFIE	FAST		; retorna da interrupção
INICIO:
	BCF		TRISB,0		; configura RB0 como saída
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
	MOVLW	0x85
	MOVWF	TMR0H		; TMR0H = 0x85
	MOVLW	0xEE
	MOVWF	TMR0L		; TMR0L = 0xEE
	MOVLW	bTMR0ON | bT0CLK_PRE32
	MOVWF	T0CON		; timer 0 ligado, clock interno, prescaler=1/32
	BSF		INTCON,T0IE	; habilita a interrupção do timer 0
	BSF		INTCON,GIE	; habilita interrupções
REPETE:
	BRA		REPETE		; loop
	END
