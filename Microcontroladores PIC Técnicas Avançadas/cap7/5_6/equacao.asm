; Média de quatro valores
LIST P=16F627
INCLUDE  <P16F627.INC>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
VA	EQU	0x20		; associa o registrador GPR do endereço 0x20 com a variável VA
VB	EQU	0x21		; associa o registrador GPR do endereço 0x21 com a  variável VB
VC	EQU	0x22		; associa o registrador GPR do endereço 0x22 com a  variável VC
VD	EQU	0x23		; associa o registrador GPR do endereço 0x23 com a  variável VD
RESUL	EQU	0x24		; variável RESU menos significativa no endereço 0x24
RESUH	EQU	0x25		; variável RESU mais significativa no endereço 0x25
ORG	0x0000			; início do programa no endereço 0000		Z	C
MOVLW	D'100'			; W=D’100’					X	X
MOVWF	VA			; VA=D’100’					X	X
MOVLW	D'50'			; W=D’50’					X	X
MOVWF	VB			; VB=D’50’					X	X
MOVLW	D'100'			; W=D’100’					X	X
MOVWF	VC			; VC=D’100’					X	X
MOVLW	D'50'			; W=D’50’					X	X
MOVWF	VD			; VD=D’50’					X	X
CLRF	RESUL			; RESUL=0					1	X
CLRF	RESUH			; RESUH=0					1	X
MOVF	VA,W			; W=D’100’					0	X
ADDWF	VB,W			; W=W+VB=D’150’					0	0
BTFSC	STATUS,C		; TESTA O CARRY, PULA SE 0			0	0
INCF	RESUH,F			; NÃO FOI EXECUTADA
ADDWF	VC,W			; W=W+VC=D’150’+D’100’=D’250’			0	0
BTFSC	STATUS,C		; TESTA O CARRY, PULA SE 0			0	0
INCF	RESUH,F			; NÃO FOI EXECUTADA
ADDWF	VD,W			; W=W+VD=250+50=300(-256)=D’44’			0	1
BTFSC	STATUS,C		; TESTA O CARRY, PULA SE 0			0	1
INCF	RESUH,F			; incrementa RESUH (=D’1’)			0	1
MOVWF	RESUL			; RESU=W=D’44’					0	0
BCF	STATUS,C		; C=0						0	0
RRF	RESUH,F			; RESUH B’00000001’ -> B’00000000’		0	1
RRF	RESUL,F			; RESUL B’00101100’ -> B’10010110’		0	0
BCF	STATUS,C		; C=0						0	0
RRF	RESUH,F			; RESUH B’00000000’ -> B’00000000’		0	0
RRF	RESUL,F			; RESUL B’10010110’ -> B’01001011’		0	0
END
; Resultado: RESU = B’01001011’ = D’75’ !

