	LIST P=18F4520
	#include <P18F4520.INC>

;***************************************************************
; Bits de configura��o
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=ON,LVP=OFF,BOREN=OFF

CBLOCK 	0x010
	CNT, DATA_TEMP, INTCON_TEMP
ENDC

	org 	0x0000	; vetor de reset
	BRA		INICIO

; Grava um dado (guardado em W) no endere�o indicado por TBLPTR
FLASH_WRITE_BYTE:
	MOVWF	DATA_TEMP	; salva o dado a ser gravado na flash
	MOVF	INTCON,W	; preserva INTCON (para se restaurar as interrup��es
	MOVWF	INTCON_TEMP	; caso estejam habilitadas)
	MOVLW	0x1F	; mascara os 5 bits menos significativos
	ANDWF	TBLPTRL,W	; de TBLPTRL, este � o offset do endere�o
	MOVWF	CNT	; salva isso em CNT
	BTFSC	STATUS,Z
	BRA		FLASH_WRITE_DATA	; caso CNT seja zero, vai direto para a grava��o
	MOVLW	0xE0	; caso CNT>0, apaga os 5 bits menos significativos 
	ANDWF	TBLPTRL,F	; de TBLPTRL (ajuste para o in�cio da p�gina)
	SETF	TABLAT	; TABLAT = 0xFF
FLASH_FETCH_ADDRESS:
	TBLWT*+
	DECFSZ	CNT,F	
	BRA		FLASH_FETCH_ADDRESS
FLASH_WRITE_DATA:
	MOVFF	DATA_TEMP,TABLAT	; escreve o dado em TABLAT
	TBLWT*+	; grava na mem�ria
	CLRF	INTCON	; desabilita as interrup��es
	MOVLW	0x84
	MOVWF	EECON1	; EEPGD=1, CFGS=0, WREN=1
	MOVLW	0x55
	MOVWF	EECON2	; primeira parte da senha de escrita na mem�ria
	MOVLW	0xAA
	MOVWF	EECON2	; segunda parte da senha
	BSF		EECON1,WR	; seta WR e inicia a programa��o da mem�ria
	NOP			; NOP recomendado pelo fabricante
	BCF		EECON1,WREN	; apaga WREN
	MOVF	INTCON_TEMP,W	
	MOVWF	INTCON	; restaura INTCON 
	RETURN		; retorna da subrotina

; Exemplo de utiliza��o: grava 0xAB no endere�o 0x000402 da flash
INICIO:
	CLRF	TBLPTRU	; TBLPTRU = 0
	MOVLW	0x04
	MOVWF	TBLPTRH	; TBLPTRH = 0x04
	MOVLW	0x02
	MOVWF	TBLPTRL	; TBLPTRL = 0x02 (TBLPTR = 0x000402)
	MOVLW	0xAB	; W = dado a ser escrito na mem�ria
	CALL	FLASH_WRITE_BYTE	; chama a subrotina
FIM:
	BRA		FIM
	END
