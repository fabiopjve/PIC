;programa 1 sem sub-rotina
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
; agora soma a variável V_C
	ANDLW	0X0F		; W=0x04
	MOVWF	TEMP		; TEMP=0X04
	SWAPF	V_C,W		; W=0X46
	ANDLW	0X0F		; W=0X06
	ADDWF	TEMP,W		; W=TEMP+W ou seja W=0x04+0x06=0x0A
	MOVWF	V_C		; V_C=0x0A
; agora soma a variável V_B
	MOVF	V_B,W		; W=V_B ou seja, W=0x20
	ANDLW	0X0F		; W=0x00
	MOVWF	TEMP		; TEMP=0X00
	SWAPF	V_B,W		; W=0x02
	ANDLW	0X0F		; W=0x02
	ADDWF	TEMP,W		; W=TEMP+W -> W=0x00+0x02=0x02
	MOVWF	V_B		; V_B=0x02
; agora soma a variável V_A
	MOVF	V_A,W		; W=0x15
	ANDLW	0X0F		; W=0x05
	MOVWF	TEMP		; TEMP=0x05
	SWAPF	V_A,W		; W=0x51
	ANDLW	0X0F		; W=0x01
	ADDWF	TEMP,W		; W=TEMP+W -> W=0x05+0x01=0x06
	MOVWF	V_A		; V_A=0x06
END
