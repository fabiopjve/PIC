	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF, BOREN=OFF

#define S2	PORTB,4
#define LED	LATB,2

CBLOCK 	0x010
	CNT				; variável CNT utilizada na subrotina de atraso
ENDC

	org 	0x0000		; vetor de reset
INICIO:
	BCF		TRISB,2		; configura RB2 como saída
	BSF		INTCON,RBIE	; habilita a interrupção KBI da porta B
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
	BCF		INTCON2,RBPU	; liga pull-ups da porta B
REPETE:
	BSF		LED			; LED = 0 (apaga o led)
	CALL	ATRASO		; chama a subrotina de atraso
	BCF		LED			; LED = 1 (acende o led)
	CALL	ATRASO		; chama a subrotina de atraso
	BRA		REPETE		; repete o loop
ATRASO:					; Subrotina de atraso
	MOVLW	0xFF		; inicializa o contador principal do loop em 255
	MOVWF	CNT
REP:
	BTFSS	S2			; verifica tecla S2
	CALL	DORMIR		; chama subrotina de entrada em modo sleep
	DECFSZ	CNT,F		; decrementa o contador e se CNT=0, retorna
	BRA		ATRASO2		; se CNT!=0, vai para a parte interna do loop
	RETURN				; retorna da subrotina de atraso
ATRASO2:			
	MOVLW	0			; a parte interna do loop utiliza o W, repetindo 256 vezes
ATRASO3:
	ADDLW	1			; soma 1 ao W
	BNZ		ATRASO3		; repete se W!=0
	BRA		REP			; se W=0 volta para a parte externa do loop

DORMIR:					; subrotina de entrada em modo sleep
	BTFSS	S2			; caso S2 seja liberada, pula a próxima instrução
	GOTO	DORMIR		; aguarda a tecla ser liberada
	BCF		INTCON,RBIF	; apaga o flag da interrupção KBI
	BCF		LED			; apaga o led
	SLEEP				; entra em modo sleep
	RETURN				; returna da subrotina
	END

