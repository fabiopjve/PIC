;******************************************************************************
; DEC2BIN16 - Converte um número decimal para binário 16 bits
; Entrada
; 	D0,D1,D2,D3,D4 - Dígitos decimais (unidades, dezenas, centenas, milhares 
;     e dezenas de milhares
; Saída
;	A0,A1 - resultado binário (A0-LSB e A1-MSB)
;
; Tamanho=35 instruções  Tempo : 2+34+2=38 ciclos de instrução
;
; bin = (((D1+D3+D4*256)*2+
;	D2+D2*16+D3*256)*2+
;	D1+D2*16-D3*16+D4*16*256)*2+
;	D0+D4*16-D4*256
;
; Janeiro 24, 2001 por Nikolai Golovchenko E-mail: golovchenko@mail.ru
;******************************************************************************
DEC2BIN16:
	MOVF	D1,W	; copia as dezenas em W
	ADDWF	D3,W	; soma as milhares com as dezenas e coloca em W
	MOVWF	A0	; copia a soma das milhares com as dezenas e guarda em A0
	ADDWF	A0,F	; soma A0 com ele mesmo ou seja, multiplica A0 por 2
	RLF	D4,W	; multiplica as dezenas de milhares por 2 e coloca em W
	MOVWF	A1	; armazena o resultado em A1
	SWAPF	D2,W	; inverte os nibbles das centenas e coloca em W
	ADDWF	D2,W	; soma as centenas e coloca em W
	ADDWF	A0,F	; soma o resultado ao A0
	MOVF	D3,W	; copia as milhares em W
	ADDWF	A1,F	; soma com A1
	RLF	A0,F	; multiplica o resultado geral ...
	RLF	A1,F	; ... por 2
	SWAPF	D2,W	; inverte os nibbles das centenas e coloca em W
	ADDWF	D1,W	; soma com as dezenas e coloca em W
	ADDWF	A0,F	; soma ao resultado em A0
	SWAPF	D4,W	; inverte os nibbles das dezenas de milhares
	SKPNC		; pula a próxima instrução se o flag C=0
	IORLW	0x01	; seta o bit 0 de W
	ADDWF	A1,F	; soma o W com o resultado MSB
	SWAPF	D3,W	; inverte os nibbles das milhares e coloca em W
	SUBWF	A0,F	; subtrai do resultado LSB em A0
	SKPC		; pula a próxima instrução se o flag C=1
	DECF	A1,F	; decrementa o resultado MSB
	CLRC		; limpa o flag C (C=0)
	RLF	A0,F	; multiplica o resultado atual ...
	RLF	A1,F	; ... por 2
	SWAPF	D4,W	; inverte os nibbles das dezenas de milhares e coloca em W
	ADDWF	D0,W	; soma com as unidades e coloca em W
	ADDWF	A0,F	; soma ao resultado temporário A0 
	MOVF	D4,W	; copia as dezenas de milhares em W
	SKPNC		; pula a próxima instrução se o flag C=0
	DECF	D4,W	; decrementa as dezenas de milhares e coloca em W (W=D4-1)
	SUBWF	A1,F	; subtrai do resultado MSB em A1
	RETURN		; retorna da sub-rotina
;******************************************************************************
