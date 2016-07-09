; DEC8BIN - Convers�o de decimal em bin�rio 8 bits
; Entrada:
; 	D0 - unidades
;	D1 - dezenas
;	D2 - centenas
; Sa�da:
; 	D0 - resultado em bin�rio/hexadecimal
; As vari�veis D0,D1 e D2 precisam ser definidas previamente no programa e s�o
; alteradas pela sub-rotina
DEC8BIN:
	MOVLW	0x01		; copia 1 em W
	SUBWF	D2,F		; subtrai um das centenas ...
	BTFSS	STATUS,C		; o resultado � positivo ou zero ?
	GOTO	DEC8BIN_1	; n�o ? ent�o vai para a pr�xima fase
	MOVLW	D�100�		; sim ? ent�o adiciona 100 decimal ...
	ADDWF	D0,F		; ... ao resultado bin�rio armazenado em D0
	GOTO	DEC8BIN		; reinicia o ciclo
DEC8BIN_1:
	MOVLW	0x01		; copia 1 em W
	SUBWF	D1,F		; subtrai 1 das dezenas ...
	BTFSS	STATUS,C		; o resultado � positivo ou zero ?
	RETURN			; n�o ? ent�o retorna, a convers�o terminou
	MOVLW	D�10�		; sim ? ent�o soma 10 decimal
	ADDWF	D0,F		; ao valor a resultado bin�rio em D0
	GOTO	DEC8BIN_1	; reinicia o ciclo
