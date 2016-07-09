;Sub-rotina de tratamento de teclas 0 a 9
; o valor da tecla pressionada deve estar inicialmente no registrador W
; a sub-rotina utiliza uma vari�vel chamada TEMP que deve ser declarada
; inicialmente.
TECLAS:
	MOVWF		TEMP					;
	SUBLW	0x09				; testa se W � maior que 9
	BTFSS	STATUS,C				; se W � maior que 9, o resultado foi 
						; negativo e o flag C estar� em �0�
	RETURN					; neste caso ocorrer� o retorno da 
						; sub-rotina
	MOVLW	LOW TECLAS_TABELA		; copia o endere�o LSB da tabela em W
	ADDWF	TEMP,F				; adiciona ao valor da tecla em TEMP
	MOVLW	HIGH TECLAS_TABELA	; copia o endere�o MSB da tabela em W
	BTFSC	STATUS,C				; testa se houve transbordo na adi��o
	ADDLW	1				; se houve, adiciona 1 ao W
	MOVWF	PCLATH				; copia o endere�o MSB da tabela no 
						; PCLATH
	MOVF	TEMP,W				; copia o �ndice da tabela em W
TECLAS_TABELA:
	MOVWF	PCL				; copia o �ndice em W para o PCL
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
	...			; rotina do usu�rio para a tecla 9
	RETURN
TECLA_0:
... 				; rotina do usu�rio para a tecla 0
	RETURN
TECLA_1:
	... 			; rotina do usu�rio para a tecla 1
	RETURN
TECLA_2:
	... 			; rotina do usu�rio para a tecla 2
	RETURN
TECLA_3:
	... 			; rotina do usu�rio para a tecla 3
	RETURN
TECLA_4:
	... 			; rotina do usu�rio para a tecla 4
	RETURN
TECLA_5:
	... 			; rotina do usu�rio para a tecla 5
	RETURN
TECLA_6:
	... 			; rotina do usu�rio para a tecla 6
	RETURN
TECLA_7:
	... 			; rotina do usu�rio para a tecla 7
	RETURN
TECLA_8:
	... 			; rotina do usu�rio para a tecla 8
	RETURN
