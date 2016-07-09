LIST 	P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
A0	EQU 0x20
A1	EQU 0x21
B0	EQU 0x22
B1	EQU 0x23
ORG	0x0000
	GOTO	INICIO
SUB16:
	MOVF	B0,W	; subtrai os 8 bits
	SUBWF	A0,F	; menos significativos
	BTFSS	STATUS,C	; testa se houve empréstimo
	GOTO	SUB2	; se houve pula para SUB2
	MOVF	B1,W	; se não, subtrai os
	SUBWF	A1,F	; 8 bits mais significativos e
	RETURN		; retorna
SUB2:
	MOVF	B1,W	; subtrai os 8 bits 
	SUBWF	A1,F	; mais significativos e
	MOVLW	0x01	; subtrai 1 de A1 por conta
	SUBWF	A1,F	; do empréstimo na subtração do LSB
RETURN		; retorna
INICIO:
	MOVLW	0x00	; 
	MOVWF	A0	; variável A0=0x00
	MOVLW	0x10	; 
	MOVWF	A1	; variável A1=0x10 (A=0x1000)
	MOVLW	0xFF	;
	MOVWF	B0	; variável B0=0xFF
	MOVLW	0x01	;
	MOVWF	B1	; variável B1=0x01 (B=0x01FF)
	CALL	SUB16	; subtrai A-B (resultado= A1=0x0E e A0=0x01 => A=0x0E01)
	SLEEP		; o programa termina aqui
END
