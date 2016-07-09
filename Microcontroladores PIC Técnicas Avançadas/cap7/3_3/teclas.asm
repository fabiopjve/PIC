;Sub-rotina de tratamento de teclas 0 a 9
; o valor da tecla pressionada deve estar inicialmente no registrador W
; a sub-rotina utiliza uma variável chamada TEMP que deve ser declarada
; inicialmente.
TECLAS:
	MOVWF		TEMP					;
	SUBLW	0x09				; testa se W é maior que 9
	BTFSS	STATUS,C				; se W é maior que 9, o resultado foi 
						; negativo e o flag C estará em ‘0’
	RETURN					; neste caso ocorrerá o retorno da 
						; sub-rotina
	MOVLW	LOW TECLAS_TABELA		; copia o endereço LSB da tabela em W
	ADDWF	TEMP,F				; adiciona ao valor da tecla em TEMP
	MOVLW	HIGH TECLAS_TABELA	; copia o endereço MSB da tabela em W
	BTFSC	STATUS,C				; testa se houve transbordo na adição
	ADDLW	1				; se houve, adiciona 1 ao W
	MOVWF	PCLATH				; copia o endereço MSB da tabela no 
						; PCLATH
	MOVF	TEMP,W				; copia o índice da tabela em W
TECLAS_TABELA:
	MOVWF	PCL				; copia o índice em W para o PCL
	GOTO	TECLA_0
	GOTO	TECLA_1
	GOTO	TECLA_2
	GOTO	TECLA_3
	GOTO	TECLA_4
	GOTO	TECLA_5
	GOTO	TECLA_6
	GOTO	TECLA_7
	GOTO	TECLA_8
TECLA_9:
	...			; rotina do usuário para a tecla 9
	RETURN
TECLA_0:
... 				; rotina do usuário para a tecla 0
	RETURN
TECLA_1:
	... 			; rotina do usuário para a tecla 1
	RETURN
TECLA_2:
	... 			; rotina do usuário para a tecla 2
	RETURN
TECLA_3:
	... 			; rotina do usuário para a tecla 3
	RETURN
TECLA_4:
	... 			; rotina do usuário para a tecla 4
	RETURN
TECLA_5:
	... 			; rotina do usuário para a tecla 5
	RETURN
TECLA_6:
	... 			; rotina do usuário para a tecla 6
	RETURN
TECLA_7:
	... 			; rotina do usuário para a tecla 7
	RETURN
TECLA_8:
	... 			; rotina do usuário para a tecla 8
	RETURN
