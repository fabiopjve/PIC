	LIST P=18F4520
	#include <P18F4520.INC>
;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF
CBLOCK 	0x010
	INTCON_TEMP
ENDC
	org 	0x0000		; vetor de reset
	BRA		INICIO
WRITE_EEPROM:		; escreve um dado na EEPROM
	BTFSC	EECON1,WR		; caso WR esteja setado ...
	BRA		WRITE_EEPROM	; aguarda que ele retorne a zero
	MOVWF	EEDATA		; escreve o dado (em W) em EEDATA
	MOVLW	0x04
	MOVWF	EECON1		; WREN = 1 em EECON1
	MOVF	INTCON,W		; salva o estado de INTCON
	MOVWF	INTCON_TEMP	; em INTCON_TEMP
	CLRF	INTCON		; desabilita interrupções
	MOVLW	0x55		; escreve a senha em EECON2
	MOVWF	EECON2
	MOVLW	0xAA
	MOVWF	EECON2
	BSF		EECON1,WR		; inicia a escrita (WR=1 em EECON1)
	MOVF	INTCON_TEMP,W	; restaura INTCON ...
	MOVWF	INTCON		; ao seu estado anterior
	RETURN
INICIO:
	MOVLW	0x02		; endereço 0x02 da EEPROM
	MOVWF	EEADR
	MOVLW	0x41		; dado = 0x41
	CALL	WRITE_EEPROM	; chama subrotina de escrita na EEPROM
FIM:
	BRA		FIM		; loop
	END
