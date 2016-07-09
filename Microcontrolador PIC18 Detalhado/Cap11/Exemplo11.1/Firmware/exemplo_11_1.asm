	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=ON,LVP=OFF,BOREN=OFF

	org		0x0400
	db		0,1,2,3,4,5,6,7,8,9
	db		10,11,12,13,14,15,16,17,18,19

	org 	0x0000	; vetor de reset
	BRA		INICIO

FLASH_READ:
	TBLRD*+	; lê o endereço apontado por TBLPTR, salva em TABLAT
	MOVFF	TABLAT,WREG	; copia TABLAT para o registrador WREG
	RETURN		; retorna da subrotina

INICIO:
	CLRF	TBLPTRU	; TBLPTRU = 0x00
	MOVLW	0x04
	MOVWF	TBLPTRH	; TBLPTRH = 0x04
	MOVLW	0x02
	MOVWF	TBLPTRL	; TBLPTRL = 0x02 (TBLPTR=0x000402)
	CALL	FLASH_READ	; lê o conteúdo do endereço 0x000402 (resultado em W)
FIM:
	BRA		FIM
	END
