; DIV8_8D - Divide dois números (A0 e B0) e coloca o resultado em C0;
; Entrada
;	A0 - Dividendo, B0 - Divisor
; Saída
;	C0 - Quociente
; As variáveis A0,B0 e C0 precisam ser definidas previamente;
; Esta rotina não testa se o divisor é zero !
DIV8_8D:
	CLRF	C0			; apaga a variável C0
DIV8_8D_LOOP:
	MOVF	B0,W			; copia a divisor para W
	SUBWF	A0,F			; subtrai o divisor (B0) do dividendo (A0)
	BTFSS	STATUS,C			; testa para ver se houve empréstimo
	GOTO	DIV8_8D_MENOR		; dividendo menor que zero, pula para 
					; DIV8_8_D_MENOR
	BTFSC	STATUS,Z			; testa se o dividendo foi igual a zero
	GOTO	DIV8_8D_MENOR		; se o dividendo igual a zero, pula para 
					; DIV8_8_D_MENOR
	INCF	C0,F			; se o dividendo maior que zero incrementa o 
					; quociente
	GOTO	DIV8_8D_LOOP		; retorna para novo ciclo de subtração
DIV8_8D_MENOR:
	INCF	C0,F			; se o dividendo <= zero, incrementa quociente 
	RETURN				; e ... retorna
