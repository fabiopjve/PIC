; Arquivo de Macros do Livro: Microcontroladores PIC: Técnicas Avançadas
; **************************************************************************
; Autor: Fábio Pereira    (fabio@pp.adv.br)
; Data : 08/04/2002
;***************************************************************************
;
; Este arquivo de macros pode ser incluído livremente em qualquer programa.
; Para isto basta utilizar a diretiva INCLUDE <MACROS.ASM>
;
INCW	MACRO
	ADDLW  0x01
 	ENDM
DECW	MACRO
	ADDLW  0XFF
 	ENDM
COMW	MACRO
	XORWF	0xFF
	ENDM
BSW	MACRO	BIT
	IF (BIT==0)
		IORLW	B'00000001'
	ENDIF
	IF (BIT==1)
		IORLW	B'00000010'
	ENDIF
	IF (BIT==2)
		IORLW	B'00000100'
	ENDIF
	IF (BIT==3)
		IORLW	B'00001000'
	ENDIF
	IF (BIT==4)
		IORLW	B'00010000'
	ENDIF
	IF (BIT==5)
		IORLW	B'00100000'
	ENDIF
	IF (BIT==6)
		IORLW	B'01000000'
	ENDIF
	IF (BIT==7)
		IORLW	B'10000000'
	ENDIF
	ENDM
BCW	MACRO	BIT
	IF (BIT==0)
		ANDLW	B'11111110'
	ENDIF
	IF (BIT==1)
		ANDLW	B'11111101'
	ENDIF
	IF (BIT==2)
		ANDLW	B'11111011'
	ENDIF
	IF (BIT==3)
		ANDLW	B'11110111'
	ENDIF
	IF (BIT==4)
		ANDLW	B'11101111'
	ENDIF
	IF (BIT==5)
		ANDLW	B'11011111'
	ENDIF
	IF (BIT==6)
		ANDLW	B'10111111'
	ENDIF
	IF (BIT==7)
		ANDLW	B'01111111'
	ENDIF
	ENDM
JPE	MACRO	ENDER,REG,VAL
	MOVLW  	VAL
	SUBWF  	REG,W
	BTFSC	STATUS,Z
	GOTO	ENDER
	ENDM
JPNE	MACRO	ENDER,REG,VAL
	MOVLW  	VAL
	SUBWF  	REG,W
	BTFSS	STATUS,Z
	GOTO	ENDER
	ENDM
JPL	MACRO	ENDER,REG,VAL
	SUBLW	VAL
	BTFSS	STATUS,C
	GOTO	ENDER
	ENDM
JPLS	MACRO	ENDER,REG,VAL
	SUBLW   VAL
	BTFSS	STATUS,C
	GOTO	ENDER
	BTFSC	STATUS,Z
	GOTO	ENDER
	ENDM
JPG	MACRO	ENDER,REG,VAL
	SUBLW	VAL
	BTFSC	STATUS,C
	GOTO	JPG_FIM
	BTFSS	STATUS,Z
	GOTO	ENDER
JPG_FIM:
	ENDM
JPGS	MACRO	ENDER,REG,VAL
	SUBLW	VAL
	BTFSC	STATUS,C
	GOTO	ENDER
	ENDM
JPWZ	MACRO	ENDER
	ANDLW	0XFF
	BTFSC	STATUS,Z
	GOTO	ENDER
	ENDM
JPWNZ	MACRO	ENDER
	ANDLW	0XFF
	BTFSS	STATUS,Z
	GOTO	ENDER
	ENDM
COMBF	MACRO	REG,BIT
	IF (BIT==0)
		MOVLW	B'00000001'
	ENDIF
	IF (BIT==1)
		MOVLW	B'00000010'
	ENDIF
	IF (BIT==2)
		MOVLW	B'00000100'
	ENDIF
	IF (BIT==3)
		MOVLW	B'00001000'
	ENDIF
	IF (BIT==4)
		MOVLW	B'00010000'
	ENDIF
	IF (BIT==5)
		MOVLW	B'00100000'
	ENDIF
	IF (BIT==6)
		MOVLW	B'01000000'
	ENDIF
	IF (BIT==7)
		MOVLW	B'10000000'
	ENDIF
	XORWF	REG,F
	ENDM
; MACRO para Multiplicação com RLF. Incluída no arquivo MACROS.ASM
; Utilização: MULT2 <registrador>,<valor múltiplo de potência de 2>
MULT2	MACRO	REG,VAL
	BCF	STATUS,C		; limpa o flag de carry
	IF (VAL==2)
		RLF	REG,F		; rotaciona o registrador à esquerda
					; o que equivale a multiplicar por 2
	ENDIF
	IF (VAL==4)
		RLF	REG,F		; multiplica por 2
		BCF	STATUS,C	; zera carry para não atrapalhar a pró
					; xima multiplicação
		RLF	REG,F		; multiplica novamente por 2 (total 4)
	ENDIF
	IF (VAL==8)
		RLF	REG,F		; multiplica por 2
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 8)
	ENDIF
	IF (VAL==16)
		RLF	REG,F		; multiplica por 2
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 8)
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 16)
	ENDIF
	IF (VAL==32)
		RLF	REG,F		; multiplica por 2
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 8)
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 16)			
		BCF	STATUS,C	; zera carry
		RLF	REG,F		; multiplica novamente por 2 (total 32)
	ENDIF
	ENDM
; MACRO para Divisão com RRF. Esta macro está incluída no arquivo MACROS.ASM
; Utilização: DIV2 <registrador>,<valor múltiplo de potência de 2>
DIV2	MACRO	REG,VAL
	BCF	STATUS,C		; limpa o flag de carry
	IF (VAL==2)
		RRF	REG,F		; rotaciona o registrador à esquerda
					; o que equivale a divider por 2
	ENDIF
	IF (VAL==4)
		RRF	REG,F		; divide por 2
		BCF	STATUS,C	; zera carry para não atrapalhar a pró
					; xima divisão
		RRF	REG,F		; divide novamente por 2 (total 4)
	ENDIF
	IF (VAL==8)
		RRF	REG,F		; divide por 2
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 8)
	ENDIF
	IF (VAL==16)
		RRF	REG,F		; divide por 2
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 8)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 16)
	ENDIF
	IF (VAL==32)
		RRF	REG,F		; divide por 2
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 4)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 8)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 16)
		BCF	STATUS,C	; zera carry
		RRF	REG,F		; divide novamente por 2 (total 32)
	ENDIF
	ENDM
SALVA_CONTEXTO  MACRO
	MOVWF	W_TEMP		; salva o conteúdo do W em W_TEMP
	SWAPF	STATUS,W	; salva o conteúdo do STATUS ...
	MOVWF	STATUS_TEMP	; ... em STATUS_TEMP
	ENDM
RESTAURA_CONTEXTO  MACRO
	SWAPF	STATUS_TEMP,W	; restaura o conteúdo do ...
	MOVWF	STATUS		; ... registrador STATUS
	SWAPF	W_TEMP,F	; restaura o conteúdo ...
	SWAPF	W_TEMP,W	; ... do registrador W
	ENDM


