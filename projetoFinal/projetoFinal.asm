list p=16f877a

;30 ports
;PortA Display dos andares, ra4 sensor de peso ra5 
;PortB  botões 0-7
;PortC Andares
;PortD sensor dos andares
;
#define Clock 40000;
;
;identificando os port's
;port A

#define BANCO0 BCF STATUS,RP0; SELEÇÃO DE BANCO0
#define	BANCO1 BSF STATUS,RP0; SELEÇÃO DE BANCO1
#define bitC 0x03,0 ; bit C para saber o sentido do elevador(subida\descida)
#define tela0 0x85,0
#define tela1 0x85,1
#define tela2 0x85,2
#define tela3 0x85,3

#define flagEst 0x85,4
#define flagMov 0x85,5

;port B
#define peso 0x86,0
#define btn1 0x86,1
#define btn2 0x86,2
#define btn3 0x86,3
#define btn4 0x86,4
#define btn5 0x86,5
#define btn6 0x86,6
#define btn7 0x86,7

;port C
#define andar0 0x87,0
#define andar1 0x87,1
#define andar2 0x87,2
#define andar3 0x87,3
#define andar4 0x87,4
#define andar5 0x87,5
#define andar6 0x87,6
#define andar7 0x87,7

;port D
#define sensor0 0x88,0
#define sensor1 0x88,1
#define sensor2 0x88,2
#define sensor3 0x88,3
#define sensor4 0x88,4
#define sensor5 0x88,5
#define sensor6 0x88,6
#define sensor7 0x88,7

;port E
#define btn0 0x89,0

;variavel
#define cAndar 0x20
#define cSensor 0x21

org 0x00
goto inicio

org 0x04
;interrupção rb0 por excesso de peso
goto peso

;		display dos andares
goto display

;		verifica se está parado
goto verificaParado
;		verifica se o elevador está subindo ou descendo
goto verificaSentido

display:
		;mostra andar 0
		d0:
		bcf tela0
		bcf tela1
		bcf tela2
		bcf tela3
		return
		
		;mostra andar 1
		d1:
		bsf tela0
		bcf tela1
		bcf tela2
		bcf tela3
		goto andar
		
		;mostra andar 2
		d2:
		bcf tela0
		bsf tela1
		bcf tela2
		bcf tela3
		goto andar
		
		;mostra andar 3
		d3:
		bsf tela0
		bsf tela1
		bcf tela2
		bcf tela3
		goto andar
		
		;mostra andar 4
		d4:
		bcf tela0
		bcf tela1
		bsf tela2
		bcf tela3
		goto andar
		
		;mostra andar 5
		d5:
		bsf tela0
		bcf tela1
		bsf tela2
		bcf tela3
		goto andar
		
		;mostra andar 6
		d6:
		bcf tela0
		bsf tela1
		bsf tela2
		bcf tela3
		goto andar
		
		;mostra andar 7
		d7:
		bsf tela0
		bsf tela1
		bsf tela2
		bcf tela3
		goto andar
		
		;mostra andar E
		dErro:
		bcf tela0
		bsf tela1
		bsf tela2
		bsf tela3
		goto IntErro
		
sensor: ;sensor por andar, envia o andar para o display
		btfsc sensor0
		call d0
		btfsc sensor1
		goto d1
		btfsc sensor2
		goto d2
		btfsc sensor3
		goto d3
		btfsc sensor4
		goto d4
		btfsc sensor5
		goto d5
		btfsc sensor6
		goto d6
		btfsc sensor7
		goto d7
		goto andar
		
andar: ; chama o elevador no andar, testa se está parado
		btfss andar0
		goto andar1
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar1
		goto andar2
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar2
		goto andar3
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar3
		goto andar4
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar4
		goto andar5
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar5
		goto andar6
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar6
		goto andar7
		btfss flagEst
		goto sensor
		goto verificaSentido
		
		btfss andar7
		goto andar
		btfss flagEst
		goto sensor
		goto verificaSentido
		
verificaSentido:		
		
		end