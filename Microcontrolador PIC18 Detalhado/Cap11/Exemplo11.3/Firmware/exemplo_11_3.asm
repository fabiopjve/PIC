	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configuração
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=ON,LVP=OFF,BOREN=OFF

CBLOCK 	0x010
	INTCON_TEMP
ENDC

	org		0x0400
	db		0,1,2,3,4,5,6,7,8,9
	db		10,11,12,13,14,15,16,17,18,19

	org 	0x0000	; vetor de reset
	BRA		INICIO

FLASH_PAGE_ERASE:
	MOVF	INTCON,W	; preserva INTCON (para se restaurar as interrupções
	MOVWF	INTCON_TEMP	; caso estejam habilitadas)
	MOVLW	0x94
	MOVWF	EECON1	; EEPGD=1, CFGS=0, FREE=1, WREN=1
	MOVLW	0x55
	MOVWF	EECON2	; primeira parte da senha de escrita na memória
	MOVLW	0xAA
	MOVWF	EECON2	; segunda parte da senha
	BSF		EECON1,WR	; seta WR e inicia a programação da memória
	NOP			; NOP recomendado pelo fabricante
	BCF		EECON1,WREN	; apaga WREN
	MOVF	INTCON_TEMP,W	
	MOVWF	INTCON	; restaura INTCON 
	RETURN		; retorna da subrotina

INICIO:
	CLRF	TBLPTRU	; TBLPTRU = 0x00
	MOVLW	0x04
	MOVWF	TBLPTRH	; TBLPTRH = 0x04
	CLRF	TBLPTRL	; TBLPTRL = 0x00 (TBLPTR = 0x000400)
	CALL	FLASH_PAGE_ERASE	; chama a subrotina de apagamento de página
FIM:
	BRA		FIM
	END

