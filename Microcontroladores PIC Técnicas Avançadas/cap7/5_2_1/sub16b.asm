; SUB16B - Subtrai dois valores de 16 bits (A=A-B) flags OK
; Entrada
; 	A0,A1 - Subtraendo,  B0,B1 - Minuendo  (0-LSB, 1-MSB)
; Sa�da
; 	A0,A1 - resultado da subtra��o
;
; Os flags C e Z s�o alterados ao final da opera��o de acordo com o resultado:
;
; C=�1� - n�o houve empr�stimo (resultado positivo)
; C=�0� - houve empr�stimo (resultado negativo)
; Z=�1� - resultado igual a zero
; Z=�0� - resultado diferente de zero
;
SUB16B:
	MOVF	B0,W
	SUBWF	A0,F
	MOVLW	0x01
	BTFSS	STATUS,C
	SUBWF	A1,F
	BTFSS	STATUS,C
	GOTO	EMPRESTA
	MOVF	B1,W
	SUBWF	A1,F
FIM_SUB16B:
	MOVF	A0,F
	BTFSC	STATUS,Z
	MOVF	A1,F
	RETURN
EMPRESTA:
	MOVF	B1,W
	SUBWF	A1,F
	BCF	STATUS,C
	GOTO	FIM_SUB16B
