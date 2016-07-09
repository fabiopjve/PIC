	LIST P=18F4520
	#include <P18F4520.INC>

; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF
	CONFIG	CCP2MX=PORTBE

#define S1	  PORTB,0
#define S2	  PORTB,1

CBLOCK 	0x010
	CNT				; variável CNT utilizada na subrotina de atraso
ENDC

	org 	0x0000		; vetor de reset
INICIO:
	BCF		TRISB,3		; configura RB3 como saída
	MOVLW	0x0F	
	MOVWF	ADCON1		; configura os pinos do A/D para o modo digital
	MOVLW	0x04
	MOVWF	T2CON		; liga o timer 2 (prescaler = 1)
	MOVLW	0x0C
	MOVWF	CCP2CON		; CCP2 no modo PWM
	MOVLW	0x7F
	MOVWF	CCPR2L		; ciclo ativo = metade do período (PR2=255, valor default)	
REPETE:
	BTFSS	S1
	BRA		DECREMENTA	; se S1 pressionada, decrementa ciclo ativo
	BTFSS	S2
	BRA		INCREMENTA	; se S2 pressionada, incrementa ciclo ativo
	BRA		REPETE		; repete o loop
DECREMENTA:		; decrementa o ciclo ativo se maior que zero
	MOVLW	0
	CPFSEQ	CCPR2L
	DECF	CCPR2L,F
	BRA		ATRASO		; atrasa alguns milisegundos
INCREMENTA:		; incrementa o ciclo ativo se menor que 255
	MOVLW	0xFF
	CPFSEQ	CCPR2L
	INCF	CCPR2L,F
ATRASO:			; atraso de aproximadamente 7,7ms
	MOVLW	.10
	MOVWF	CNT		; loop externo = 10 vezes
ATRASO_A:
	MOVLW	0		; loop interno
ATRASO_B:
	ADDLW	1	
	BNZ		ATRASO_B		; repete loop interno até chegar a zero
	DECFSZ	CNT,F		
	BRA		ATRASO_A		; repete loop externo até chegar a zero
	BRA		REPETE
	END
