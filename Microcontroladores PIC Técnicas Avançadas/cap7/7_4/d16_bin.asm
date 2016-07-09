; DEC16BIN - Conversão de decimal em binário 16 bits
; Entrada:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
;	D3 - milhares
;	D4 - dezenas de milhares
; Saída:
; 	A0 - LSB binário
;	A1 - MSB binário
; As variáveis D0,D1,D2,D3,D4,B0,B1,A0,A1,TEMP0 e TEMP1 precisam ser definidas 
; previamente no programa.
DEC16BIN:
	CLRF	A1		; apaga o resultado MSB
	MOVF	D0,W		; copia as unidades para W
	MOVWF	A0		; copia as unidades para o resultado LSB
DEC16BIN_1:
	MOVLW	0x01		; subtrai 1 ...
	SUBWF	D4,F		; das dezenas de milhares
	BTFSS	STATUS,C	; verifica se o resultado é negativo
	GOTO	DEC16BIN_2	; se for negativo vai para DEC16BIN_2
	MOVLW	0x27		; soma ...
	ADDWF	A1,F		; ...
	MOVLW	0x10		; 0x2710 (10000 decimal) ...
	ADDWF	A0,F		; ao resultado
	BTFSC	STATUS,C	; verifica se o resultado lSB transbordou
	INCF	A1,F		; se transbordou, incrementa o MSB
	GOTO	DEC16BIN_1	;
DEC16BIN_2:
	MOVLW	0x01		; subtrai 1 ...
	SUBWF	D3,F		; das milhares
	BTFSS	STATUS,C	; verifica se o resultado é negativo
	GOTO	DEC16BIN_3	; se for negativo vai para DEC16BIN_3
	MOVLW	0x03		; soma ...
	ADDWF	A1,F		; ...
	MOVLW	0xE8		; ...
	ADDWF	A0,F		; 0x03E8 (10000 decimal) ao resultado
	BTFSC	STATUS,C	; verifica se o resultado LSB transbordou
	INCF	A1,F		; se transbordou, incrementa o MSB
	GOTO	DEC16BIN_2	;
DEC16BIN_3:
	MOVLW	0x01		; subtrai 1 ...
	SUBWF	D2,F		; das centenas
	BTFSS	STATUS,C	; verifica se o resultado é negativo
	GOTO	DEC16BIN_4	; se for negativo vai para DEC16BIN_4
	MOVLW	D'100'		; soma ...
	ADDWF	A0,F		; 100 decimal ao resultado
	BTFSC	STATUS,C	; verifica se o resultado LSB transbordou
	INCF	A1,F		; se transbordou, incrementa o MSB
	GOTO	DEC16BIN_3	;
DEC16BIN_4:
	MOVLW	0x01		; subtrai 1 ...
	SUBWF	D1,F		; das dezenas
	BTFSS	STATUS,C	; verifica se o resultado é negativo
	RETURN			; se for negativo, retorna
	MOVLW	D'10'		; ...
	ADDWF	A0,F		; soma 10 ao resultado LSB
	BTFSC	STATUS,C	; verifica se transbordou
	INCF	A1,F		; se transbordou, incrementa o resultado MSB
	GOTO	DEC16BIN_4	; 

