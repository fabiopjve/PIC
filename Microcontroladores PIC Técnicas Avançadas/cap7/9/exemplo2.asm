LIST P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM> 
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

ORG	0x0000
	BSF	STATUS,IRP	; seleciona os bancos 2 e 3 para acesso indireto
	MOVLW	0x81		; endereço 0x81 (banco 3, registrador OPTION_REG)
	MOVWF	FSR		; seleciona o registrador 0x81 (OPTION_REG)
	CLRF	INDF		; apaga o registrador 0x81 (OPTION_REG)
	BCF	STATUS,IRP	; seleciona os bancos 0 e 1 para acesso indireto
	MOVLW	0x06		; endereço 0x06 (banco 1, registrador PORTB)
	MOVWF	FSR		; seleciona o registrador 0x06 (PORTB)
	MOVF	INDF,W		; realiza a leitura do registrador PORTB e coloca 
				; em W
	SLEEP			; fim do programa
END
