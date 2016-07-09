; BIN8DEC - Conversão de binário 8 bits em decimal
; Entrada:
; 	W - número em binário a ser convertido
; Saída:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
; As variáveis D0,D1 e D2 precisam ser definidas previamente no programa
BIN8DEC:
	MOVWF	D0		; copia o número a ser convertido para a variável 
				; de unidades
	CLRF	D1		; limpa as dezenas
	CLRF	D2		; limpa as centenas
BIN8DEC_1:
	MOVLW	D’100’		; subtrai 100 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda em W
	BTFSS	STATUS,C		; o resultado é positivo ou zero ?
	GOTO	BIN8DEC_2	; não ? então vai para a próxima parte
	MOVWF	D0		; sim ? então copia o valor para as unidades ...
	INCF	D2,F		; incrementa um nas centenas
	GOTO	BIN8DEC_1	; e reinicia o ciclo
BIN8DEC_2:
	MOVLW	D’10’		; subtrai 10 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda o 
				; resultado em W
	BTFSS	STATUS,C		; o resultado é positivo ou zero ?
	RETURN			; não ? então retorna, a conversão terminou
	MOVWF	D0		; sim ? então copia o resultado em W para as 
				; unidades ...
	INCF	D1,F		; incrementa um nas dezenas 
	GOTO	BIN8DEC_2	; e reinicia o ciclo
