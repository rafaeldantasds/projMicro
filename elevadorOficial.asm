
#INCLUDE <P16F877A.INC>; CHAMA BIBLIOTECA DO PIC

#define Clock 400000

#DEFINE	BANCO0 BCF STATUS,RP0; SELEÇÃO DE BANCO0
#DEFINE	BANCO1 BSF STATUS,RP0; SELEÇÃO DE BANCO1

;NOMEANDO PORTD 
#DEFINE	BIN3	PORTD,0 ; NOMEIA PINO 
#DEFINE	BIN2	PORTD,1 ; NOMEIA PINO 
#DEFINE	BIN1	PORTD,2 ; NOMEIA PINO
#DEFINE	BIN0	PORTD,3 ; NOMEIA PINO 
#DEFINE	BIN_OPEN	PORTD,4 ; NOMEIA PINO 
#DEFINE	BIN_CLOSED	PORTD,5 ; NOMEIA PINO 
#DEFINE	BIN_EMERG	PORTD,6 ; NOMEIA PINO 
#DEFINE	BEX_0	PORTD,7 ; NOMEIA PINO 

;NOMEANDO PORTC
#DEFINE	PWM1	PORTC,1 ; NOMEIA PINO 
#DEFINE	PWM2	PORTC,2 ; NOMEIA PINO
#DEFINE	OPEN	PORTC,3 ; NOMEIA PINO 
#DEFINE	CLOSED	PORTC,4 ; NOMEIA PINO 
#DEFINE	BUZZY	PORTC,5 ; NOMEIA PINO 
#DEFINE	UP	PORTC,6 ; NOMEIA PINO 
#DEFINE	DOWN	PORTC,7 ; NOMEIA PINO 

;NOMEANDO PORTA 
#DEFINE	SC	PORTA,0 ; NOMEIA PINO 
#DEFINE	SOPEN	PORTA,1 ; NOMEIA PINO 
#DEFINE	S0	PORTA,2 ; NOMEIA PINO
#DEFINE	S1	PORTA,3 ; NOMEIA PINO 
#DEFINE	S2	PORTA,5 ; NOMEIA PINO 

;NOMEANDO PORTE 
#DEFINE	S3	PORTE,0 ; NOMEIA PINO 

;NOMEANDO PORTB 
#DEFINE	SFLUX	PORTA,0 ; NOMEIA PINO 
#DEFINE	DISPLAY	PORTA,1 ; NOMEIA PINO 
#DEFINE	DISPLA1	PORTA,2 ; NOMEIA PINO
#DEFINE	BEX_3	PORTA,3 ; NOMEIA PINO 
#DEFINE	BEX_2_UP	PORTA,4 ; NOMEIA PINO 
#DEFINE	BEX_2_D	PORTA,5 ; NOMEIA PINO 
#DEFINE	BEX_1_UP	PORTA,6 ; NOMEIA PINO 
#DEFINE	BEX_1_D	PORTA,7 ; NOMEIA PINO 



;-------------------------------------------------
TEMP EQU 0X20
TEMP1 EQU 0X21
TEMP2 EQU 0X22
TEMP3 EQU 0X23
TEMP4 EQU 0X24
TEMP5 EQU 0X25


;-------------------------------------------------

ORG 0X00
GOTO SETUP
;-------------------------------------------------

;CONFIGURAÇÃO DAS ENTRADAS E SAÍDAS / DESLIGANDO COMPARADORES / CONFIGURANDO ENTRADAS COMO DIGITAIS

SETUP:
BANCO1; CONTÉM TRISA, ADCON E CMCON
MOVLW 0XFF; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X85; CONFIGURA PORTA COMO ENTRADA
MOVLW 0XF9; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X86; CONFIGURA PORTB COMO SAÍDA/ENTRADA
MOVLW 0X00; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X87; CONFIGURA TODOS BITS DO PORTC COMO SAÍDA
MOVLW 0XFF; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X88; CONFIGURA TODOS BITS DO PORTD COMO ENTRADA
MOVLW 0X07; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X89; CONFIGURA TODOS BITS DO PORTE COMO ENTRADA


MOVLW 0X07;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF CMCON; DESLIGA COMPARADOR
MOVLW 0X07;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF ADCON1; DESLIGA COMPARADOR

;-------------------------------------------------

BANCO0	
CLRF PORTA; MANDA NÍVEL LÓGICO ZERO PARA TODOS OS PINOS DO PORTA
CLRF PORTB; MANDA NÍVEL LÓGICO ZERO PARA TODOS OS PINOS DO PORTB
CLRF PORTC; MANDA NÍVEL LÓGICO ZERO PARA TODOS OS PINOS DO PORTC
CLRF PORTD; MANDA NÍVEL LÓGICO ZERO PARA TODOS OS PINOS DO PORTD
CLRF PORTE; MANDA NÍVEL LÓGICO ZERO PARA TODOS OS PINOS DO PORTE



GOTO ALARME; VAI PARA PROGRAMA PRINCIPAL

;IDENTIFICAÇÃO E INDICAÇÃO DOS ANDARES ATRAVÉS DO DISPLAY E TESTE DE PORTA

ALARME: BSF BUZZY ; SETA BIT 5 - RC5 ; LIGA ALARME SONORO 
INICIO:	BTFSS S0 ; VERIFICA SE O SENSOR DO TÉRREO ESTÁ ACIONADO, OU SEJA, SE O ELEVADOR ESTÁ NO TÉRREO - S0
GOTO DESC1 ; SE O SENSOR S0, NÃO ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 1º ANDAR - S1
GOTO AND0 ; SE O SENSOR S0,ESTIVER ACIONADO, INDICA NO DISPLAY O N° DO ANDAR

DESC1:	BTFSS S1 ; VERIFICA SE O SENSOR DO 1º ANDAR ESTÁ ACIONADO, OU SEJA, SE O ELEVADOR ESTÁ NO 1º ANDAR - S1
GOTO DESC2 ; SE O SENSOR S1, NÃO ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 2º ANDAR - S2
GOTO AND1 ; SE O SENSOR S1,ESTIVER ACIONADO, INDICA NO DISPLAY O N° DO ANDAR 

DESC2:	BTFSS S2 ; VERIFICA SE O SENSOR DO 2º ANDAR ESTÁ ACIONADO, OU SEJA, SE O ELEVADOR ESTÁ NO 2º ANDAR - S2
GOTO DESC3 ; SE O SENSOR S2, NÃO ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 3º ANDAR - S3
GOTO AND2 ; SE O SENSOR S2,ESTIVER ACIONADO, INDICA NO DISPLAY O N° DO ANDAR 

DESC3:	BTFSS S3 ; VERIFICA SE O SENSOR DO 3º ANDAR ESTÁ ACIONADO, OU SEJA, SE O ELEVADOR ESTÁ NO 3º ANDAR - S2
GOTO POSIÇ ; SE O SENSORES S3,S2,S1 E S0 NÃO ESTIVEREM ACIONADOS, O ELEVADOR SERÁ REPOSICIONADO PARA O ANDAR DE BAIXO.
GOTO AND3 ; SE O SENSOR S3,ESTIVER ACIONADO, INDICA NO DISPLAY O N° DO ANDAR 

AND0:	BCF DOWN ; PÁRA DESCIDA DO ELEVADOR
BCF PORTB,1 ;RESETA BIT 1 - RB1 ; VALOR "ZERO" NO DISPLAY
BCF PORTB,2 ;RESETA BIT 1 - RB2 ; VALOR "ZERO" NO DISPLAY
CALL SEGURA ;VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


AND1:	BCF DOWN ; PÁRA DESCIDA DO ELEVADOR
BSF PORTB,1 ;SETA BIT 1 - RB1 ; VALOR "UM" NO DISPLAY
BCF PORTB,2 ;RESETA BIT 2 - RB2 ; VALOR "UM" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 

AND2:	BCF DOWN ; PÁRA DESCIDA DO ELEVADOR
BCF PORTB,1 ;RESETA BIT 1 - RB1 ; VALOR "DOIS" NO DISPLAY 
BSF PORTB,2 ;SETA BIT 2 - RB2 ; VALOR "DOIS" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


AND3:	BCF DOWN ; PÁRA DESCIDA DO ELEVADOR
BSF PORTB,1 ;SETA BIT 1 - RB1 ; VALOR "TRÊS" NO DISPLAY
BSF PORTB,2 ;SETA BIT 2 - RB2 ; VALOR "TRÊS" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


; TEMPO DE ALARME SONORO ACIONADO//TESTE ABERTURA E FECHAMENTO DA PORTA//TEMPO PARA FECHAMENTO DE PORTA

POSIÇ:	CALL SEGURA ; FAZ A ROTINA PARA VERIFICAR ESTADO DA PORTA
BSF DOWN ; MANDA O ELEVADOR DESCER ATÉ ENCONTRAR UM SENSOR
GOTO INICIO ; VOLTA PARA INICIO E VERIFICA SE algum SENSOR FOI ATIVADO

; SUB ROTINA PORTA
SEGURA:	MOVLW .10 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP2 ;CARREGA A CONSTANTE COM O VALOR 4 
LOOP2:	MOVLW .100 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP ;CARREGA A CONSTANTE COM O VALOR 100	
LOOP:	MOVLW .250 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP1 ;CARREGA A CONSTANTE COM O VALOR 250	

LOOP1:	NOP ;GASTA 1us.
DECFSZ TEMP1,F	;DECREMENTA CONSTANTE TEMP1; GASTA 1us.
GOTO LOOP1 ;TEMP1 DIFERENTE DE ZERO, VAI PARA LOOP1 ; GASTA 2us
DECFSZ TEMP,F ;DECREMENTA CONSTANTE TEMP; GASTA 1us.
GOTO LOOP ;TEMP DIFERENTE DE ZERO, VAI PARA LOOP ; GASTA 2us
DECFSZ TEMP2,F ;DECREMENTA CONSTANTE TEMP2; GASTA 1us.
GOTO LOOP2 ;TEMP2 DIFERENTE DE ZERO, VAI PARA LOOP2 ; GASTA 2us
BCF BUZZY ;RESETA BIT 5 - RC5 ; DESLIGA ALARME SONORO
GOTO ABERTA

; TESTE ABERTURA E FECHAMENTO DA PORTA / TEMPO FECHAMENTO DE PORTA

ABERTA:	BTFSS SOPEN ; SE 1 PORTA ABERTA
GOTO FECHADA ; VAI PARA PORTA FECHADA
DOOR:	BSF CLOSED ;SETA BIT 4 - RC4 ;FECHA PORTA
BTFSS SC	; VERIFICA SE A PORTA FECHOU
GOTO DOOR ; VOLTA PARA DOOR
BCF CLOSED ; DESLIGA FECHAMENTO DE PORTA
GOTO FECHADA ; INICIO DE FUNCIONAMENTO, ESPERA DE CHAMADA

FECHADA:BTFSS SC ; CASO A PORTA NO MOMENTO DA INICIALIZAÇÃO ESTEJA FORA DE POSIÇÃO, ELE MANDARÁ FECHAR PORTA.
GOTO DOOR	; MANDA FECHAR A PORTA	
RETURN ; RETORNA A PROXIMA INSTRUÇÃO DE ONDE FOI CHAMADA

; ESPERA DE CHAMADA

ESPERA0:BTFSS BEX_0 ;VER SE O BOTÃO EXTERNO DO TÉRREO FOI ACIONADO 
GOTO ESPERA0
CALL ABRIR ; VAI PARA A SUB ROTINA

BTFSS BIN1 ; VERIFICA SE O BOTÃO INTERNO PARA O 1º ANDAR O ESTÁ ACIONADO
GOTO ESPERA0
INCF 0X27 ; GUARDA STATUS DO BOTÃO EXTERNO DO TÉRREO
BTFSS BIN2 ; VERIFICA SE O BOTÃO INTERNO PARA O 1º ANDAR O ESTÁ ACIONADO
GOTO ESPERA0
INCF 0X28 ; GUARDA STATUS DO BOTÃO EXTERNO DO TÉRREO
BTFSS BIN3 ; VERIFICA SE O BOTÃO INTERNO PARA O 1º ANDAR O ESTÁ ACIONADO
GOTO ESPERA0
INCF 0X29 ; GUARDA STATUS DO BOTÃO EXTERNO DO TÉRREO


END