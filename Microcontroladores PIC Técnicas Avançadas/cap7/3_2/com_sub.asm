;programa 2 utilizando sub-rotina
LIST 	P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
V_A	EQU 0X20
V_B	EQU 0X21
V_C	EQU 0X22
TEMP	EQU 0X24
ORG	0X0000
	MOVLW	0X15		; armazena o valor hexadecimal 0x15
	MOVWF	V_A		; na variável V_A
	MOVLW	0X20		; armazena o valor hexadecimal 0x20
	MOVWF	V_B		; na variável V_B
	MOVLW	D'100'		; armazena o valor decimal 100 (0x64)
	MOVWF	V_C		; na variável V_C
; calcula a soma de V_C
	CALL	SOMA
	MOVWF	V_C
	MOVF	V_B,W
	CALL	SOMA
	MOVWF	V_B
	CALL	SOMA
	MOVWF	V_A
; abaixo está a sub-rotina chamada de SOMA. O valor da variável deverá ser
; passado pelo registrador W. Ao final da sub-rotina, W irá conter a soma.
SOMA:
	MOVWF	TEMP
	SWAPF	TEMP,W
	ADDWF	TEMP,W
	ANDLW	0X0F
	BTFSC	STATUS,DC
	IORLW	B'00010000'
	RETURN	
END
