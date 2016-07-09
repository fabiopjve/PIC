LIST P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM> 
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

ORG	0x0000
	MOVLW	0x85		; 
	MOVWF	FSR		; seleciona o registrador 0x85 (TRISA)
	CLRF	INDF		; apaga o registrador 0x85 (TRISA)
	INCF	FSR,F		; incrementa FSR (0x86 – TRISB)
	MOVLW	B'00001111'	; configura os 4 primeiros pinos como entradas ...
	MOVWF	INDF		; e os quatro MSB como saídas (registrador TRISB)
	SLEEP			; fim do programa
END
