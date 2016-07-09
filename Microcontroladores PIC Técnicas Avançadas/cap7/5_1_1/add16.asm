; ADD16 - Soma dois valores de 16 bits (A=A+B)
; Entrada
;	A0,A1,B0,B1 - (0-LSB, 1-MSB)
; Saída
; 	A0=A0+B0 e A1=A1+B1
; As variáveis A0,A1,B0 e B1 precisam ser definidas previamente
ADD16:
	MOVF	B0,W		; adiciona os 8 bits
	ADDWF	A0,F		; menos significativos
	BTFSC	STATUS,C		; testa se houve transbordo
	GOTO	ADD16_2		; se houve pula para ADD16_2
	MOVF	B1,W		; se não, adiciona os
	ADDWF	A1,F		; 8 bits mais significativos e
	RETURN			; retorna
ADD16_2:
	MOVF	B1,W		; adiciona os 8 bits 
	ADDWF	A1,F		; mais significativos e
	MOVLW	0x01		; soma o transbordo dos 8 bits LSB
	ADDWF	A1,F		; ao dígito MSB
	RETURN			; retorna
