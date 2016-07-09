; BIN8DEC - Convers�o de bin�rio 8 bits em decimal
; Entrada:
; 	W - n�mero em bin�rio a ser convertido
; Sa�da:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
; As vari�veis D0,D1 e D2 precisam ser definidas previamente no programa
BIN8DEC:
	MOVWF	D0		; copia o n�mero a ser convertido para a vari�vel 
				; de unidades
	CLRF	D1		; limpa as dezenas
	CLRF	D2		; limpa as centenas
BIN8DEC_1:
	MOVLW	D�100�		; subtrai 100 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda em W
	BTFSS	STATUS,C		; o resultado � positivo ou zero ?
	GOTO	BIN8DEC_2	; n�o ? ent�o vai para a pr�xima parte
	MOVWF	D0		; sim ? ent�o copia o valor para as unidades ...
	INCF	D2,F		; incrementa um nas centenas
	GOTO	BIN8DEC_1	; e reinicia o ciclo
BIN8DEC_2:
	MOVLW	D�10�		; subtrai 10 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda o 
				; resultado em W
	BTFSS	STATUS,C		; o resultado � positivo ou zero ?
	RETURN			; n�o ? ent�o retorna, a convers�o terminou
	MOVWF	D0		; sim ? ent�o copia o resultado em W para as 
				; unidades ...
	INCF	D1,F		; incrementa um nas dezenas 
	GOTO	BIN8DEC_2	; e reinicia o ciclo
