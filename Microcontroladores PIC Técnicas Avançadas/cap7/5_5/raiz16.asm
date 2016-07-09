; Raiz Quadrada Inteira de um número de 16 Bits
; Variáveis utilizadas : A0(LSB) e A1(MSB): radicando, W raiz quadrada
; Outras variáveis utilizadas: B0, B1, TEMP1, TEMP2 e TEMP3
; Esta sub-rotina utiliza a sub-rotina SUB16
RAIZ16:
	CLRF	TEMP1		; apaga o registrador temporário de raiz 
	CLRF	B1		; 
	MOVLW	0x01		;
	MOVWF	B0		; inicializa o subtrator inicialmente para 0x0001
RAIZ16_LOOP:
	CALL	SUB16		; subtrai o subtrator do radicando atual
	BTFSS	STATUS,C		; testa para ver se o radicando é menor que zero
	GOTO	RAIZ16_RET	; se menor, vai para a saída da sub-rotina
	MOVF	A0,F		; testa se A0 ...
	BTFSS	STATUS,Z		; é igual a zero ...

	GOTO	RAIZ16_CONT	; se não, vai para RAIZ16_CONT
	MOVF	A1,F		; testa se A1 ...
	BTFSC	STATUS,Z		; é igual a zero ...
	GOTO	RAIZ16_FIM	; se é, vai para RAIZ16_FIM
RAIZ16_CONT:
	INCF	TEMP1,F		; incrementa o resultado atual da raiz
	MOVLW	0x02		; adiciona 2 ...
	ADDWF	B0,F		; ao subtrator ...
	BTFSC	STATUS,C		; verifica se houve transbordo do LSB ...
	INCF	B1,F		; e se houve incrementa um no MSB do subtrator
	GOTO	RAIZ16_LOOP	; reinicia o loop para encontrar a raiz
RAIZ16_RET:
	MOVF	TEMP1,W		; copia o resultado da raiz atual para o W
	RETURN			; retorna da sub-rotina

RAIZ16_FIM:
	INCF	TEMP1,W		; incrementa um no resultado da raiz atual e 
				; guarda no W
	RETURN			; retorna da sub-rotina
SUB16:
	MOVF	B0,W		; subtrai os 8 bits
	SUBWF	A0,F		; menos significativos
	BTFSS	STATUS,C		; testa se houve empréstimo
	GOTO	SUB2		; se houve pula para SUB2
	MOVF	B1,W		; se não, subtrai os
	SUBWF	A1,F		; 8 bits mais significativos e
	RETURN			; retorna
SUB2:
	MOVF	B1,W		; subtrai os 8 bits 
	SUBWF	A1,F		; mais significativos e
	MOVLW	0x01		; subtrai 1 de A1 por conta
	SUBWF	A1,F		; do empréstimo na subtração do LSB
	RETURN			; retorna
