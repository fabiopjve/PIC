	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=ON,WDTPS=1,MCLRE=ON,DEBUG=ON,LVP=OFF,BOREN=OFF

#define TECLA_S1	PORTB,0
#define TECLA_S2	PORTB,1
#define TECLA_S3	PORTB,2
#define LED_L1		LATB,0
#define LED_L2		LATB,1
#define LED_L3		LATB,2

	org 	0x0000		; vetor de reset
	GOTO	INICIO		; desvia para o início do programa
INICIO:
	BTFSS	RCON,TO		; testa se houve reset por timeout do watchdog
	CALL	RESET_WDT	
	BTFSS	RCON,RI		; testa se houve reset por software
	CALL	RESET_INSTR
	BTFSS	RCON,POR		; testa se houve reset POR
	CALL	RESET_POR
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
REPETE:
	CLRF	TRISB		; todos os pinos como saídas
	CALL	ATRASO
	MOVLW	0x0F		; WREG = 00001111 binário
	MOVWF	TRISB		; RB0 a RB3 como entradas, demais pinos como saídas
	BTFSS	TECLA_S1	; verifica se a tecla S1 está pressionada
	RESET				; provoca o reset por software
	BTFSS	TECLA_S2	; verifica se a tecla S2 está pressionada
ESTOURA_WDT:
	BRA		ESTOURA_WDT	; provoca o reset pelo estouro do watchdog
	BTFSS	TECLA_S3	; verifica se a tecla S3 está pressionada
	CLRF	LATB		; apaga os leds	
	BRA		REPETE		; repete o loop principal
RESET_WDT:
	CLRWDT				; apaga o flag TO
	BSF		LED_L1		; acende o led L1
	RETURN				; retorna da subrotina
RESET_INSTR:
	BCF		RCON,RI		; apaga o flag RI
	BSF		LED_L2		; acende led L2
	RETURN				; retorna da subrotina
RESET_POR:
	BCF		RCON,POR	; apaga o flag POR
	BSF		LED_L3		; acende o led L3
	RETURN				; retorna da subrotina
ATRASO:
	MOVLW	0		; inicia W com 0
LOOP:
	ADDLW  1		; soma 1 ao W
	CLRWDT			; apaga a contagem do watchdog
	BNZ    LOOP		; repete até que W volte a ser 0
	RETURN			; retorna da subrotina	
	END

