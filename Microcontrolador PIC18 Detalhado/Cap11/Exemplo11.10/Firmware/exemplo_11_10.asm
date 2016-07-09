	LIST P=18F4520
	#include <P18F4520.INC>
; ************************ Bits de configura��o ************************************
	CONFIG	OSC=XT,PWRT=ON,WDT=OFF,MCLRE=ON,DEBUG=OFF,LVP=OFF,BOREN=OFF
CBLOCK 	0x010
	EEP_NUM_BYTES_WR		; n�mero de bytes a serem escritos na EEPROM
ENDC
	org 	0x0000		; vetor de reset
	BRA		INICIO
	org		0x0008		; vetor de interrup��o
	BTFSC	PIR2,EEIF		; se for interrup��o da EEPROM
	BRA		TRATA_EEPROM_WR	; vai para a ISR da EEPROM
	RETFIE	FAST
TRATA_EEPROM_WR:		; esta � a ISR da EEPROM
	BCF		PIR2,EEIF		; apaga o flag de interrup��o
	MOVF	EEP_NUM_BYTES_WR,F	; verifica se h� bytes para escrever ...
	BTFSC	STATUS,Z		; se n�o houver ...
	RETFIE	FAST		; retorna da interrup��o
	MOVF	POSTINC0,W	; se houver, move o pr�ximo byte para W
	MOVWF	EEDATA		; e escreve em EEDATA
	MOVLW	0x55		; senha de escrita na EEPROM
	MOVWF	EECON2
	MOVLW	0xAA
	MOVWF	EECON2
	BSF		EECON1,WR		; seta WR e inicia a escrita da EEPROM
	INCF	EEADR,F		; incrementa o endere�o da EEPROM
	DECF	EEP_NUM_BYTES_WR,F	; decrementa o n�mero de bytes restantes a programar
	RETFIE	FAST		; retorna da interrup��o
WRITE_EEPROM_INT:		; subrotina de escrita de dados na EEPROM
	BTFSC	EECON1,WR		; verifica se uma escrita est� em andamento
	BRA		WRITE_EEPROM_INT	; se estiver aguarda terminar
	MOVLW	0x04
	MOVWF	EECON1		; WREN = 1 em EECON1
	; agora for�amos uma interrup��o da EEPROM. A ISR da EEPROM cont�m o mecanismo
	; de escrita. Assim economizamos um trecho de c�digo repetido!
	BSF		PIR2,EEIF		; seta EEIF (simula uma interrup��o)
	BSF		PIE2,EEIE		; habilita a interrup��o da EEPROM
	; uma interrup��o acontece antes do RETURN a seguir ser executado
	RETURN
INICIO:
	BSF		INTCON,GIE	; habilita interrup��es globais
	BSF		INTCON,PEIE	; habilita interrup��es perif�ricas
	LFSR	0,0x100		; FSR0 aponta para o endere�o 0x100 da RAM
	MOVLW	0x12		
	MOVWF	POSTINC0		; escreve 0x12 no endere�o 0x100
	MOVLW	0x34
	MOVWF	POSTINC0		; escreve 0x34 no endere�o 0x101
	MOVLW	0x56
	MOVWF	POSTINC0		; escreve 0x56 no endere�o 0x102
	LFSR	0,0x100		; faz FSR0 apontar novamente para 0x100
	MOVLW	.3		
	MOVWF	EEP_NUM_BYTES_WR	; n�mero de bytes a escrever � igual a 3
	CLRF	EEADR		; o endere�o inicial da EEPROM � 0x00
	CALL	WRITE_EEPROM_INT	; inicia a escrita
FIM:
	BRA		FIM		; loop
	END
