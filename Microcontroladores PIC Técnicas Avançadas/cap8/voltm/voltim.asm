; Voltímetro Digital de 8 bits
LIST  P=16F627
INCLUDE <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
DESLOCAMENTO	EQU 0x20
D0		EQU 0x21
D1		EQU 0x22
D2		EQU 0x23
CONTA		EQU 0x24
RESULTADO_L	EQU 0x25
RESULTADO_H	EQU 0x26
DELTA_L	EQU 0x27
DELTA_H	EQU 0x28
ORG 0x0000
	GOTO	INICIO
DECOD_DISPLAY:
	MOVWF	DESLOCAMENTO	; armazena o número na variável deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endereço da TABELA
	ADDWF	DESLOCAMENTO,F	; adiciona o valor à variável DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endereço da TABELA
	BTFSC	STATUS,C	; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endereço da TABELA
	MOVF	DESLOCAMENTO,W	; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
	RETLW	B'10111111'	; número 0
	RETLW	B'10000110'	; número 1
	RETLW	B'11011011'	; número 2
	RETLW	B'11001111'	; número 3
	RETLW	B'11100110'	; número 4
	RETLW	B'11101101'	; número 5
	RETLW	B'11111101'	; número 6
	RETLW	B'10000111'	; número 7
	RETLW	B'11111111'	; número 8
	RETLW	B'11100111'	; número 9
	RETLW	B'11110111'	; dígito A	
	RETLW	B'11111100'	; dígito B
	RETLW	B'10111001'	; dígito C
	RETLW	B'11011110'	; dígito D
	RETLW	B'11111001'	; dígito E
	RETLW	B'11110001'	; dígito F
ATRASO:				; Subrotina de atraso
	ADDLW	1		; soma 1 ao W
	BTFSC	STATUS,Z	; testa se W=0 ...
	RETURN			; se W=0, retorna
	GOTO	ATRASO		; se W diferente de 0, desvia para ATRASO_LOOP
DISPLAY:
	MOVF	D0,W		; copia o dígito em W
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BCF	PORTB,7		; ativa display 1
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTB,7		; desativa display 1
	MOVF	D1,W		; copia o próximo dígito em W
	CALL	DECOD_DISPLAY	; decodifica o display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,6		; ativa display 2
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,6		; desativa display 2
	MOVF	D2,W		; copia o último dígito em W
	CALL	DECOD_DISPLAY	; decodifica display
	MOVWF	PORTB		; ativa os segmentos
	BCF	PORTA,7		; ativa o display 3
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	PORTA,7		; desativa o display 3
	RETURN			; retorna
BIN8DEC:
	MOVWF	D0		; copia o número a ser convertido para a variável de
				; unidades
	CLRF	D1		; limpa as dezenas
	CLRF	D2		; limpa as centenas
BIN8DEC_1:
	MOVLW	D'100'		; subtrai 100 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda em W
	BTFSS	STATUS,C	; o resultado é positivo ou zero ?
	GOTO	BIN8DEC_2	; não ? então vai para a próxima parte
	MOVWF	D0		; sim ? então copia o valor para as unidades ...
	INCF	D2,F		; incrementa um nas centenas
	GOTO	BIN8DEC_1	; e reinicia o ciclo
BIN8DEC_2:
	MOVLW	D'10'		; subtrai 10 decimal do valor ...
	SUBWF	D0,W		; ... a ser convertido e guarda o resultado em W
	BTFSS	STATUS,C	; o resultado é positivo ou zero ?
	RETURN			; não ? então retorna, a conversão terminou
	MOVWF	D0		; sim ? então copia W para as unidades ...
	INCF	D1,F		; incrementa um nas dezenas 
	GOTO	BIN8DEC_2	; e reinicia o ciclo
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
	INCFSZ	DELTA_L,F	; incrementa o contador de passos de conversão LSB
	GOTO	GASTA5CICLOS	; gasta 5 ciclos
	INCF	DELTA_H,F	; incrementa o contador de passos de conversão MSB
; o código a seguir determina se a contagem de ciclos ultrapassou 256
	MOVF	DELTA_H,W	; 
	ANDLW	B'00000001'	;
	BTFSC	STATUS,Z	;
	GOTO	CICLO_CONVERSAO	;
	GOTO	FIM_CONVERSAO	;
GASTA5CICLOS:
	GOTO	$+1		; gasta 2 ciclos (desvia para a próxima instrução)
	NOP			; gasta 1 ciclo
	GOTO	CICLO_CONVERSAO	; inicia novo ciclode conversão
FIM_CONVERSAO:
	MOVLW	0x06		; 
	MOVWF	CMCON		; configura o módulo comparador para modo 6
	RETURN			; retorna
INICIO:
; primeiramente vamos inicializar a porta B como saída e os pinos 
; RA3, RA6 e RA7 como saídas, os demais pinos da porta A serão configurados
; como entradas
	MOVLW	B'00000101'
	MOVWF	CMCON		; configura os comparadores analógicos para modo 5
	BANKSEL	TRISA		;
	MOVLW	B'00000110'	; os pinos RA1 e RA2 como entradas e os demais
	MOVWF	TRISA		; como saídas
	CLRF	TRISB		; configura a porta B para saídas
	BANKSEL	PORTB		;
	MOVLW	B'11000000'	; desliga os catodos dos dois ...
 	MOVWF	PORTA		; ... displays
	BSF	PORTB,7		; desliga o catodo do terceiro display
	CLRF	D0		;
	CLRF	D1		;
	CLRF	D2		;
	MOVLW	D'20'		; inicializa o temporizador de conversão em
	MOVWF	CONTA		; 20 ciclos
	CALL	INICIALIZA_CONV_DELTA
LOOP_PRINCIPAL:
	CALL	DISPLAY		; apresenta o resultado atual no display
	DECFSZ	CONTA,F		; decrementa temporizador de conversão
	GOTO	LOOP_PRINCIPAL	; se CONTA>0 retorna para o LOOP_PRINCIPAL
	MOVLW	D'20'		; 
	MOVWF	CONTA		; reinicia contador em 20 decimal
	CALL	CONVERSOR_DELTA	; realiza uma conversão
	MOVF	RESULTADO_L,W	; copia o resultado de 8 bits em W
	CALL	BIN8DEC		; converte o resultado em decimal
	GOTO	LOOP_PRINCIPAL	; retorna para o LOOP_PRINCIPAL
END
