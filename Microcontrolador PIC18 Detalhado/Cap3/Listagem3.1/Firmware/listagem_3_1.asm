	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=OFF,DEBUG=OFF,LVP=OFF

CBLOCK 	0x010
	CNT			; variável CNT utilizada na subrotina de atraso
ENDC

	org 	0x0000	; vetor de reset
	GOTO	INICIO	; desvia para o início do programa

	org 	0x000E	; o programa é montado apartir do endereço 0x000E
INICIO:
	BCF		TRISB,0	; configura RB0 como saída
	MOVLW	0x0F	
	MOVWF	ADCON1	; configura os pinos do A/D para o modo digital
REPETE:
	BCF	LATB,0		; RB0 = 0
	CALL	ATRASO	; chama a subrotina de atraso
	BSF		LATB,0	; RB0 = 1
	CALL	ATRASO	; chama a subrotina de atraso
	BRA		REPETE	; repete o loop
; Subrotina de atraso
ATRASO:
	MOVLW	0xFF	; inicializa o contador principal do loop em 255
	MOVWF	CNT
REP:
	DECFSZ	CNT,F	; decrementa o contador e se CNT=0, retorna
	BRA		ATRASO2	; se CNT!=0, vai para a parte interna do loop
	RETURN
ATRASO2:			
	MOVLW	0		; a parte interna do loop utiliza o W, repetindo 256 vezes
ATRASO3:
	ADDLW	1		; soma 1 ao W
	BNZ		ATRASO3	; repete se W!=0
	BRA		REP		; se W=0 volta para a parte externa do loop
	END
