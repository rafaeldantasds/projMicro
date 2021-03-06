
#INCLUDE <P16F877A.INC>; CHAMA BIBLIOTECA DO PIC

#define Clock 400000

#DEFINE	BANCO0 BCF STATUS,RP0; SELE��O DE BANCO0
#DEFINE	BANCO1 BSF STATUS,RP0; SELE��O DE BANCO1

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

;CONFIGURA��O DAS ENTRADAS E SA�DAS / DESLIGANDO COMPARADORES / CONFIGURANDO ENTRADAS COMO DIGITAIS

SETUP:
;BANCO1; CONT�M TRISA, ADCON E CMCON
;bcf 0x03
bsf 0x03,0 ;BANCO 1
MOVLW 0XFF; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X85; TRISA CONFIGURA PORTA COMO ENTRADA
MOVLW 0XF9; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X86; TRISB CONFIGURA PORTB COMO SA�DA/ENTRADA
CLRF  0x87; TRISC COMO SAIDA
MOVLW 0XFF; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X88; CONFIGURA TODOS BITS DO PORTD COMO ENTRADA
MOVLW 0X07; COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0X89; CONFIGURA TODOS BITS DO PORTE COMO ENTRADA


MOVLW 0X07;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0x9C; CMCON    DESLIGA COMPARADOR 
MOVLW 0X07;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF 0x9F; ADCON1   DESLIGA COMPARADOR

;-------------------------------------------------

BANCO0	
CLRF 0x05; MANDA N�VEL L�GICO ZERO PARA TODOS OS PINOS DO PORTA
CLRF 0x06; MANDA N�VEL L�GICO ZERO PARA TODOS OS PINOS DO PORTB
CLRF 0x07; MANDA N�VEL L�GICO ZERO PARA TODOS OS PINOS DO PORTC
CLRF 0x08; MANDA N�VEL L�GICO ZERO PARA TODOS OS PINOS DO PORTD
CLRF 0x09; MANDA N�VEL L�GICO ZERO PARA TODOS OS PINOS DO PORTE



GOTO ALARME; VAI PARA PROGRAMA PRINCIPAL

;IDENTIFICA��O E INDICA��O DOS ANDARES ATRAV�S DO DISPLAY E TESTE DE PORTA

ALARME: BSF BUZZY ; SETA BIT 5 - RC5 ; LIGA ALARME SONORO 
INICIO:	BTFSS S0 ; VERIFICA SE O SENSOR DO T�RREO EST� ACIONADO, OU SEJA, SE O ELEVADOR EST� NO T�RREO - S0
GOTO DESC1 ; SE O SENSOR S0, N�O ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 1� ANDAR - S1
GOTO AND0 ; SE O SENSOR S0,ESTIVER ACIONADO, INDICA NO DISPLAY O N� DO ANDAR

DESC1:	BTFSS S1 ; VERIFICA SE O SENSOR DO 1� ANDAR EST� ACIONADO, OU SEJA, SE O ELEVADOR EST� NO 1� ANDAR - S1
GOTO DESC2 ; SE O SENSOR S1, N�O ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 2� ANDAR - S2
GOTO AND1 ; SE O SENSOR S1,ESTIVER ACIONADO, INDICA NO DISPLAY O N� DO ANDAR 

DESC2:	BTFSS S2 ; VERIFICA SE O SENSOR DO 2� ANDAR EST� ACIONADO, OU SEJA, SE O ELEVADOR EST� NO 2� ANDAR - S2
GOTO DESC3 ; SE O SENSOR S2, N�O ESTIVER ACIONADO FAZ A LEITURA DO SENSOR DO 3� ANDAR - S3
GOTO AND2 ; SE O SENSOR S2,ESTIVER ACIONADO, INDICA NO DISPLAY O N� DO ANDAR 

DESC3:	BTFSS S3 ; VERIFICA SE O SENSOR DO 3� ANDAR EST� ACIONADO, OU SEJA, SE O ELEVADOR EST� NO 3� ANDAR - S2
GOTO POSI� ; SE O SENSORES S3,S2,S1 E S0 N�O ESTIVEREM ACIONADOS, O ELEVADOR SER� REPOSICIONADO PARA O ANDAR DE BAIXO.
GOTO AND3 ; SE O SENSOR S3,ESTIVER ACIONADO, INDICA NO DISPLAY O N� DO ANDAR 

AND0:	BCF DOWN ; P�RA DESCIDA DO ELEVADOR
BCF PORTB,1 ;RESETA BIT 1 - RB1 ; VALOR "ZERO" NO DISPLAY
BCF PORTB,2 ;RESETA BIT 1 - RB2 ; VALOR "ZERO" NO DISPLAY
CALL SEGURA ;VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


AND1:	BCF DOWN ; P�RA DESCIDA DO ELEVADOR
BSF PORTB,1 ;SETA BIT 1 - RB1 ; VALOR "UM" NO DISPLAY
BCF PORTB,2 ;RESETA BIT 2 - RB2 ; VALOR "UM" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 

AND2:	BCF DOWN ; P�RA DESCIDA DO ELEVADOR
BCF PORTB,1 ;RESETA BIT 1 - RB1 ; VALOR "DOIS" NO DISPLAY 
BSF PORTB,2 ;SETA BIT 2 - RB2 ; VALOR "DOIS" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


AND3:	BCF DOWN ; P�RA DESCIDA DO ELEVADOR
BSF PORTB,1 ;SETA BIT 1 - RB1 ; VALOR "TR�S" NO DISPLAY
BSF PORTB,2 ;SETA BIT 2 - RB2 ; VALOR "TR�S" NO DISPLAY
CALL SEGURA ; VAI PARA SEGURA
GOTO ESPERA0 ; ESPERA CHAMADA 


; TEMPO DE ALARME SONORO ACIONADO//TESTE ABERTURA E FECHAMENTO DA PORTA//TEMPO PARA FECHAMENTO DE PORTA

POSI�:	CALL SEGURA ; FAZ A ROTINA PARA VERIFICAR ESTADO DA PORTA
BSF DOWN ; MANDA O ELEVADOR DESCER AT� ENCONTRAR UM SENSOR
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

FECHADA:BTFSS SC ; CASO A PORTA NO MOMENTO DA INICIALIZA��O ESTEJA FORA DE POSI��O, ELE MANDAR� FECHAR PORTA.
GOTO DOOR	; MANDA FECHAR A PORTA	
RETURN ; RETORNA A PROXIMA INSTRU��O DE ONDE FOI CHAMADA

; ESPERA DE CHAMADA

ESPERA0:BTFSS BEX_0 ;VER SE O BOT�O EXTERNO DO T�RREO FOI ACIONADO 
GOTO ESPERA0
gosto ABRIR ; VAI PARA A SUB ROTINA

BTFSS BIN1 ; VERIFICA SE O BOT�O INTERNO PARA O 1� ANDAR O EST� ACIONADO
GOTO ESPERA0
INCF 0X27 ; GUARDA STATUS DO BOT�O EXTERNO DO T�RREO
BTFSS BIN2 ; VERIFICA SE O BOT�O INTERNO PARA O 1� ANDAR O EST� ACIONADO
GOTO ESPERA0
INCF 0X28 ; GUARDA STATUS DO BOT�O EXTERNO DO T�RREO
BTFSS BIN3 ; VERIFICA SE O BOT�O INTERNO PARA O 1� ANDAR O EST� ACIONADO
GOTO ESPERA0
INCF 0X29 ; GUARDA STATUS DO BOT�O EXTERNO DO T�RREO






; SUB ROTINA ABERTURA DE PORTA PARA PASSAGEM DE PESSOAS
ABRIR:	BSF OPEN ;SETA BIT3 - RC3 ;ABRI PORTA
BTFSS SOPEN ; SE 1 PORTA ABERTA
GOTO ABRIR ; CONTINUA ABRINDO PORTA
BCF OPEN ;RESETA BIT - RC3 ;ABRI PORTA

;TEMPO DE PORTA ABERTA
MOVLW .10 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP3 ;CARREGA A CONSTANTE COM O VALOR 4 
LOOP3:	MOVLW .100 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP4 ;CARREGA A CONSTANTE COM O VALOR 100	
LOOP4:	MOVLW .250 ;COLOCA UMA LITERAL NO REGISTRADOR W
MOVWF TEMP5 ;CARREGA A CONSTANTE COM O VALOR 250	

LOOP5:	NOP ;GASTA 1us.
DECFSZ TEMP5,F	;DECREMENTA CONSTANTE TEMP5; GASTA 1us.
GOTO LOOP5 ;TEMP1 DIFERENTE DE ZERO, VAI PARA LOOP5 ; GASTA 2us
DECFSZ TEMP4,F ;DECREMENTA CONSTANTE TEMP4; GASTA 1us.
GOTO LOOP4 ;TEMP DIFERENTE DE ZERO, VAI PARA LOOP4 ; GASTA 2us
DECFSZ TEMP3,F ;DECREMENTA CONSTANTE TEMP3; GASTA 1us.
GOTO LOOP3 ;TEMP2 DIFERENTE DE ZERO, VAI PARA LOOP3 ; GASTA 2us
VOL:	BSF CLOSED ;SETA BIT 4 - RC4 ;FECHA PORTA
BTFSS SC	; VERIFICA SE A PORTA FECHOU
GOTO VOL ; VOLTA PARA DOOR
BCF CLOSED ; DESLIGA FECHAMENTO DE PORTA
RETURN

END