LIST 	P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
A0	EQU 0x20
ORG	0x0000
	MOVLW	D'25'
	MOVWF	A0		; A0=D�25�
	MULT2	A0,4		; multiplica  A0 por 4
	MOVF	A0,W		; W=D�100�
	SLEEP
END
