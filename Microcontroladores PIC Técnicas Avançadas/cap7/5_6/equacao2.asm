	LIST P=16F627
	INCLUDE <P16F627.INC>
	INCLUDE <MACROS.ASM> 
	__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

A0	EQU 0x20

	ORG 	0x0000	
			;				Z	DC	C
	MOVLW	0x07	; W=0x07			X	X	X
	MOVWF	A0	; A0=0x07			X	X	X
	MULT2	A0,4	; A0=0x1C (7x4=28)		X	X	0
	ADDWF	A0,F	; A0=0x23=35 decimal		0	1	0
	SLEEP
	END

