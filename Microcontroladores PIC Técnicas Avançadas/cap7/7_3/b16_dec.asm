; BIN16DEC - Conversão de binário 16 bits em decimal
; Entrada:
; 	A0 - LSB binário
;	A1 - MSB binário
; Saída:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
;	D3 - milhares
;	D4 - dezenas de milhares
; As variáveis D0,D1,D2,D3,D4,B0,B1,A0,A1,TEMP0 e TEMP1 precisam ser definidas 
; previamente no programa. 
BIN16DEC:
	CLRF	D0		; apaga as unidades
	CLRF	D1		; apaga as dezenas
	CLRF	D2		; apaga as centenas
	CLRF	D3		; apaga as milhares
	CLRF	D4		; apaga as dezenas de milhares
BIN16DEC_1:
	MOVF	A0,W		; copia o LSB binário ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB binário ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	0x10		; 
	MOVWF	B0		; 
	MOVLW	0x27		;
	MOVWF	B1		; B=0x2710 (10000 decimal)
	CALL	SUB16B		; subtrai 10000 decimal do valor binário
	BTFSS	STATUS,C		; testa se o resultado é positivo ou zero
	GOTO	BIN16DEC_2	; não ? então vai para a próxima fase
	INCF	D4,F		; sim ? então incrementa as dezenas de milhares
	GOTO	BIN16DEC_1	; reinicia o ciclo
BIN16DEC_2:
	MOVF	TEMP0,W		; retorna o valor anterior ...
	MOVWF	A0		; ... de A0
	MOVF	TEMP1,W		; retorna o valor anterior ...
	MOVWF	A1		; ... de A1
BIN16DEC_3:
	MOVF	A0,W		; copia o LSB binário ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB binário ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	0xE8		;
	MOVWF	B0		;
	MOVLW	0x03		;
	MOVWF	B1		; B=03E8 (1000 decimal)
	CALL	SUB16B		; subtrai 1000 decimal do valor binário
	BTFSS	STATUS,C	; testa se o resultado é positivo ou zero
	GOTO	BIN16DEC_4	; não ? então vai para a próxima fase
	INCF	D3,F		; sim ? então incrementa as milhares 
	GOTO	BIN16DEC_3	; reinicia o ciclo
BIN16DEC_4:
	MOVF	TEMP0,W		; retorna o valor anterior ...
	MOVWF	A0		; ... de A0
	MOVF	TEMP1,W		; retorna o valor anterior ...
	MOVWF	A1		; ... de A1
BIN16DEC_5:
	MOVF	A0,W		; copia o LSB binário ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB binário ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	D’100’		;
	MOVWF	B0		;
	CLRF	B1		; B=100 decimal
	CALL	SUB16B		; subtrai 100 decimal do valor binário (A)
	BTFSS	STATUS,C	; testa se o resultado é positivo ou zero
	GOTO	BIN16DEC_6	; não ? então vai para a próxima fase
	INCF	D2,F		; sim ? então incrementa as centenas
	GOTO	BIN16DEC_5	; reinicia o ciclo
BIN16DEC_6:
	MOVF	TEMP0,W		; retorna o valor anterior ...
	MOVWF	A0		; ... de A0
	MOVF	TEMP1,W		; retorna o valor anterior ...
	MOVWF	A1		; ... de A1
BIN16DEC_7:
	MOVF	A0,W		; copia o LSB binário ...
	MOVWF	TEMP0		; ... para TEMP0
	MOVF	A1,W		; copia o MSB binário ...
	MOVWF	TEMP1		; ... para TEMP1
	MOVLW	D’10’		;
	MOVWF	B0		;
	CLRF	B1		; B=10 decimal
	CALL	SUB16B		; subtrai 10 decimal do valor binário (A)
	BTFSS	STATUS,C	; testa se o resultado é positivo ou zero
	GOTO	BIN16DEC_8	; não ? então vai para fase final
	INCF	D1,F		; sim ? então incrementa as dezenas
	GOTO	BIN16DEC_7	; reinicia o ciclo
BIN16DEC_8:
	MOVF	TEMP0,W		; copia o valor temporário restante ...
	MOVWF	D0		; ... para as unidades
	RETURN			; retorna
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
