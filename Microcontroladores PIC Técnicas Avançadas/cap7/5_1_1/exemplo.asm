LIST 	P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
A0	EQU 0x20
A1	EQU 0x21
B0	EQU 0x22
B1	EQU 0x23
ORG	0x0000
	GOTO	INICIO
ADD16:
	MOVF	B0,W	; adiciona os 8 bits
	ADDWF	A0,F	; menos significativos
	BTFSC	STATUS,C	; testa se houve transbordo
	GOTO	ADD16_2	; se houve pula para ADD16_2
	MOVF	B1,W	; se não, adiciona os
	ADDWF	A1,F	; 8 bits mais significativos e
	RETURN		; retorna
ADD16_2:
	MOVF	B1,W	; adiciona os 8 bits 
	ADDWF	A1,F	; mais significativos e
	MOVLW	0x01	; soma o transbordo dos 8 bits LSB
	ADDWF	A1,F	; ao dígito MSB
	RETURN		; retorna
INICIO:
	MOVLW	0xFF	; 
	MOVWF	A0	; variável A0=0xFF
	MOVLW	0x01	; 
	MOVWF	A1	; variável A1=0x01 (A=0x01FF)
	MOVLW	0x02	;
	MOVWF	B0	; variável B0=0x02
	MOVLW	0x00	;
	MOVWF	B1	; variável B1=0x00 (B=0x0002)
	CALL	ADD16	; soma A+B (resultado= A1=0x02 e A0=0x01 => A=0x0201)
	SLEEP		; o programa termina aqui
END
