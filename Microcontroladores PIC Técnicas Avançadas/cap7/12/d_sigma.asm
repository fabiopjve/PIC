; Conversor A/D Delta-Sigma (implementação de Dan Butler da Microchip Inc.)
; Estas sub-rotinas realizam a conversão analógico-digital de um sinal externo.
; Variáveis utilizadas: RESULTADO_L, RESULTADO_H, DELTA_L, DELTA_H
INICIALIZA_CONV_DELTA:
	BSF	STATUS,RP0	; seleciona o banco 1
	MOVLW	0xEC		;
	MOVWF	VRCON		; configura referência de tensão interna
	BCF	TRISA,3		; configura o pino RA3 para saída
	BCF	STATUS,RP0	; seleciona o banco 0
	MOVLW	0x05		;
	MOVWF	CMCON		; configura o módulo comparador analógico
	RETURN			;
CONVERSOR_DELTA:
	CLRF	RESULTADO_L	;
	CLRF	RESULTADO_H	;
	CLRF	DELTA_L		;
	CLRF	DELTA_H		;
	MOVLW	0x03		;
	MOVWF	CMCON		; inicializa o módulo comparador analógico
CICLO_CONVERSAO:
	BTFSC	CMCON,C1OUT	; verifica a saída do comparador 1
	GOTO	REF_MENOR	; se C1OUT=1 vai para REF_MENOR
REF_MAIOR:
	NOP			; gasta 1 ciclo
	BCF	PORTA,3		; coloca a saída RA3 em nível '1'
	INCFSZ	RESULTADO_L,F	; incrementa o resultado LSB
	GOTO	GASTA2CICLOS	; vai para GASTA2CICLOS
	INCF	RESULTADO_H,F	; incrementa o resultado MSB
	GOTO	FINAL_CICLO	; vai para o final do ciclo
REF_MENOR:
	BSF	PORTA,3		; coloca a saída RA3 em '1'
	NOP			; gasta 1 ciclo
	GOTO	GASTA2CICLOS	; gasta mais 2 ciclos
GASTA2CICLOS:
	GOTO	FINAL_CICLO	; vai para o final do ciclo
FINAL_CICLO:
	INCFSZ	DELTA_L,F	; incrementa o contador de passos de conversão 
				; LSB
	GOTO	GASTA5CICLOS	; gasta 5 ciclos
	INCF	DELTA_H,F	; incrementa o contador de passos de conversão 
				; MSB
; o código a seguir determina se a contagem de ciclos ultrapassou 4096
	MOVF	DELTA_H,W	; 
	ANDLW	B’00010000’	;
	BTFSC	STATUS,Z	;
	GOTO	CICLO_CONVERSAO	;
	GOTO	FIM_CONVERSAO	;
GASTA5CICLOS:
	GOTO	$+1		;
	NOP			;
	GOTO	CICLO_CONVERSAO	;
FIM_CONVERSAO:
	MOVLW	0x06		;
	MOVWF	CMCON		;
	RETURN			;
