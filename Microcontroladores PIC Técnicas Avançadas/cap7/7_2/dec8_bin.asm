; DEC8BIN - Conversão de decimal em binário 8 bits
; Entrada:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
; Saída:
; 	D0 - resultado em binário/hexadecimal
; As variáveis D0,D1 e D2 precisam ser definidas previamente no programa e são
; alteradas pela sub-rotina
DEC8BIN:
	MOVLW	0x01		; copia 1 em W
	SUBWF	D2,F		; subtrai um das centenas ...
	BTFSS	STATUS,C		; o resultado é positivo ou zero ?
	GOTO	DEC8BIN_1	; não ? então vai para a próxima fase
	MOVLW	D’100’		; sim ? então adiciona 100 decimal ...
	ADDWF	D0,F		; ... ao resultado binário armazenado em D0
	GOTO	DEC8BIN		; reinicia o ciclo
DEC8BIN_1:
	MOVLW	0x01		; copia 1 em W
	SUBWF	D1,F		; subtrai 1 das dezenas ...
	BTFSS	STATUS,C		; o resultado é positivo ou zero ?
	RETURN			; não ? então retorna, a conversão terminou
	MOVLW	D’10’		; sim ? então soma 10 decimal
	ADDWF	D0,F		; ao valor a resultado binário em D0
	GOTO	DEC8BIN_1	; reinicia o ciclo
