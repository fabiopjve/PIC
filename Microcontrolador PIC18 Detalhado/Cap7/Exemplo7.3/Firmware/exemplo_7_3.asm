	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=INTIO67,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=ON,LVP=OFF,BOREN=OFF

#define TECLA_S2	PORTB,1
#define TECLA_S3	PORTB,2

CBLOCK 	0x010
	CNT				; variável CNT utilizada na subrotina de atraso
ENDC

	org 	0x0000		; vetor de reset
INICIO:
	MOVLW	0x70
	MOVWF	OSCCON		; clock = INTRC (8MHz)
	BCF		TRISB,0		; configura RB0 como saída
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
REPETE:
	BCF		LATB,0		; RB0 = 0
	CALL	ATRASO		; chama a subrotina de atraso
	BSF		LATB,0		; RB0 = 1
	CALL	ATRASO		; chama a subrotina de atraso
	BRA		REPETE		; loop
; Subrotina de atraso
ATRASO:
	MOVLW	0xFF		
	MOVWF	CNT		; inicializa o contador principal do loop em 255
REP:
	BTFSS	TECLA_S2		; se a tecla S2 estiver pressionada
	BTG		OSCCON,IRCF0	; inverte o bit IRCF0 (8<->4MHz)
	BTFSS	TECLA_S3		; se a tecla S3 estiver pressionada
	BTG		OSCTUNE,PLLEN	; inverte o bit PLLEN (PLL ON <-> PLL OFF)
	DECFSZ	CNT,F			; decrementa o contador e se CNT=0, retorna
	BRA		ATRASO2			; se CNT!=0, vai para a parte interna do loop
	RETURN					; retorna da subrotina
ATRASO2:			
	MOVLW	0				; a parte interna do loop utiliza o W, repetindo 256 vezes
ATRASO3:
	ADDLW	1				; soma 1 ao W
	BNZ		ATRASO3			; repete se W!=0
	BRA		REP				; se W=0 volta para a parte externa do loop
	END
