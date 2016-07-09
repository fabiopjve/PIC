; TRATA_TECLAS - 	esta sub-rotina realiza a varredura do teclado a procura de 
;			uma tecla pressionada. Caso seja encontrada, retorna o valor 
;			da tecla na variável NOVA_TECLA.
;			A variável TECLA_FLAGS é utilizada como um registrador de 
;			FLAGS, armazenando diversos FLAGS de estado do teclado:
;			- FILTRO:
;			- PRESSIONADA:
;			- TECLA:
;			Uma outra sub-rotina no decorrer do programa deverá 
;			providenciar a leitura da tecla (ler a variável NOVA_TECLA) e 
;			zerar o FLAG TECLA.
;******************************************************************************
; Os pinos RB0,RB1, RB2 e RB3 devem estar configurados como saídas
; Os pinos RB4, RB5, RB6 e RB7 devem estar configurados como entradas
; Variáveis: TECLA_FLAGS, VARREDURA, NOVA_TECLA, TEMP2, TEMP3, TEMPO_TECLA
	...
TRATA_TECLAS:
; DEFINIÇÕES
FILTRO	EQU 0
PRESSIONADA	EQU 1
TECLA	EQU 2
;
	BTFSS	TECLA_FLAGS,FILTRO	; testa se o filtro de DEBOUNCE está ativo
	GOTO	VARRE_TECLAS		; se não está, varre as teclas
	DECFSZ	TEMPO_TECLA,F		; se o filtro estiver ativo, decrementa 
					; tempo
	RETURN				; retorna
	BCF	TECLA_FLAGS,FILTRO	; limpa o filtro de DEBOUNCE
	RETURN				; retorna
VARRE_TECLAS
	MOVLW	B’11101111’		; prepara a varredura da matriz do teclado
	MOVWF	TEMP2			; 
VARRE_PROXIMA:
	MOVF	PORTB,W			; lê a porta B
	BCF	INTCON,RBIF		; limpa o flag de mudança da porta B
	RRF	TEMP2,F			; rotaciona o índice de varredura de teclado
	BTFSS	STATUS,C		; testa se a varredura chegou ao final
	GOTO	NENHUMA_TECLA		; se chegou, nenhuma tecla foi pressionada
	MOVF	TEMP2,W			; se não copia o índice de varredura para W
	MOVWF	PORTB			; ... e então para a porta B
	NOP				; aguarda ...
	NOP				; ... dois ciclos
	BTFSS	INTCON,RBIF		; verifica se houve mudanças na porta B
	GOTO	VARRE_PROXIMA		; se não houve, varre a próxima coluna
	BTFSC	TECLA_FLAGS,PRESSIONADA	; se houve, verifica FLAG da tecla 
					; pressionada
	RETURN				; se a tecla já estava pressionada, retorna
	BSF	TECLA_FLAGS,PRESSIONADA	; se não, ativa o flag de tecla 
					; pressionada
	SWAPF	PORTB,W			; inverte nibbles da porta B e coloca em W
	MOVWF	TEMP3			; copia para variável temporária (TEMP3)
	CALL	PEGA_TECLA		; verifica qual a tecla pressionada
	MOVWF	NOVA_TECLA		; copia o código para a NOVA_TECLA
	BSF	TECLA_FLAGS,TECLA	; ativa flag de nova tecla pressionada
	BSF	TECLA_FLAGS,FILTRO	; ativa filtro de DEBOUNCE
	MOVLW	0x04			; reinicia o valor do temporizador
	MOVWF	TEMPO_TECLA		; de DEBOUNCE
NENHUMA_TECLA:
	BCF	TECLA_FLAGS,PRESSIONADA	; se nenhuma tecla foi pressionada, limpa
		RETURN			; limpa o flag de tecla pressionada e 
					; retorna
PEGA_TECLA:
	CLRF	TEMP1			; limpa tecla temporária (TEMP1)
	BTFSS	TEMP2,3			; verifica se é a primeira coluna
	GOTO	LINHA			; sim ? então pula para o teste de linhas
	INCF	TEMP1,F			; não ? então incrementa TEMP1
	BTFSS	TEMP2,2			; testa se é a segunda coluna
	GOTO	LINHA			; sim ? então pula para o teste de linhas
	INCF	TEMP1,F			; não ? então incrementa TEMP1
	BTFSS	TEMP2,1			; testa se é a terceira coluna
	GOTO	LINHA			; sim ? então pula para o teste de linhas
	INCF	TEMP1,F			; não ? então incrementa  TEMP1
					; então é a quarta coluna ...
LINHA:
	BTFSS	TEMP3,0			; verifica se foi a primeira linha
	GOTO	TABELA_TECLA		; sim ? então é uma das teclas: S1,S2,S3 ou S4
	BTFSS	TEMP3,1			; verifica se foi a segunda linha
	GOTO	TECLAS5678		; sim ? então é uma das teclas: S5,S6,S7 ou S8
	BTFSS	TEMP3,2			; verifica se foi a terceira linha
	GOTO	TECLAS9_10_11_12	; sim ? então é uma das teclas: S9,S10,S11,S12
TECLAS13_14_15_16:
	BSF	TEMP1,2			; seta o bit 2 do índice da tabela
TECLAS9_10_11_12:
	BSF	TEMP1,3			; seta o bit 3 do índice da tabela
	GOTO	TABELA_TECLA		; vai para a tabela
TECLAS5678:
	BSF	TEMP1,2			; seta apenas o bit 2 do índice da tabela
TABELA_TECLA:
	MOVF	TEMP1,W			; copia o índice da tabela para W
	ADDW	PCL,F			; adiciona W ao PCL
	RETLW	0x01			; retorna valor da tecla S1
	RETLW	0x02			; retorna valor da tecla S2
	RETLW	0x03			; retorna valor da tecla S3
	RETLW	0x04			; retorna valor da tecla S4
	RETLW	0x05			; retorna valor da tecla S5
	RETLW	0x06			; retorna valor da tecla S6
	RETLW	0x07			; retorna valor da tecla S7
	RETLW	0x08			; retorna valor da tecla S8
	RETLW	0x09			; retorna valor da tecla S9
	RETLW	0x0A			; retorna valor da tecla S10
	RETLW	0x0B			; retorna valor da tecla S11
	RETLW	0x0B			; retorna valor da tecla S12
	RETLW	0x0C			; retorna valor da tecla S13
	RETLW	0x0D			; retorna valor da tecla S14
	RETLW	0x0E			; retorna valor da tecla S15
	RETLW	0x0F			; retorna valor da tecla S16
