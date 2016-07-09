; SUB16 - Subtrai dois valores de 16 bits (A=A-B)
; Entrada
;	A0,A1 - Minuendo,  B0,B1 - Subtraendo  (0-LSB e 1-MSB)
; Saída
;	A0,A1 - Resultado  (A0-LSB, A1-MSB)
; As variáveis A0,A1,B0,B1 devem ser definidas previamente no programa

SUB16:
	MOVF	B0,W		; subtrai os 8 bits
	SUBWF	A0,F		; menos significativos
	BTFSS	STATUS,C	; testa se houve empréstimo
	GOTO	SUB2		; se houve pula para SUB2
	MOVF	B1,W		; se não, subtrai os
	SUBWF	A1,F		; 8 bits mais significativos e
	RETURN			; retorna
SUB2:
	MOVF	B1,W		; subtrai os 8 bits 
	SUBWF	A1,F		; mais significativos e
	MOVLW	0X01		; subtrai 1 de A1 por conta
	SUBWF	A1,F		; do empréstimo na subtração do LSB
RETURN				; retorna
