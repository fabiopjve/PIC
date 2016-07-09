LIST 	P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
A0	EQU 0x20
B0	EQU 0x21
C0	EQU 0x22
ORG	0x0000
	GOTO	INICIO
DIV8_8D:
	CLRF	C0		; apaga a variável C0
DIV8_8D_LOOP:
	MOVF	B0,W		; copia a divisor para W
	SUBWF	A0,F		; subtrai o divisor (B0) do dividendo (A0)
	BTFSS	STATUS,C		; testa para ver se houve empréstimo
	GOTO	DIV8_8D_MENOR	; dividendo menor que zero, pula para 
				; DIV8_8_D_MENOR
	BTFSC	STATUS,Z		; testa se o dividendo foi igual a zero
	GOTO	DIV8_8D_MENOR	; se o dividendo igual a zero, pula para 
					; DIV8_8_D_MENOR
	INCF	C0,F		; se o dividendo maior que zero incrementa o 
				; quociente
	GOTO	DIV8_8D_LOOP	; retorna para novo ciclo de subtração
DIV8_8D_MENOR:
	INCF	C0,F		; se o dividendo <= zero, incrementa quociente e..
	RETURN			; retorna
INICIO:
	MOVLW	D'180'	
	MOVWF	A0		; A0=180 decimal
	MOVLW	D'5'		
	MOVWF	B0		; B0=5 decimal
	CALL	DIV8_8D		; chamada de sub-rotina
	SLEEP			; coloca o chip em modo SLEEP
END
; resultado: 180/5=36 ou 0x24 hexadecimal. C0=0x24 hexadecimal. Z=’0’, DC=’1’ e 
; C=’1’
