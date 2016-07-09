; Esta sub-rotina verifica a paridade de um número fornecido em W e retorna em
; W o valor 0 se a paridade é par ou 1 se a paridade é ímpar.
; O programa utiliza uma variável local: VTEMP.
PARIDADE:	
	MOVWF	VTEMP		; copia o valor a ser verificado para VTEMP
	CLRW			; apaga W
	BCF	STATUS,C		; limpa o flag de carry
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 0)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 1)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 2)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 3)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 4)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 5)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 6)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	RRF	VTEMP,F		; rotaciona VTEMP à direita
	BTFSC	STATUS,C		; verifica o bit que transbordou do VTEMP (bit 7)
	ADDLW	D’1’		; se for igual a ‘1’, soma um ao W
	ANDLW	0x01		; apaga todos os bits menos o bit 0 do W
	RETURN			; retorna
