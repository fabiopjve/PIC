LIST 	P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
A0	EQU 0x20
B0	EQU 0x21
C0	EQU 0x22
C1	EQU 0x23
ORG	0x0000
	GOTO	INICIO
MULTB8X8:
	CLRF	C0		; limpa variável C0
	CLRF	C1		; limpa variável C1
	MOVF	A0,W		; copia o valor de A0 ...
	MOVWF	C0		; para a variável C0
LOOP_MULTB:
	DECF	B0,F		; decrementa B0
	BTFSC	STATUS,Z		; se B0=0 ...
	RETURN			; retorna da sub-rotina
	MOVF	A0,W		; copia A0 para o W
	ADDWF	C0,F		; soma o A0 (em W) com C0 e guarda o resultado em C0
	BTFSC	STATUS,C		; se houver transbordo do C0 ...
	INCF	C1,F		; incrementa o C1
	GOTO	LOOP_MULTB	; retorna ao LOOP_MULTB para mais um ciclo
INICIO:
	MOVLW	0x0A		; inicializa a variável A0
	MOVWF	A0		; com o valor 0x0A (10 decimal)
	MOVLW	0x03		; inicializa a variável B0
	MOVWF	B0		; com o valor 0x03
	CALL	MULTB8X8		; chama sub-rotina de multiplicação
	SLEEP			; o programa termina aqui
; resultado: C0=0x1E (30 decimal) e C1=0. Z=’1’, C=’0’ e DC=’0’
END
