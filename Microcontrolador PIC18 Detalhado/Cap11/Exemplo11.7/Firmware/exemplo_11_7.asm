	LIST P=18F4520
	#include <P18F4520.INC>
;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF

	org		0xF00000
	str1	de "Teste"
	eep1	de .10
	org 	0x0000		; vetor de reset
	BRA		INICIO
READ_EEPROM:
	MOVLW	0x01		
	MOVWF	EECON1		; EEPGD=CFGS=FREE=WREN=0 e RD = 1
	MOVFF	EEDATA,WREG		; copia EEDATA para WREG
	RETURN
INICIO:
	CLRF	EEADR		; EEADR = 0
	CALL	READ_EEPROM		; faz a leitura do endereço 0 da EEPROM (W retorna “T”)
	MOVLW	.5
	MOVWF	EEADR		; EEADR = 5
	CALL	READ_EEPROM		; faz a leitura do endereço 5 da EEPROM (W retorna 0)
	INCF	EEADR,F		; EEADR = 6
	CALL	READ_EEPROM		; faz a leitura do endereço 6 da EEPROM (W retorna 10)
FIM:
	BRA		FIM
	END
