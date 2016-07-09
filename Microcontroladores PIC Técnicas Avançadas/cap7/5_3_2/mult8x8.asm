; Multiplica dois números (A0 e B0) e armazena o resultado em C0 E C1.
; é necessário definir as variáveis A0, B0 , C0 e C1
MULTB8X8:
	CLRF	C0		; limpa variável C0
	CLRF	C1		; limpa variável C1
	MOVF	A0,W		; copia o valor de A0 ...
	MOVWF	C0		; para a variável C0
LOOP_MULTB:
	DECF	B0,F		; decrementa B0
	BTFSC	STATUS,Z		; se B0=0 ...
	RETURN			; retorna da sub-rotina
	MOVF	A0,W		; copia A0 para o W
	ADDWF	C0,F		; soma o A0 (em W) com C0 e guarda o resultado em C0
	BTFSC	STATUS,C		; se houver transbordo do C0 ...
	INCF	C1,F		; incrementa o C1
	GOTO	LOOP_MULTB	; retorna ao LOOP_MULTB para mais um ciclo
