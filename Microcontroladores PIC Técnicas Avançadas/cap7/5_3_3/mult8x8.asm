; MULTIPLICA8X8 - Multiplica dois n�meros de 8 bits
; Entrada
;	A0,B0 - Fatores da multiplica��o
; Sa�da
;	B0,B1 - Produto da multiplica��o (B0 � LSB, B1 � MSB)
; � necess�rio definir previamente as vari�veis A0, B0 e B1 
MULT8	MACRO	BIT
	BTFSC	A0, BIT
	ADDWF	B1,F
	RRF	B1,F
	RRF	B0,F
ENDM
MULTIPLICA8X8:
	MOVF	B0, W
	CLRF	B0
	CLRF	B1
	BCF	STATUS,C
	MULT8	0
	MULT8	1
	MULT8	2
	MULT8	3
	MULT8	4
	MULT8	5
	MULT8	6
	MULT8	7
	RETURN
