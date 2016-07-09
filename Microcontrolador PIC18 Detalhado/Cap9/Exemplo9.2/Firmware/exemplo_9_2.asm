	LIST P=18F4520
	#include <P18F4520.INC>

; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF

CBLOCK 	0x010
	ADC_RESH, ADC_RESL
ENDC
	org 	0x0000		; vetor de reset
	BRA		INICIO
	org		0x0008		; vetor de interrupção
	BTFSC	PIR1,ADIF
	BRA		LE_ADC		; se ADIF=1, le o ADC
	RETFIE
LE_ADC:
	MOVFF	ADRESL,ADC_RESL	; copia a parte baixa do resultado 
	MOVFF	ADRESH,ADC_RESH	; copia a parte alta do resultado 
	BSF		ADCON0,GO			; inicia uma nova conversão
	BCF		STATUS,C				
	RRCF	ADC_RESH,F		; divide o resultado por dois
	RRCF	ADC_RESL,F
	BCF		STATUS,C				
	RRCF	ADC_RESH,F		; divide o resultado por dois
	RRCF	ADC_RESL,F
	BCF		PIR1,ADIF			; apaga o flag de interrupção do ADC
	RETFIE					
INICIO:
	CLRF	TRISB		; todos os pinos da porta B como saídas
	MOVLW	0xA1		; resultado justificado à direita
	MOVWF	ADCON2		; aquisição 8TAD, CLK=FOSC/8
	MOVLW	0x0D
	MOVWF	ADCON1		; AN0 e AN1 no modo analógico
	MOVLW	0x05
	MOVWF	ADCON0		; canal 1, ADC ligado
	BSF		PIE1,ADIE		; habilita a interrupção do ADC
	BSF		INTCON,PEIE	; habilita as interrupções periféricas
	BSF		INTCON,GIE	; habilita as interrupções globais
	BSF		ADCON0,GO		; inicia uma conversão
LOOP:
	CLRF	LATB		; apaga todos os leds
	MOVLW	0x3F	
	CPFSGT	ADC_RESL		; compara o resultado com 0x3F
	BRA		LED1		; acende o led L1 se o resultado <= 0x3F
	MOVLW	0x7F
	CPFSGT	ADC_RESL		; compara o resultado com 0x7F
	BRA		LED2		; acende o led L2 se o resultado <= 0x7F
	MOVLW	0xBF
	CPFSGT	ADC_RESL		; compara o resultado com 0xBF
	BRA		LED3		; acende o led L3 se o resultado <= 0xBF
	MOVLW	0xBE
	CPFSLT	ADC_RESL		; se o resultado for >= 0xBE
	BSF		LATB,3		; acende o led L4
	BRA		LOOP
LED1:
	BSF		LATB,0		; acende o led L1
	BRA		LOOP
LED2:
	BSF		LATB,1		; acende o led L2
	BRA		LOOP
LED3:
	BSF		LATB,2		; acende o led L3
	BRA		LOOP
	END
