; Relógio digital com alarme
LIST  P=16F627
INCLUDE <P16F627.INC>
INCLUDE <MACROS.ASM>
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF
;
; *************************************************************************************************
; Definição das variáveis
;
HORA	EQU 0x20		; registrador de armazenamento das horas (00 a 23)
MINUTO	EQU 0x21		; registrador de armazenamento dos minutos (00 a 59)
H_AL	EQU 0x22		; registrador de armazenamento das horas do alarme (00 a 23)
M_AL	EQU 0x23		; registrador de armazenamento dos minutos do alarma (00 a 59)
TEMP	EQU 0x24		; registrador temporário de uso geral
TEMP1	EQU 0x25		; registrador temporário de uso geral
FLAGS	EQU 0x26		; flags de estado do relógio
SEG	EQU 0x27		; segundos
D0	EQU 0x28		;
D1	EQU 0x29		;
W_TEMP	EQU 0x2A		;
STATUS_TEMP EQU 0x2B		;
T1_CONTA EQU 0x2C		; contador auxiliar do timer 1
TECLA	EQU 0x2D		; número da tecla pressionada
TECLA_C	EQU 0x2E		; temporizador das teclas
#DEFINE	AL_ON FLAGS,0		; indicador de alarme ligado
#DEFINE	AL_DIS FLAGS,1		; indicador de alarme disparado
#DEFINE	MODO FLAGS,2		; modo (0-relógio,1-alarme)
#DEFINE PONTO FLAGS,3		; Pontos separadores HH:MM
#DEFINE	S1 PORTB,0		; Horas
#DEFINE	S2 PORTB,1		; Minutos
#DEFINE	S3 PORTB,2		; Modo
#DEFINE	S4 PORTB,3		; Alarme
#DEFINE	DIS0 PORTA,0		; Catodo do display DIS0
#DEFINE	DIS1 PORTA,1		; Catodo do display DIS1
#DEFINE	DIS2 PORTA,2		; Catodo do display DIS2
#DEFINE	DIS3 PORTA,3		; Catodo do display DIS3
#DEFINE	LEDS PORTA,4		; Catodo dos Leds 
#DEFINE	PONTO1 0		; Anodo do Led separador
#DEFINE PONTO2 1		; Anodo do Led separador
#DEFINE	LED_MH 2		; Anodo do LED de modo hora
#DEFINE	LED_MA 3		; Anodo do LED de modo alarme
#DEFINE LED_AL 4		; Anodo do LED de alarme ligado
#DEFINE	BUZZER PORTB,7		; Buzzer 

ORG 0x0000
	GOTO	INICIO
ORG 0x0004
	SALVA_CONTEXTO		; salva o contexto atual
	BCF	PIR1,TMR1IF	; apaga flag de interrupção do timer 1
	MOVLW	0xDC		; 
	MOVWF	TMR1L		;
	MOVLW	0x0B		;
	MOVWF	TMR1H		; inicializa o timer 1 em 3036 decimal
	DECFSZ	T1_CONTA,F	; decrementa a variável de contagem do timer 1
	GOTO	FIM_INT		; se diferente de zero sai da interrupção
	MOVLW	2		; 
	MOVWF	T1_CONTA	; reinicializa a variaável de contagem em 2
	INCF	SEG,F		; incrementa 1 segundo
	MOVLW	D'60'		; verifica ...
	XORWF	SEG,W		; se passou de 59 segundos ...
	BTFSS	STATUS,Z	;
	GOTO	FIM_INT		; se não, sai da interrupção
	CLRF	SEG		; se passsou ...
	INCF	MINUTO,F	; incrementa 1 nos minutos
	MOVLW	D'60'		; verifica se passou ...
	XORWF	MINUTO,W	; ...
	BTFSS	STATUS,Z	; de 59 minutos ...
	GOTO	FIM_INT		; se não passou, sai da interrupção
	CLRF	MINUTO		; se passou, apaga os minutos
	INCF	HORA,F		; incrementa 1 hora
	MOVLW	D'24'		; verifica se passou de
	XORWF	HORA,W		; ...
	BTFSS	STATUS,Z	; 23 horas ...
	GOTO	FIM_INT		; se não passou, sai da subrotina
	CLRF	HORA		; se passou, zera a hora
FIM_INT:
	RESTAURA_CONTEXTO	; restaura o contexto anterior
	RETFIE			; retorna da interrupção
DECOD_DISPLAY:
	MOVWF	TEMP		; armazena o número na variável deslocamento
	MOVLW	LOW TABELA	; copia em W os 8 bits LSB do endereço da TABELA
	ADDWF	TEMP,F		; adiciona o valor à variável DESLOCAMENTO
	MOVLW	HIGH TABELA	; copia em W os 5 bits superiores do endereço da TABELA
	BTFSC	STATUS,C	; testa para ver se a soma anterior transbordou 
	ADDLW	0x01		; se transbordou, soma 1 ao W
	MOVWF	PCLATH		; acerta o PCLATH de acordo com o endereço da TABELA
	MOVF	TEMP,W		; copia o valor do DESLOCAMENTO para o W
	MOVWF	PCL		; copia o W para o PCL (desvia para a tabela)
TABELA:
	RETLW	B'00111111'	; número 0
	RETLW	B'00000110'	; número 1
	RETLW	B'01011011'	; número 2
	RETLW	B'01001111'	; número 3
	RETLW	B'01100110'	; número 4
	RETLW	B'01101101'	; número 5
	RETLW	B'01111101'	; número 6
	RETLW	B'00000111'	; número 7
	RETLW	B'01111111'	; número 8
	RETLW	B'01100111'	; número 9
	RETLW	B'01110111'	; dígito A	
	RETLW	B'01111100'	; dígito B
	RETLW	B'00111001'	; dígito C
	RETLW	B'01011110'	; dígito D
	RETLW	B'01111001'	; dígito E
	RETLW	B'01110001'	; dígito F
ATRASO:				; Subrotina de atraso
	ADDLW	1		; soma 1 ao W
	BTFSC	STATUS,Z	; testa se W=0 ...
	RETURN			; se W=0, retorna
	GOTO	ATRASO		; se W diferente de 0, desvia para ATRASO_LOOP
DISPLAY:
	BTFSC	MODO		;
	GOTO	MOSTRA_ALARME	;
	MOVF	MINUTO,W	; copia o dígito em W
	CALL	BIN8DEC		;
	MOVF	D0,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS0		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS0		; desativa display 0
	MOVF	D1,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS1		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS1		; desativa display 0
	MOVF	HORA,W		; copia o dígito em W
	CALL	BIN8DEC		;
	MOVF	D0,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS2		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS2		; desativa display 0
	MOVF	D1,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS3		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS3		; desativa display 0
	GOTO	MOSTRA_LEDS	;
MOSTRA_ALARME:
	MOVF	M_AL,W		; copia o dígito em W
	CALL	BIN8DEC		;
	MOVF	D0,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS0		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS0		; desativa display 0
	MOVF	D1,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS1		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS1		; desativa display 0
	MOVF	H_AL,W		; copia o dígito em W
	CALL	BIN8DEC		;
	MOVF	D0,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS2		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS2		; desativa display 0
	MOVF	D1,W		;
	CALL	DECOD_DISPLAY	; decodifica o dígito
	MOVWF	PORTB		; ativa os segmentos do display
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSF	BUZZER		; ativa o buzzer
	BCF	DIS3		; ativa display 0
	CLRW			; W=0
	CALL	ATRASO		; espera
	BSF	DIS3		; desativa display 0
MOSTRA_LEDS:
	CLRW			; apaga o W
	BTFSC	AL_ON		; AL_ON=1 ?
	BSW	LED_AL		; sim -> ativa led LED_AL
	BTFSS	MODO		; modo relógio ?
	BSW	LED_MH		; sim -> acende led de modo hora
	BTFSC	MODO		; modo alarme ?
	BSW	LED_MA		; sim -> acende led de modo alarme
	BTFSC	PONTO		; pontos ativados ?
	IORLW	B'00000011'	; sim > acende os leds separadores
	BTFSC	AL_DIS		; testa se o alarme está disparado
	BSW	7		; ativa o buzzer
	MOVWF	PORTB		; copia o valor final de W para o PORTB
	BCF	LEDS		;
	CLRW			;
	CALL	ATRASO		;
	BSF	LEDS		;
	RETURN			; retorna

BIN8DEC:
	MOVWF	D0		; copia o número a ser convertido para a variável de unidades
	CLRF	D1		; limpa as dezenas
BIN8DEC_2:
	MOVLW	D'10'		; subtrai 10 decimal ...
	SUBWF	D0,W		; ... do valor a ser convertido e guarda o resultado em W
	BTFSS	STATUS,C	; o resultado é positivo ou zero ?
	RETURN			; não ? então retorna, a conversão terminou
	MOVWF	D0		; sim ? então copia o resultado em W para as unidades ...
	INCF	D1,F		; incrementa um nas dezenas 
	GOTO	BIN8DEC_2	; e reinicia o ciclo
TECLAS:
	BANKSEL TRISB		;
	MOVLW	B'00001111'	;
	MOVWF	TRISB		; configura RB0 a RB3 como entradas
	BANKSEL T1CON		;
	BTFSS	S1		; testa se é a tecla S1
	GOTO	TECLAS_S1	; vai para tratamento da tecla S1
	BTFSS	S2		; testa se é a tecla S2
	GOTO	TECLAS_S2	; vai para tratamento da tecla S2
	BTFSS	S3		; testa se é a tecla S3
	GOTO	TECLAS_S3	; vai para tratamento da tecla S3
	BTFSS	S4		; testa se é a tecla S4
	GOTO	TECLAS_S4	; vai para tratamento da tecla S4
	CLRF	TECLA		; apaga a tecla (nenhuma foi pressionada)
TECLAS_FIM:
	MOVLW	D'30'		; 
	MOVWF	TECLA_C		; reinicializa o temporizador das teclas
TECLAS_FIM2:
	BANKSEL	TRISB		;
	CLRF	TRISB		; configura porta B para saída
	BANKSEL	T1CON		;
	RETURN			; retorna
TECLAS_S1:
	MOVLW	1		; compara ...
	XORWF	TECLA,F		; a tecla pressionada com tecla anterior ...
	MOVWF	TECLA		; tecla atual é a 1
	BTFSS	STATUS,Z	; se a tecla atual é diferente da ...
	GOTO	TECLAS_FIM	; ... anterior, vai para o final
	MOVF	TECLA_C,F	; testa se o temporizador das teclas ...
	BTFSC	STATUS,Z	; ... está em zero ...
	GOTO	TECLAS_FIM2	; se estiver, vai para o final
	DECFSZ	TECLA_C,F	; decrementa o temporizador das teclas
	GOTO	TECLAS_FIM2	; se maior que zero vai para o final
	BTFSS	MODO		; se o MODO=0
	INCF	HORA,F		; incrementa a hora atual
	BTFSC	MODO		; se o MODO=1
	INCF	H_AL,F		; incrementa a hora do alarme
	MOVLW	D'24'		; verifica ...
	XORWF	HORA,W		; se a hora é igual a 24
	BTFSC	STATUS,Z	; se for ...
	CLRF	HORA		; zera a hora
	MOVLW	D'24'		; verifica ...
	XORWF	H_AL,W		; se a hora do alarme é igual a 24
	BTFSC	STATUS,Z	; se for ...
	CLRF	H_AL		; zera a hora do alarme
	GOTO	TECLAS_FIM2	; vai para o final
TECLAS_S2:
	MOVLW	2		; compara ...
	XORWF	TECLA,F		; a tecla pressionada com tecla anterior ...
	MOVWF	TECLA		; tecla atual é a 2
	BTFSS	STATUS,Z	; se a tecla atual é diferente da ...
	GOTO	TECLAS_FIM	; ... anterior, vai para o final
	MOVF	TECLA_C,F	; testa se o temporizador das teclas ...
	BTFSC	STATUS,Z	; ... está em zero ...
	GOTO	TECLAS_FIM2	; se estiver, vai para o final
	DECFSZ	TECLA_C,F	; decrementa o temporizador das teclas
	GOTO	TECLAS_FIM2	; se maior que zero vai para o final
	BTFSS	MODO		; se o MODO=0
	INCF	MINUTO,F	; incrementa o minuto atual
	BTFSC	MODO		; se o MODO=1
	INCF	M_AL,F		; incrementa o minuto do alarme
	MOVLW	D'60'		; verifica ...
	XORWF	MINUTO,W	; se os minutos são iguais a 60
	BTFSC	STATUS,Z	; se forem ...
	CLRF	HORA		; zera os minutos
	MOVLW	D'60'		; verifica ...
	XORWF	M_AL,W		; se os minutos do alarme são iguais a 60
	BTFSC	STATUS,Z	; se forem ...
	CLRF	H_AL		; zera os minutos do alarme
	GOTO	TECLAS_FIM2	; vai para o final
TECLAS_S3:
	MOVLW	3		; compara ...
	XORWF	TECLA,F		; a tecla pressionada com tecla anterior ...
	MOVWF	TECLA		; tecla atual é a 3
	BTFSS	STATUS,Z	; se a tecla atual é diferente da ...
	GOTO	TECLAS_FIM	; ... anterior, vai para o final
	MOVF	TECLA_C,F	; testa se o temporizador das teclas ...
	BTFSC	STATUS,Z	; ... está em zero ...
	GOTO	TECLAS_FIM2	; se estiver, vai para o final
	DECFSZ	TECLA_C,F	; decrementa o temporizador das teclas
	GOTO	TECLAS_FIM2	; se maior que zero vai para o final
	COMBF	MODO		; muda o modo
	GOTO	TECLAS_FIM2	; vai para o final
TECLAS_S4:
	MOVLW	4		; compara ...
	XORWF	TECLA,F		; a tecla pressionada com tecla anterior ...
	MOVWF	TECLA		; tecla atual é a 4
	BTFSS	STATUS,Z	; se a tecla atual é diferente da ...
	GOTO	TECLAS_FIM	; ... anterior, vai para o final
	MOVF	TECLA_C,F	; testa se o temporizador das teclas ...
	BTFSC	STATUS,Z	; ... está em zero ...
	GOTO	TECLAS_FIM2	; se estiver, vai para o final
	DECFSZ	TECLA_C,F	; decrementa o temporizador das teclas
	GOTO	TECLAS_FIM2	; se maior que zero vai para o final
	BTFSC	AL_DIS		; o alarme está disparado ?
	GOTO	DESLIGA_ALARME	; sim -> vai para DESLIGA_ALARME
	COMBF	AL_ON		; inverte o estado do alarme
	GOTO	TECLAS_FIM2	; vai para o final	
DESLIGA_ALARME:
	BCF	BUZZER		; desliga buzzer
	GOTO	TECLAS_FIM2	; vai para o final
VERIFICA_ALARME:
	BTFSS	AL_ON		; verifica se o alarme está ligado
	RETURN			; não ? Então retorna
	MOVF	HORA,W		; testa se a hora ...
	XORWF	H_AL,W		; é igual a do alarme ...
	BTFSS	STATUS,Z	;
	RETURN			; não ? Então retorna
	MOVF	MINUTO,W	; testa se os minutos ...
	XORWF	M_AL,W		; são iguais aos do alarme ...
	BTFSS	STATUS,Z	;
	RETURN			; não ? Então retorna
; se o programa chegou até aqui, então o horário do alarme é igual ao
; horário atual. O alarme então irá disparar
	BSF	AL_DIS		; ativa o flag do alarme
	BSF	BUZZER		; ativa o buzzer
	RETURN			; retorna
INICIO:
	MOVLW	B'00000111'
	MOVWF	CMCON		; configura os comparadores analógicos para modo 7
	BANKSEL	TRISA		;
	CLRF	TRISA		; porta A como saída
	CLRF	TRISB		; porta B como saída
	MOVLW	B'00000001'	;
	MOVWF	PIE1		; habilita interrupção do timer 1
	CLRF	OPTION_REG	; ativa resistores de PULL-UP
	BANKSEL	T1CON		;
	MOVLW	B'00110000'	;
	MOVWF	T1CON		; configura o timer 1 para clock interno e prescaler 1:8
	MOVLW	0xDC		;
	MOVWF	TMR1L		;
	MOVLW	0x0B		;
	MOVWF	TMR1H		; inicializa o timer 1 em 3036 decimal
	CLRF	SEG		; apaga variáveis
	CLRF	MINUTO		; ...
	CLRF	HORA		; ...
	CLRF	H_AL		; ...
	CLRF	M_AL		; ...
	CLRF	FLAGS		; ...
	BSF	T1CON,TMR1ON	; ativa a contagem do timer 1
	MOVLW	B'11000000'	;
	MOVWF	INTCON		; habilita GIE e PEIE

LOOP_PRINCIPAL:
	CALL	DISPLAY		; mostra display
	CALL	TECLAS		; verifica teclas
	CALL	VERIFICA_ALARME	; verifica o horário
	BTFSC	AL_DIS		;
	BSF	BUZZER		; ativa o alarme
	GOTO	LOOP_PRINCIPAL	; retorna para o LOOP_PRINCIPAL
END


