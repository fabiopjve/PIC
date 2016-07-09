; Exemplo de quadrado
LIST P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM> 
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
ORG	0x0000
	GOTO	INICIO
QUADRADO:
	ADDWF	PCL,F	; soma o índice da tabela ao PCL e desvia
	RETLW	0	; se W=0, retorna W=0
	RETLW	D'1'	; se W=1, retorna W=1
	RETLW	D'4'	; se W=2, retorna W=4
	RETLW	D'9'	; se W=3, retorna W=9
	RETLW	D'16'	; se W=4, retorna W=16 decimal
	RETLW	D'25'	; se W=5, retorna W=25 decimal
	RETLW	D'36'	; se W=6, retorna W=36 decimal
	RETLW	D'49'	; se W=7, retorna W=49 decimal
	RETLW	D'64'	; se W=8, retorna W=64 decimal
	RETLW	D'81'	; se W=9, retorna W=81 decimal
	RETLW	D'100'	; se W=10 decimal, retorna W=100 decimal
	RETLW	D'121'	; se W=11 decimal, retorna W=121 decimal
	RETLW	D'144'	; se W=12 decimal, retorna W=144 decimal
	RETLW	D'169'	; se W=13 decimal, retorna W=169 decimal
	RETLW	D'196'	; se W=14 decimal, retorna W=196 decimal
	RETLW	D'225'	; se W=15 decimal, retorna W=225 decimal
INICIO:
	MOVLW	0x05	; coloca 5 decimal em W
	CALL	QUADRADO	; chama sub-rotina QUADRADO
	SLEEP		; fim do programa
END
