; *********************************************************************************
;   * PROJETO IAC - GRUPO 10 *
;
;   Ist1103335 – Joana Peixinho
;   Ist1103573 – Miguel Fernandes
;   Ist1103543 – Salvador Correia 
;
; *********************************************************************************



; *********************************************************************************
; * Constantes
; *********************************************************************************

; TECLADO

TEC_LIN				    EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				    EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
MASCARA				    EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_0                 EQU 0		; tecla na primeira coluna do teclado (tecla 0)
TECLA_1                 EQU 1		; tecla na segunda coluna do teclado (tecla 1)
TECLA_2                 EQU 2		; tecla na terceira coluna do teclado (tecla 2)
TECLA_4   				EQU 4		; tecla na primeira coluna do teclado (tecla 4)
TECLA_5   				EQU 5		; tecla na segunda coluna do teclado (tecla 5)
TECLA_C					EQU 12		; tecla na primeira coluna do teclado (tecla C)
TECLA_D                 EQU 13      ; tecla na segunda coluna do teclado (tecla D)
TECLA_E                 EQU 14      ; tecla na terceira coluna do teclado (tecla E)
TECLA_NAO_PREMIDA		EQU 16		; tecla não premida (escolhido ser 16 ou 10H)

;SONS/VÍDEOS

SOM_MISSIL      		EQU 0       ; som do míssil
SOM_COMER_MELANCIA      EQU 1		; som de "comer melancia"
SOM_CORTAR_MELANCIA     EQU 2		; som de cortar melancia
SOM_MORTE_ENDERMAN      EQU 3		; som de morte de enderman
VIDEO_DE_COMEÇO         EQU 4		; vídeo da animação de início 
SOM_DE_JOGO             EQU 5		; som do modo de jogo
SOM_DE_PAUSA            EQU 6		; som do modo de pausa
SOM_DE_FIM              EQU 7	    ; som do modo de fim

;DESENHAR

DEFINE_LINHA    		EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H      ; endereço do comando para escrever um pixel

;AUDIO/VÍDEO

APAGA_AVISO     		EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		    EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
APAGA_CENARIO_FRONTAL   EQU  6044H	   ; endereço do comando para apagar cenário frontal
SELECIONA_CENARIO_FUNDO EQU 6042H      ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_CENARIO_FRONTAL EQU 6046H    ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_SOM_VIDEO     EQU 6048H      ; endereço do comando para selecionar um vídeo
TOCA_SOM_VIDEO			EQU 605AH      ; endereço do comando para tocar um som
VIDEO_SOM_LOOP          EQU 605CH      ; endereço do comando para reproduzir som/vídeo em loop
PAUSA_VIDEO_SOM         EQU 605EH      ; endereço do comando para pausar a reprodução de um som/vídeo
CONTINUA_VIDEO_SOM      EQU 6060H      ; endereço do comando para continuar som/vídeo em pausa
PARA_VIDEO_SOM          EQU 6066H      ; endereço do comando para parar som/vídeo em loop
PARA_TODOS_SONS         EQU 6068H      ; endereço do comando para parar todos os sons/vídeos 
SELECIONA_ECRA          EQU 6004H      ; endereço do comando para selecionar o ecrã especificado 
MOSTRA_ECRÃ             EQU 6006H      ; endereço do comando para mostrar o ecrã especificado

;DISPLAY DE ENERGIA

DISPLAYS  				EQU 0A000H     ; endereço dos displays de 7 segmentos (periférico POUT-1)
MAX_ENERGIA             EQU 256		   ; valor em hexadecimal que "mostra" 100 no display
MIN_ENERGIA             EQU 0          ; valor mínimo de energia

;POSIÇÕES

LINHA_STEVE       		EQU  27        ; linha da nave (a meio do ecrã)
COLUNA_STEVE		    EQU  30        ; coluna da nave (fundo do ecrã)

LINHA_METEORO        	EQU  -1         ; linha do inicial do meteoro
COLUNA_METEORO			EQU  24         ; coluna inicial do meteoro 


LINHA_INICIAL_MISSIL	EQU 26		   ; linha inicial do míssil 

MIN_LINHA_MISSIL		EQU	6		   ; máximo de alcance do míssil (linha)
MAX_LINHA               EQU  31		   ; número da linha mais abaixo
MIN_COLUNA		        EQU  0		   ; número da coluna mais à esquerda 
MAX_COLUNA		        EQU  63        ; número da coluna mais à direita 

ATRASO			        EQU	800H	   ; atraso para limitar a velocidade de movimento da nave

;DIMENSÕES

LARGURA_1	            EQU	1			; largura mínima dos desenhos
ALTURA_1		        EQU 1			; Altura mínima dos desenhos

LARGURA_2	            EQU	2			; largura intermédia dos desenhos
ALTURA_2		        EQU 2			; Altura intermédia dos desenhos

LARGURA_3	            EQU	3			; largura média dos desenhos
ALTURA_3		        EQU 3			; Altura média dos desenhos

LARGURA_4	            EQU	4			; largura intermédia dos desenhos
ALTURA_4		        EQU 4			; Altura intermédia dos desenhos

LARGURA_5	            EQU	5			; largura máxima dos desenhos
ALTURA_5		        EQU 5			; Altura mínima dos desenhos

;TIPOS DE DESENHOS

EH_MAU                  EQU 1           ; utilizada para indicar que se trata do desenho de um "meteoro" mau
EH_BOM                  EQU 0           ; utilizada para indicar que se trata do desenho de "meteoro" bom
EH_NORMAL               EQU -1          ; utilizada para indicar que se trata de um desenho sem distinção entre mau e bom

;CORES

VERMELHO	            EQU 0FF00H	    ; cor do pixel: Vermelho em ARGB
VERMELHO_CLARO			EQU 0FF33H	    ; cor do pixel: Vermelho claro em ARGB

VERDE_ESCURO		    EQU	0F3A0H	    ; cor do pixel: Verde Escuro em ARGB
VERDE_CLARO             EQU 0F4B0H		; cor do pixel: Verde Claro em ARGB
VERDE_MAIS_CLARO        EQU 0F9E0H		; cor do pixel: Verde Muito Claro em ARGB

ROSA_ESCURO             EQU 0FC0AH		; cor do pixel: Rosa Escuro em ARGB
ROSA_CLARO              EQU 0FF0CH      ; cor do pixel: Rosa Claro em ARGB

AZUL_ESCURO             EQU 0F05FH	    ; cor do pixel: Azul Escuro em ARGB 

PRETO                   EQU 0F000H		; cor do pixel: Preto em ARGB
BRANCO                  EQU 0FFFFH      ; cor do pixel: Branco em ARGB
CINZENTO                EQU 0F777H		; cor do pixel: Cinzento em ARGB
CINZENTO_CLARO          EQU 07777H		; cor do pixel: Cinzento claro em ARGB
CINZENTO_MENOS_CLARO    EQU 0A777H		; cor do pixel: Cinzento médio em ARGB

CASTANHO 				EQU 0F730H      ; cor do pixel: Castanho em ARGB

OURO                    EQU 0FFC0H		; cor do pixel: Amarelo semelhante a "Ouro" em ARGB
PELE                    EQU 0FFCAH      ; cor do pixel: Cor de Pele em ARGB


; #######################################################################
; * ZONA DE DADOS 
; #######################################################################


PLACE		1000H			

	STACK 100H			

	STACK 100H			    ; espaço reservado para a pilha do processo "main"
SP_inicial_main:		    ; este é o endereço com que o SP deste processo deve ser inicializado
						

	STACK 100H			    ; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:			; este é o endereço com que o SP deste processo deve ser inicializado
							

	STACK 100H					; espaço reservado para a pilha do processo dos meteoros
SP_inicial_relogio_meteoros:	; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H			        ; espaço reservado para a pilha do processo do míssil
SP_inicial_relogio_missil:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK 100H			        ; espaço reservado para a pilha do processo da energia nos displays
SP_inicial_relogio_energia:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H					; espaço reservado para a pilha do processo da tecla 0
SP_inicial_tecla_0:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H					; espaço reservado para a pilha do processo da tecla 1
SP_inicial_tecla_1:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H					; espaço reservado para a pilha do processo da tecla 2
SP_inicial_tecla_2:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H					; espaço reservado para a pilha do processo da tecla C
SP_inicial_tecla_C:				; este é o endereço com que o SP deste processo deve ser inicializado

STACK 100H						; espaço reservado para a pilha do processo da tecla D
SP_inicial_tecla_D:				; este é o endereço com que o SP deste processo deve ser inicializado

STACK 100H						; espaço reservado para a pilha do processo da tecla E
SP_inicial_tecla_E:				; este é o endereço com que o SP deste processo deve ser inicializado

	STACK 100H					; espaço reservado para a pilha do processo das colisões
SP_inicial_colisoes:			; este é o endereço com que o SP deste processo deve ser inicializado


; Tabela das rotinas de interrupção

tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2

evento_int:
	WORD 0			        ; indica se interrupção 0 ocorreu, se estiver a 1 sim se estiver a 0 não
	WORD 0			        ; indica se interrupção 1 ocorreu, se estiver a 1 sim se estiver a 0 não
	WORD 0			        ; indica se interrupção 2 ocorreu, se estiver a 1 sim se estiver a 0 não

VALOR_DISPLAY:	    WORD		100     ; guarda o valor do display que depois é alterado							

TESTA_LINHA:	    WORD		8		; guarda a linha a ser testada no teclado (começa da 4ªlinha)
VALOR_TECLADO:	    WORD		TECLA_NAO_PREMIDA ; guarda o valor premido no teclado (começa não premido)
VALOR_ALEATORIO:	WORD	    0		; valor aleatório lido dos bits 7 a 4 do PIN do teclado
RESTO_AUXILIAR:		WORD		0		; resto que se compara ao resto da divisão do valor aleatório por 4
TECLA_JA_EXECUTADA:	WORD		0		; valor que permite uma tecla executar só uma vez, não importa o tempo que for premida


ESTADO_JOGO:	    WORD	    0	; (0-> MODO DE INÍCIO ; 1->MODO DE JOGO; 2->MODO DE PAUSA; 3-> MODO DE FIM DE JOGO)
	
; guarda o valor a somar ao endereço da tabela dos tamanhos de meteoros 
ESTADO_METEORO:     
	WORD        0	
	WORD		0	
	WORD		0	
	WORD		0	

; guarda o número de movimentos de um meteoro
MOVIMENTO_METEORO:  
	WORD        0   
	WORD		0	
	WORD		0	
	WORD		0	

; tabela que define o desenho do "Steve" (corresponde a nave)
DEF_STEVE:				 
	WORD		LARGURA_5
	WORD 		ALTURA_5
	WORD        EH_NORMAL
	WORD 		CASTANHO, CASTANHO, CASTANHO, CASTANHO, CASTANHO
	WORD        CASTANHO, PELE, PELE, PELE, CASTANHO
	WORD 		BRANCO, AZUL_ESCURO, PELE, AZUL_ESCURO, BRANCO
	WORD 		PELE, PELE, CASTANHO, PELE, PELE
	WORD 		PELE,  CASTANHO, CASTANHO, CASTANHO, PELE

; tabelas que definem os desenhos das "Melancias" (correspondentes aos meteoros bons)
DEF_MELANCIA_1:
	WORD		LARGURA_1
	WORD 		ALTURA_1
	WORD        EH_BOM
	WORD 		CINZENTO_CLARO

DEF_MELANCIA_2:
	WORD		LARGURA_2
	WORD 		ALTURA_2
	WORD        EH_BOM
	WORD 		CINZENTO_MENOS_CLARO, CINZENTO_MENOS_CLARO
	WORD 		CINZENTO_MENOS_CLARO, CINZENTO_MENOS_CLARO

DEF_MELANCIA_3:
	WORD		LARGURA_3
	WORD 		ALTURA_3
	WORD        EH_BOM
	WORD 		0, 0, VERDE_ESCURO
    WORD        0, VERMELHO, VERDE_CLARO
	WORD 		VERDE_ESCURO, VERDE_CLARO, 0

DEF_MELANCIA_4:
	WORD		LARGURA_4
	WORD 		ALTURA_4
	WORD        EH_BOM
	WORD 		0, 0, 0, VERDE_ESCURO
    WORD        0, 0, VERMELHO, VERDE_CLARO
	WORD 		0, VERMELHO, VERMELHO_CLARO, VERDE_MAIS_CLARO
	WORD 		VERDE_ESCURO, VERDE_CLARO, VERDE_MAIS_CLARO, 0

DEF_MELANCIA_5:				
	WORD		LARGURA_5
	WORD 		ALTURA_5
	WORD        EH_BOM
	WORD 		0, 0, 0, 0, VERDE_ESCURO
    WORD        0, 0, 0, VERMELHO, VERDE_ESCURO
	WORD 		0, 0, VERMELHO,VERMELHO_CLARO,VERDE_CLARO
	WORD 		0, VERMELHO, VERMELHO_CLARO, VERMELHO,VERDE_MAIS_CLARO
	WORD	    VERDE_ESCURO, VERDE_ESCURO, VERDE_CLARO, VERDE_MAIS_CLARO,0	

; tabelas que definem os desenho dos "Endermans" (correspondentes aos meteoros maus)
DEF_ENDERMAN_1:
	WORD		LARGURA_1
	WORD 		ALTURA_1
	WORD        EH_MAU
	WORD 		CINZENTO_CLARO

DEF_ENDERMAN_2:
	WORD		LARGURA_2
	WORD 		ALTURA_2
	WORD        EH_MAU
	WORD 		CINZENTO_MENOS_CLARO, CINZENTO_MENOS_CLARO
	WORD 		CINZENTO_MENOS_CLARO, CINZENTO_MENOS_CLARO

DEF_ENDERMAN_3:				 
	WORD		LARGURA_3
	WORD 		ALTURA_3
	WORD        EH_MAU
	WORD 		CINZENTO, PRETO, CINZENTO
	WORD        PRETO, ROSA_ESCURO, PRETO
	WORD 		CINZENTO, PRETO, CINZENTO

DEF_ENDERMAN_4:				 
	WORD		LARGURA_4
	WORD 		ALTURA_4
	WORD        EH_MAU
	WORD 		PRETO, CINZENTO, CINZENTO, PRETO
	WORD        ROSA_CLARO, ROSA_ESCURO, ROSA_ESCURO, ROSA_CLARO
	WORD 		CINZENTO, PRETO, PRETO, CINZENTO
	WORD		PRETO, CINZENTO, CINZENTO, PRETO

DEF_ENDERMAN_5:				 
	WORD		LARGURA_5
	WORD 		ALTURA_5
	WORD        EH_MAU
	WORD 		CINZENTO, PRETO, PRETO, PRETO, CINZENTO
	WORD        PRETO, CINZENTO, PRETO, CINZENTO, PRETO
	WORD 		ROSA_ESCURO, ROSA_CLARO, CINZENTO, ROSA_ESCURO, ROSA_CLARO
	WORD 		CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO
	WORD 		CINZENTO,  PRETO, CINZENTO, PRETO, CINZENTO

;tabela que define o desenho do míssil
DEF_MISSIL:
	WORD		LARGURA_1
	WORD 		ALTURA_1
	WORD        OURO	

; tabelas que definem os desenhos das exploões

DEF_EXPLOSAO_MELANCIA:
	WORD		LARGURA_5
	WORD 		ALTURA_5
	WORD        EH_NORMAL
	WORD        VERDE_CLARO,0,0,VERDE_CLARO,VERDE_CLARO
	WORD        0, VERMELHO_CLARO,VERMELHO, VERMELHO, VERDE_CLARO
	WORD        0, VERMELHO,VERMELHO_CLARO,VERMELHO,0
	WORD        VERDE_CLARO,VERMELHO,VERMELHO,VERMELHO_CLARO,0
	WORD        VERDE_CLARO,VERDE_CLARO,0,0,VERDE_CLARO
       
DEF_EXPLOSAO_ENDERMAN:
	WORD		LARGURA_5
	WORD 		ALTURA_5
	WORD        EH_NORMAL
	WORD        PRETO,0,0,PRETO,PRETO
	WORD        0, ROSA_CLARO,ROSA_ESCURO, ROSA_ESCURO, PRETO
	WORD        0, ROSA_ESCURO,ROSA_CLARO,ROSA_ESCURO,0
	WORD        PRETO,ROSA_ESCURO,ROSA_ESCURO,ROSA_CLARO,0
	WORD        PRETO,PRETO,0,0,PRETO

;tabelas com os meteoros nas suas diferentes fases
TAMANHOS_METEOROS_BONS:
	WORD	DEF_MELANCIA_1	
	WORD	DEF_MELANCIA_2	
	WORD	DEF_MELANCIA_3	
	WORD	DEF_MELANCIA_4	
	WORD	DEF_MELANCIA_5	

TAMANHOS_METEOROS_MAUS:
	WORD	DEF_ENDERMAN_1	
	WORD	DEF_ENDERMAN_2	
	WORD	DEF_ENDERMAN_3	
	WORD	DEF_ENDERMAN_4
	WORD	DEF_ENDERMAN_5

;tabela com os desenhos das explosões	
TABELA_EXPLOSOES:
	WORD	DEF_EXPLOSAO_MELANCIA	
	WORD	DEF_EXPLOSAO_ENDERMAN	

;POSICOES DOS DESENHOS
 
POSICAO_STEVE:				; tabela de posição do Steve
	WORD	COLUNA_STEVE	
	WORD	LINHA_STEVE

POSICAO_METEORO_1:			; tabela de posição do Meteoro 1
	WORD	COLUNA_METEORO
	WORD	LINHA_METEORO
POSICAO_METEORO_2:			; tabela de posição do Meteoro 2 (POSICAO_METEORO_1 + 4)
	WORD	COLUNA_METEORO
	WORD	LINHA_METEORO
POSICAO_METEORO_3:			; tabela de posição do Meteoro 3 (POSICAO_METEORO_2 + 4)
	WORD	COLUNA_METEORO
	WORD	LINHA_METEORO
POSICAO_METEORO_4:			; tabela de posição do Meteoro 4 (POSICAO_METEORO_3 + 4)
	WORD	COLUNA_METEORO
	WORD	LINHA_METEORO

ENDEREÇOS_ALVO:				; guarda o endereço da tabela e posição do boneco alvo (para apagar ou para desenhar)
	WORD	DEF_STEVE		; endereço da tabela do boneco alvo
	WORD	POSICAO_STEVE	; endereço da posição do boneco alvo

POSICAO_MISSIL:				; quando as coordenadas estão a 0, não existe míssil
	WORD	0				; nº da coluna do míssil
	WORD	0				; nº da linha do míssil


; *********************************************************************************
; * Código 
; *********************************************************************************

PLACE   0                     

inicio:
    MOV  SP, SP_inicial_main ; inicializa SP 
							
	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)

    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado 
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados 
	MOV  R2, 0
	MOV  [ESTADO_JOGO], R2	   ; seleciona o modo de jogo (modo de início)
	MOV  R1, VIDEO_DE_COMEÇO
	MOV  [VIDEO_SOM_LOOP], R1  ; inicia a reprodução do vídeo de começo
	MOV  R3, MAX_ENERGIA
	MOV  [DISPLAYS], R3        ; inicializa o Display a 100
	
	
	EI0					; permite interrupções 0
	EI1					; permite interrupções 1
	EI2					; permite interrupções 2
	EI					; permite interrupções (geral)
						; a partir daqui, qualquer interrupção que ocorra usa
						; a pilha do processo que estiver a correr nessa altura

	;processo do teclado
	CALL	teclado					; cria o processo teclado
	
	;processos do modo de jogo
	CALL	subir_missil			; cria o processo subir_missil
	CALL    loop_decrescimo_energia	; cria o processo loop_decrescimo_energia
	CALL	desce_meteoro			; cria o processo desce_meteoro
	CALL    testa_colisao			; cria o processo testa_colisao
	
	;processos das teclas
	CALL	trata_tecla_0			; cria o processo trata_tecla_0
	CALL	trata_tecla_1			; cria o processo trata_tecla_1
	CALL	trata_tecla_2			; cria o processo trata_tecla_2
    CALL    loop_tecla_c			; cria o processo loop_tecla_c
	CALL    trata_tecla_d			; cria o processo loop_tecla_d
	CALL    loop_tecla_e            ; cria o processo loop_tecla_e


loop_main:
	
	YIELD
	EI					; permite interrupções
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1			; verifica se o jogo está em modo de jogo
	
	JZ loop_main		; se sim, está em andamento e permite as interrupções
	DI					; não permite interrupções
	JMP loop_main

; **********************************************************************
; 
;  MOSTRA_STEVE: Desenha o Steve (correspondente à nave) no ecrã
;
; **********************************************************************
mostra_Steve:
	PUSH R0
	PUSH R1

	MOV R0,0
	MOV [SELECIONA_ECRA], R0
	MOV R0, ENDEREÇOS_ALVO	; guarda o endereço do boneco alvo
	MOV R1, DEF_STEVE
	MOV	[R0], R1	; guarda o endereço tabela da nave
	MOV R1, POSICAO_STEVE
	MOV	[R0+2], R1	; guarda o endereço da tabela posição da nave
	CALL	desenha_boneco ; desenha a nave a partir da tabela
	POP R1
	POP R0
	RET

; **********************************************************************
; COLOCA_TOPO_ALEATORIO: Escolhe o tipo de meteoro e a coluna 
; em que nasce, aleatoriamente.
;
; **********************************************************************

coloca_topo_aleatorio:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH 	R5
	PUSH	R6

	MOV		R4, POSICAO_METEORO_1   ; guarda o endereço da tabela de posição do "meteoro" 1
	MOV		R3, R1					; guarda cópia do endereço de posição do "meteoro" a mover
	SUB		R3, R4					; guarda a diferença dos endereços de posição anteriores
	MOV		R4, 2                   
	DIV		R3, R4                  ; calcula a diferença de endereços entre os estados do meteoro a mover e o primeiro
	MOV		R4, ESTADO_METEORO		; guarda o endereço da tabela de estados meteoro
	MOV		R5, MOVIMENTO_METEORO	; guarda o endereço da tabela do movimento de meteoro
	ADD		R4, R3					; calcula o endereço do estado do meteoro a mover	
	ADD		R5, R3					; calcula o endereço do movimento do meteoro a mover	


	MOV		R3, 0
	MOV		[R1+2], R3	         		 ; reinicia o desenho para o topo do ecrã 

	MOV		R2, [VALOR_ALEATORIO]		 ; guarda o nºaleatório recolhido do teclado (entre 0 e 15)
	MOV		R3, R2						 ; guarda cópia do nºaleatório
	MOV		R6, 4
	MOD		R3, R6						 ; calcula o resto da divisão do nº aleatório por 4
	MOV		R6, [RESTO_AUXILIAR]		 ; guarda resto a testar (0 ou 3)
	
	CMP		R3, R6						 ; verifica se o resto da divisão por 4 é 0 ou 3
	JNZ 	meteoro_mau					 ; se sim, é "meteoro" mau (Enderman)
	MOV 	R3, 0						 ; guarda valor de estado de meteoro bom
	JMP		escolhe_tipo_linha
meteoro_mau:
	MOV		R3, 10						 ; guarda valor de estado de meteoro mau


escolhe_tipo_linha:
	MOV		[R4], R3		 			 ; guarda o estado inicial correto no endereço calculado (0 se for bom, 10 se for mau)
	MOV		R3, 8						 

;cálculo aleatório da coluna de começo
	SHR 	R2, 1						 ; ignora o primeiro bit (nºaleatório de 0 a 7)
	MUL		R3, R2						 
	ADD		R3, 1						 
	
	MOV		[R1], R3					 ; guarda o valor da coluna de começo do meteoro calculada
	MOV		R3, 0
	MOV		[R5], R3		             ; reinicia o movimento a 0 (no endereço de movimento calculado) 
	
	CMP R6, 0                            ; verifica se o resto usado é 0
	JZ poe_resto_3						 ; se sim, coloca a 3
	MOV R6, 0                            ; se não, coloca a 0
	JMP fim_coloca_topo

poe_resto_3:
	MOV R6, 3

fim_coloca_topo:
	MOV [RESTO_AUXILIAR], R6	; guarda o novo resto
	POP		R6
	POP 	R5
	POP		R4
	POP	    R3
	POP	    R2
	POP	    R1
	RET



; **********************************************************************
; TESTA_LIMITES_BAIXO - Testa se o meteoro chegou aos limites do ecrã e nesse caso
;			      reinicia o movimento.
;
; **********************************************************************
testa_limite_baixo:
	PUSH R1
	PUSH R5

	MOV     R1, MAX_LINHA 	             ; limite inferior do ecrã		
	MOV		R5, [R2+2]		             ; obter o valor da linha do meteoro 

	CMP     R5, R1                       ; verifica se ultrapassou a última linha
	JLE		fim_testa_limite_baixo       

;última linha ultrapassada:
	MOV		R1, R2						 ; guarda o endereço da posição do meteoro para ser colocado no topo
	CALL coloca_topo_aleatorio			 
	

fim_testa_limite_baixo:
	POP R5
	POP R1
	RET

; **********************************************************************
; TESTA_COLISAO - Testa se um "meteoro" colidiu com o míssil ou com o
;                boneco Steve (nave). 
;
; **********************************************************************
PROCESS SP_inicial_colisoes

testa_colisao:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1                             ; verifica se o jogo está em modo de jogo
	JNZ testa_colisao

	MOV		R2, POSICAO_METEORO_1         ; obtém o endereço da posição do "meteoro" 1
	MOV 	R4, ESTADO_METEORO			  ; guarda o endereço do estado do "meteoro" 1
	SUB		R2, 4                         
	SUB 	R4, 2
	MOV		R10, -1						

loop_testa_colisao:
	YIELD
	ADD		R2, 4						; incrementa o endereço da posição do meteoro
	ADD		R4, 2						; incrementa o endereço do estado do meteoro
	ADD		R10, 1						; incrementa o nº do cenário a selecionar 
	CMP		R10, 4						; verifica se o nº máximo de cenários foi ultrapassado
	JZ		testa_colisao	

	MOV	[SELECIONA_ECRA], R10			; seleciona o ecrã correspondente

	MOV     R11, 0						; reinicia o indicador de colisão a 0

	MOV     R0, [R4]		            ; guarda o valor do estado do meteoro
	MOV     R1, TAMANHOS_METEOROS_BONS	; guarda a o endereço da tabela de endereços dos desenhos de "meteoro"
	ADD     R1, R0                     	; guarda o endereço da tabela do tamanho de "meteoro" pretendido
	MOV		R3, [R1]					; guarda o endereço do desenho do "meteoro" pretendido
	MOV 	R5, [R3+4]					; guarda o tipo de "meteoro" (0-bom ou 1-mau)

	MOV R0, POSICAO_MISSIL				; guarda o endereço da posição do míssil
	MOV R1, DEF_MISSIL					; guarda o endereço do desenho do míssil
	CALL deteta_colisao					; verifica se houve colisão do "meteoro" com o míssil
	CMP R11, 1							; se for 1, houve colisão
	JZ trata_colisao_missil

;não há colisão com missil:
	MOV R0, POSICAO_STEVE				; guarda o endereço da posição do Steve
	MOV R1, DEF_STEVE					; guarda o endereço do desenho do Steve
	CALL deteta_colisao					; verifica se houve colisão do "meteoro" com o Steve
	CMP R11, 1							; se for 1, houve colisão
	JZ trata_colisao_Steve

	JMP loop_testa_colisao				; se não houve nenhuma colisão, volta ao início
	

trata_colisao_missil:
	MOV	R9, ENDEREÇOS_ALVO              ; guarda o endereço do Alvo 
	MOV [R9], R3						; guarda o endereço do desenho do meteoro no Alvo
	MOV [R9+2], R2						; guarda o endereço da posição do meteoro no Alvo
	CALL apaga_boneco					
	
	MOV R3, 0
	MOV	[SELECIONA_ECRA], R3			

	MOV		[R9], R1					; guarda a DEF do míssil no Alvo
	MOV		[R9+2], R0					; guarda a posição do míssil no alvo
	CALL apaga_boneco					; apaga o míssil
	MOV R1, 0
	MOV [R0], R1						; guarda 0 na coluna do míssil
	MOV [R0+2], R1						; guarda 0 na linha do míssil


	MOV R6, SOM_CORTAR_MELANCIA			;  <----SOM DE "MORTE" DA MELANCIA AQUI
	MOV R8, TABELA_EXPLOSOES			; guarda a tabela de explosoes
	CMP R5, 1							; verifica se é "meteoro" mau
	JNZ colisao_missil				; se for 1, é mau
	MOV 	R7, [VALOR_DISPLAY]		 	; guarda o valor atual de energia no display 
	ADD     R7, 5                       ; aumenta 5 o valor atual de energia
	MOV 	[VALOR_DISPLAY], R7			; atualiza o endereço que guarda o valor a ser mostrado no display
	CALL calcula_display
	MOV 	R6, SOM_MORTE_ENDERMAN  ; <----SOM DE MORTE DE ENDERMAN AQUI
	ADD		R8, 2
colisao_missil:
	MOV 	[TOCA_SOM_VIDEO], R6
	MOV		R8, [R8]					; guarda DEF de "explosão"
	MOV		[R9], R8					; guarda DEF de "explosão" no Alvo
	MOV		[R9+2], R2					; guarda posição do meteoro no Alvo
	CALL desenha_boneco					; desenha a explosão
	MOV R0, 60							; nº de loops que mostra a explosão
loop_explosao:
	CALL atraso
	SUB R0, 1
	JNZ loop_explosao			

	CALL apaga_boneco					; apaga a explosão
	MOV		R1, R2						; guarda a posição do meteoro para ser colocado no topo
	CALL coloca_topo_aleatorio
	JMP loop_testa_colisao


trata_colisao_Steve:
	CMP R5, 1							; verifica se é "meteoro" mau
	JZ Steve_X_mau
	MOV 	R6,SOM_COMER_MELANCIA       ; som número 1 (som de ganhar energia/ "comer a melancia")
	MOV 	[TOCA_SOM_VIDEO], R6
	MOV 	R7, [VALOR_DISPLAY]		 	; guarda o valor atual de energia no display 
	MOV     R8, 10
	ADD 	R7, R8					 	; aumenta 10 ao valor atual de energia
	MOV 	[VALOR_DISPLAY], R7			; atualiza o endereço que guarda o valor a ser mostrado no display
	CALL calcula_display

	MOV R0, ENDEREÇOS_ALVO
	MOV [R0], R3						; guarda a tabela do meteoro no endereço alvo
	MOV [R0+2], R2						; guarda a posição do meteoro no endereço alvo
	CALL apaga_boneco

	CALL mostra_Steve
	MOV		R1, R2						 ; guarda o endereço da posição do meteoro para ser colocado no topo
	CALL coloca_topo_aleatorio			 
	JMP loop_testa_colisao

; colisão do Enderman (meteoro mau) com o Steve (nave)
Steve_X_mau:
	MOV     R0, 3
	MOV		[ESTADO_JOGO], R0  					; seleciona o modo de fim de jogo
	MOV  	[APAGA_ECRÃ], R0					; apaga todos os pixels desenhados no ecrã	
	MOV     [PARA_TODOS_SONS], R0				; para a reprodução do som de todos os sons
	MOV     R0, 2
	MOV     [SELECIONA_CENARIO_FRONTAL], R0	    ; seleciona o cenário de morte
    MOV     R0, SOM_DE_FIM
	MOV     [VIDEO_SOM_LOOP], R0				; inicia a reprodução da música de fim de jogo    
	
	JMP loop_testa_colisao

; **********************************************************************
; DETETA_COLISAO: deteta uma colisão com um objeto.
;
; Argumentos:   R0 - posição do objeto a detetar a colisão
;				R1 - tabela do objeto a detetar colisão
; 				R2 - posição do meteoro
;				R3- tabela do tamanho de meteoro pretendido
;				R4, R5, R6- Variáveis temporárias
;
; Retorna: 		R11 - 0 se não houve colisão, 1 se sim
; **********************************************************************
deteta_colisao:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	MOV     R11, 0

;testa se o objeto está abaixo do meteoro (não havendo colisão)
	MOV R4, [R0+2]			; guarda a linha do Objeto
	MOV	R5, [R2+2]			; guarda a linha do "meteoro"
	MOV R6, [R3+2]			; guarda a altura do "meteoro"
	ADD R5, R6				; guarda a linha diretamente abaixo do "meteoro"
	CMP R4, R5				; verifica se a linha diretamente abaixo do "meteoro" é menor ou igual á linha do objeto
	JGE fim_deteta_colisao	; se sim, não há colisão

;testa se o objeto está acima do meteoro (não havendo colisão)
	SUB R5, R6				; guarda, de novo, a linha do "meteoro"
	MOV R6, [R1+2]			; guarda a altura do Objeto
	ADD R4, R6				; guarda o nº da linha diretamente abaixo do Objeto
	CMP R5, R4				; verifica se o nºlinha do "meteoro" é >= á linha diretamente abaixo do Objeto
	JGE fim_deteta_colisao	; se sim, não há colisão

;testa se o objeto está á direta do meteoro (não havendo colisão)
	MOV R4, [R0]			; guarda a coluna do Objeto
	MOV	R5, [R2]			; guarda a coluna do "meteoro"
	MOV R6, [R3]			; guarda a largura do "meteoro"
	ADD R5, R6				; guarda o nº da coluna diretamente á direita do meteoro
	CMP R4, R5				; verifica se o nºcoluna do Objeto é >= á coluna diretamente á direita do meteoro
	JGE fim_deteta_colisao  ; se sim, não há colisão

;testa se o objeto está á esquerda do meteoro (não havendo colisão)
	SUB R5, R6				; guarda, de novo, a coluna do "meteoro"
	MOV R6, [R1]			; guarda a largura do Objeto
	ADD R4, R6				; guarda o nº da coluna diretamente á direita do Objeto
	CMP R5, R4				; verifica se o nºcoluna do "meteoro" é >= á coluna diretamente á direita do Objeto
	JGE fim_deteta_colisao	; se sim, não há colisão
	MOV R11, 1				; guarda 1 em R11, indicando que houce colisão
	

fim_deteta_colisao:
	POP	R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP	R1
	POP R0
	RET

; **********************************************************************
; CALCULA_DISPLAY - Tranforma um valor em hexadecimal num valor que é 
;					lido corretamente como decimal no display
; Argumentos:   R0 - valor original em hexadecimal
;               R1 - valor das unidades
;               R2 - valor das dezenas
;				R4 - 2º operando nos cálculos
;				R5 - variável auxiliar (no fim, fica o valor das centenas)
;
; Retorna: 		R6 - valor do display adaptado
; **********************************************************************
calcula_display:
	PUSH	R0
	PUSH    R1
	PUSH	R2
	PUSH	R4
	PUSH	R5
	PUSH    R9
; inicializações:
	MOV R0, [VALOR_DISPLAY] ; guarda o valor do display
	MOV R9, 100
	CMP R0, R9
	JGE  display_maximo
	MOV R1, 0		; inicializa as unidades e as dezenas a 0
	MOV R2, 0
	MOV R4, 10		; 10 usado para a multiplicação, divisão inteira e resto da divisão
	MOV R6, 0		; valor do display adaptado começa a 0
; display_unidades:
	MOV R5, R0		; guarda o valor original na variavel auxiliar
	MOD R5, R4		; calcula o resto da divisão do valor original por 10
	MOV R1, R5		; guarda o resto no registo das unidades
; display_dezenas:
	SUB R0, R5		; valor original - resto da divisão por 10
	DIV R0, R4		; valor atual a dividir por 10
	MOV R5, R0		; guarda o valor atual na variavel auxiliar
	MOD R5, R4		; resto da divisão do valor atual por 10
	MOV R2, R5		; guarda o resto no registo das dezenas
; display_centenas:
	SUB R0, R5		; valor atual - resto da divisão por 10
	DIV R0, R4		; valor atual a dividir por 10
	MOV	R5, R0		; guarda o valor atual na variavel auxiliar
	MOD	R5, R4		; resto da divisão do valor atual por 10

	SHL R2, 4		; move o valor das das dezenas para os digitos 7-4 (em binário)
	SHL R5, 8		; move o valor das centenas para os digitos 11-8 (em binário)
	ADD R6, R1		; soma as unidades ao valor final
	ADD R6, R2		; soma as dezenas ao valor final
	ADD R6, R5		; soma as centenas ao valor final

fim_calcula_display:	
	MOV [DISPLAYS], R6 ; guarda o novo valor do display
	POP     R9
	POP		R5
	POP		R4
	POP		R2
    POP 	R1
	POP		R0
	RET

display_maximo:
	MOV R6, MAX_ENERGIA
	JMP fim_calcula_display

; **********************************************************************
; Desenha_boneco - Recebe o endereço da tabela do desenho do boneco e da 
;                sua posição.
;                Desenha o desenho com a definição recebida na posição 
;                correspondente.
; **********************************************************************
desenha_boneco:
	PUSH	R0
    PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
    PUSH    R7
	PUSH	R8
	PUSH	R9

	CALL delimita_boneco	

	MOV	R0, MAX_LINHA
	MOV	R9, R1          ; guarda a linha onde começar o desenho
	ADD R9, R7          ; calcula linha diretamente abaixo do desenho
	SUB	R9, R0          
	SUB R9, 1			; calcula o nº de linhas que excedem o limite do ecrã
	JLE desenha_pixels  ; se for menor ou igual a 0, não excede o limite
	SUB	R7, R9          ; subtrai ao valor da altura o nº de linhas que excedem o ecrã


desenha_pixels:       	; desenha os pixels do desenho a partir da tabela
	MOV	R3, [R4]		; obtém a cor do próximo pixel do desenho
	CALL escreve_pixel	
	ADD	 R4, 2			; endereço da cor do próximo pixel 
    ADD  R2, 1          ; próxima coluna
    SUB  R5, 1			; menos uma coluna para tratar
    JNZ  desenha_pixels ; continua até percorrer toda a largura do objeto
	MOV R5, R8			; reinicia o R5 com o valor da largura original
    ADD R1, 1			; desce uma linha
    SUB R2, R8          ; volta a coluna original
    SUB R7, 1			; reduz o valor de linhas que faltam pintar
	JNZ  desenha_pixels	; recomeça se ainda faltarem linhas por pintar

	POP		R9
	POP		R8
	POP 	R7
    POP     R5
	POP	    R4
	POP	    R3
	POP	    R2
	POP    	R1
	POP		R0
	RET

; **********************************************************************
; Apaga_boneco - Recebe o endereço da tabela do desenho do boneco e da 
;                sua posição.
;                Apaga o desenho com a definição recebida na posição 
;                correspondente.
; **********************************************************************
apaga_boneco:
    PUSH    R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
    PUSH    R7
	PUSH	R8

	CALL delimita_boneco	
	MOV	R3, 0			    ; cor para apagar o próximo pixel do desenho

apaga_pixels:       		; apaga os pixels do boneco a partir da tabela
	CALL escreve_pixel	    
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1			    ; menos uma coluna para tratar
    JNZ  apaga_pixels       ; continua até percorrer toda a largura do desenho
	MOV R5, R8			    ; reinicia o R5 com o valor da largura original
	ADD R1, 1			    ; desce uma linha
	SUB R2, R8              ; volta a coluna original
    SUB R7, 1			    ; reduz o valor de linhas que faltam pintar
	JNZ  apaga_pixels	    ; recomeça se ainda faltarem linhas por pintar

	POP		R8
	POP 	R7
    POP     R5
	POP	    R4
	POP	    R3
	POP	    R2
	POP    	R1
	RET

; **********************************************************************
; DELIMITA_BONECO - Guarda as coordenadas do desenho, as dimensões e o 
;					endereço da cor do 1º pixel do desenho.
; **********************************************************************

delimita_boneco:

	MOV R5, ENDEREÇOS_ALVO	; guarda endereço do Alvo
	MOV R4, [R5]			; guarda o endereço da tabela do desenho
	MOV R5, [R5+2]			; guarda o endereço tabela da posicao do desenho

;guardar as coordenadas 
	MOV R2, [R5]			; guarda no R2 a coluna onde começar o desenho 
	MOV R1, [R5+2]			; guarda no R1 a linha onde começar o desenho
	
;guarda as dimensões	
	MOV	R5, [R4]		    ; obtém a largura do desenho
	MOV R8, R5			    ; guarda o valor da largura numa auxiliar
	ADD R4, 2			    ; endereço da altura 
	MOV	R7, [R4]		    ; obtém a altura do desenho

;guarda a cor do 1º píxel	
	ADD	R4, 4		        ; endereço da cor do 1º pixel 

	RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um píxel na linha e coluna indicadas.
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA],  R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL],  R3	; altera a cor do pixel na linha e coluna já selecionadas
	RET


; **********************************************************************
; ATRASO - Executa um ciclo para implementar um atraso no movimento do
;          Steve (nave).
;
; **********************************************************************
atraso:
	PUSH R11
	MOV  R11, ATRASO     ; guarda o valor do atraso 

;executa o ciclo o número de vezes correspondente ao valor do atraso

ciclo_atraso:			
	SUB	R11, 1			; diminui o contador 
	JNZ	ciclo_atraso	; repete enquanto o contador é diferente de 0
	POP R11
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se a nave chegou aos limites do ecrã e nesse caso
;			      impede o movimento (força R7 a 0)
;
; Argumentos:	R2 - coluna em que a nave está
;			    R6 - largura da nave
;
; Retorna: 	R2 - posição correta da coluna da nave, de acordo com os limites
; **********************************************************************

testa_limites:
	PUSH R2
	PUSH R5
	PUSH R6
	MOV  R2, [POSICAO_STEVE]	; guarda a coluna atual do Steve
	MOV  R6, [DEF_STEVE]		; guarda a largura do Steve

 ; verificar se o Steve (nave) chegou ao limite esquerdo
testa_limite_esquerdo:		
	MOV	R5, MIN_COLUNA		 ; guarda o valor mínimo da coluna
	CMP	R2, R5				 ; verifica se o limite esquerdo foi atingido
	JGE	testa_limite_direito ; se o limite esquerdo não foi atingido, verifica o direito
	ADD	R2, 1			     ; impede o movimento caso o limite esquerdo tenha sido atingido
	JMP	sai_testa_limites

; verificar se o Steve (nave) chegou ao limite direito	
testa_limite_direito:		 
	ADD	R6, R2			     ; posição a seguir ao extremo direito da nave
	SUB R6, 1                ; obtém a posição do extremo direito da nave
	MOV	R5, MAX_COLUNA		 ; guarda o valor máximo da coluna
	CMP	R6, R5				 ; verifica se o limite direito foi atingido 
	JLE	sai_testa_limites	 ; se o limite direito não foi atingido não afeta a posição da nave
	SUB R2,1			     ; impede o movimento caso o limite direito tenha sido atingido	

sai_testa_limites:	
	MOV [POSICAO_STEVE], R2	 ; guarda a linha do Steve na memória
	POP	R6
	POP	R5
	POP R2
	RET


; **********************************************************************
; PROCESSO TECLADO - Faz leitura às teclas de uma linha do teclado e 
;                    atualiza a WORD no endereço VALOR_TECLADO, com a 
;                    tecla lida e o VALOR_ALEATORIO, com os bits 
;					 aleatorios da leitura do teclado.
; **********************************************************************
PROCESS SP_inicial_teclado	
						
teclado:  
	MOV  R2, TEC_LIN             ; endereço do periférico das linhas
	MOV  R3, TEC_COL             ; endereço do periférico das colunas
	MOV  R5, MASCARA             ; isola os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:			         ; neste ciclo espera-se até não haver nenhuma tecla premida
	YIELD				 	     ; ter um ponto de fuga que perimita comutar para outro processo
	MOV R6, [TESTA_LINHA]	     ; guarda linha a testar no teclado
	ROL R6, 1                    ; muda a linha a testar
	MOV	[TESTA_LINHA], R6	     ; guarda a linha do Teclado que vai ser testada
	MOV R0, 8					 ; guarda valor da 4ª linha
	CMP	R6, R0				     ; verifica se já passou do valor da 4ª linha
	JLE	continua_teclado   
	MOV	R6, 1				     ; se passou da 4ªlinha, põe na 1ªlinha
continua_teclado:
	MOVB [R2], R6                ; escreve no periférico de saída (linhas), escolhendo assim, qual a linha da qual testa o input
	MOVB R0, [R3]                ; ler do periférico de entrada (colunas)
	
;guarda valor aleatório
	MOV R8, R0					 ; guarda cópia do valor do periférico de entrada
	SHR R8, 4					 ; fica com os bits 7-4 do valor
	MOV [VALOR_ALEATORIO], R8	 ; guarda o valor aletório

;verifica se houve tecla pressionada
	AND  R0, R5                  ; elimina bits para além dos bits 0-3
	CMP R0, 0                    ; Não detetou input? (é zero?)
	JZ tecla_nao_pressionada     ; caso o valor das colunas dê 0, salta o cálculo da tecla e retorna 0
	
	MOV R7, 0                    ; inicializa o contador do valor da tecla a 0
	MOV [TECLA_JA_EXECUTADA], R7 ; guarda 0 para indicar que a tecla ainda não executou a sua instrução

;conta o "indice" em que o "1" estava: 0000 0100-> 2
conta_linha:                     
    SHR R6, 1                    ; move o "1" para a direita
	JZ conta_coluna              ; quando o nº linhas já foi contado, vai contar o nº da coluna
    ADD R7, 1                    ; aumenta o nº da linha
    JMP conta_linha              

;conta o "indice" em que o "1" estava: 0000 1000-> 3
conta_coluna:                    
    SHR R0, 1                    ; move o "1" para a direita
    JZ calcula_tecla             ; quando o nº colunas ja foi contado, sai
    ADD R6, 1                    ; aumenta o nº da coluna
    JMP conta_coluna       

;calcula: nºlinha * 4 + nºcoluna= nºtecla (0H a FH) 	      
calcula_tecla:                   
    SHL R7, 2                    ; multiplica o nº da linha por 4
    ADD R7, R6                   ; adiciona o valor da coluna ao valor da tecla
	MOV R0, R7                   ; guarda o valor do teclado calculado (0H a FH)


	MOV	[VALOR_TECLADO], R0		 ; guarda o valor da tecla premida
	MOV R6, [TESTA_LINHA]		 ; obtém a linha da tecla que acabou de ser premida 

ha_tecla:				; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD				; este ciclo é potencialmente bloqueante, por isso tem ponto de fuga (YIELD)
	MOVB [R2], R6                ; escreve no periférico de saída (linhas), escolhendo assim, qual a linha da qual testa o input
	MOVB R0, [R3]                ; ler do periférico de entrada (colunas)

;guarda valor aleatório
	MOV R8, R0					 ; guarda cópia do valor do periférico de entrada
	SHR R8, 4					 ; fica com os bits 7-4 do valor
	MOV [VALOR_ALEATORIO], R8	 ; guarda o valor aletório

;verifica se a tecla já parou de ser pressionada
	AND  R0, R5                  ; elimina bits para além dos bits 0-3
	CMP R0, 0                    ; verifica se existe uma tecla premida
	JNZ	ha_tecla		         ; se ainda houver uma tecla premida, espera até não haver

	JMP	espera_tecla

; quando nenhuma tecla foi pressionada
tecla_nao_pressionada:           
	MOV R0, TECLA_NAO_PREMIDA	 
	MOV [VALOR_TECLADO], R0		 ; guarda o valor do teclado na memória (tecla não premida)	
	JMP espera_tecla


; **********************************************************************
; PROCESSO Desce Meteoro - Move o meteoro um pixel para baixo (executa de 3 
;                         em 3 segundos)
; 
; **********************************************************************
PROCESS	SP_inicial_relogio_meteoros

desce_meteoro:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1               ; verifica se está em modo de jogo
	JNZ desce_meteoro
	MOV R0, [evento_int]	; guarda o valor que indica se ocorreu a interrução 0
	CMP R0, 1				; verifica que o valor é 1 (se for 1 ocorreu uma interrupção)
	JNZ desce_meteoro		; se o valor não for 1, volta ao início do loop
	

	MOV R2, POSICAO_METEORO_1	    ; guarda endereço da posição do "meteoro" a mover
	MOV R9, ESTADO_METEORO			; guarda o endereço do estado do "meteoro", que indica a DEF de desenho
	MOV R7, MOVIMENTO_METEORO		; guarda o endereço do movimento do "meteoro"
	MOV	R10, -1						; guarda o ecrã onde é pra desenhar
	SUB	R2, 4
	SUB R9, 2
	SUB R7, 2
loop_desce_meteoro:
	ADD	R2, 4						; incrementa o endereço da posição do meteoro
	ADD R9, 2						; incrementa o endereço do estado do meteoro
	ADD R7, 2                       ; incrementa o endereço do movimento do meteoro
	ADD	R10, 1                      ; incrementa o nº do cenário a selecionar 
	CMP R10, 4                      ; verifica se o nº máximo de cenários foi ultrapassado       
	JZ	desce_meteoro

	MOV	[SELECIONA_ECRA], R10
	
	MOV R3, ENDEREÇOS_ALVO		     ; guarda o endereço do Alvo

; guarda endereço de desenho do "meteoro"
	MOV R1, TAMANHOS_METEOROS_BONS   ; guarda o endereço da tabela de desenhos dos "meteoros"
	MOV R5, [R9]                     ; guarda o valor a somar ao endereço da tabela dos "meteoros" para obter o endereço de desenho pretendido
	ADD R1, R5                       ; guarda o endereço da tabela de desenhos do "meteoro" pretendido

; apaga "meteoro"
	MOV R0, [R1]			; guarda o endereço da tabela de desenho do "meteoro" a ser apagado
	MOV [R3], R0			; guarda o endereço da tabela de desenho do "meteoro" a ser apagado no Alvo
	MOV [R3+2], R2			; guarda o endereço da tabela da posição do "meteoro" a ser apagado no Alvo
	CALL apaga_boneco		; apaga boneco no Alvo

; desce o meteoro
	MOV R4, [R2+2]			; guarda o valor da linha do "meteoro"
	ADD R4, 1				; move o "meteoro" 1 pixel para baixo
	MOV [R2+2], R4			; guarda o valor da linha do "meteoro" na memória
	
	CALL testa_limite_baixo	         ; assegura que o "meteoro" não sai do ecrã

; guarda endereço de desenho do "meteoro"
	MOV R1, TAMANHOS_METEOROS_BONS   ; guarda o endereço da tabela de desenhos dos "meteoros"
	MOV R5, [R9]        			 ; guarda o valor a somar a tabela dos "meteoros" para obter o endereço da tabela de desenho pretendido
	ADD R1, R5						 ; guarda o endereço da tabela de desenhos do "meteoro" pretendido
	
; estado máximo do "meteoro" bom
	MOV R4, 8
	CMP R5, R4						; verifica se o [ESTADO_METEORO] é igual 8 (tamanho máximo do "meteoro" bom)
	JZ fim_desce_meteoro			; se for 8 não muda a definição
	
; estado máximo do "meteoro" mau	
	MOV R4, 18
	CMP R5, R4						; verifica se o [ESTADO_METEORO] é igual 20 (tamanho máximo do "meteoro" mau)
	JZ fim_desce_meteoro			; se for 20 não muda a definição

; a cada 3º movimento, aumentar tamanho do "meteoro"
	MOV R6, [R7]					; guarda o contador de movimentos do "meteoro"
	ADD R6, 1						; incrementa o contador de movimentos realizados pelo meteoro
	CMP R6, 3						; verifica se já ocorreram 3 movimentos
	JNZ  fim_desce_meteoro          ; se não, não incrementa o estado do meteoro

	MOV R6, 0						; reinicia o contador de movimentos a 0
	ADD R5, 2						; se sim, soma 2 ao próximo valor a somar ao endereço da tabela com os diferentes tamanhos de meteoros

guarda_estado:
	MOV [R9], R5					; guarda o valor do estado do meteoro
	MOV R1, TAMANHOS_METEOROS_BONS  ; guarda o endereço da tabela de desenhos dos "meteoros"
	ADD R1, R5                      ; guarda o endereço da tabela de desenhos dos "meteoros" pretendido

fim_desce_meteoro:
	MOV R0, [R1]					; guarda endereço da tabela de desenho de "meteoro" pretendido
	MOV [R3], R0					; guarda a tabela do "meteoro" a ser desenhado no Alvo

	CALL desenha_boneco				; desenha boneco no Alvo

	MOV [R7], R6 					; guarda o contador de movimentos do "meteoro" na memória
	MOV R0, 0
	MOV [evento_int], R0		 	; muda o indicador de interrupção para 0
	JMP loop_desce_meteoro


; **********************************************************************
; SUBIR_MÍSSIL - Processo de subida do míssil
;		
; 		 
; **********************************************************************
PROCESS SP_inicial_relogio_missil

subir_missil:
	MOV		R4, POSICAO_MISSIL	; guarda o endereço da posição do míssil

loop_subir_missil:
	YIELD 
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1					; verifica se está em modo de jogo
	JNZ loop_subir_missil
	MOV  R0, [evento_int + 2]	; guarda o valor que indica se ocorreu a interrução 1
	CMP	 R0, 0      		    ; verifica se ocorreu interrupção
	JZ   loop_subir_missil 		; se estiver a 0, não é suposto decrescer a energia
	MOV R2, [R4]				; guarda a coluna do míssil
	CMP R2, 0					; vê se a coluna do míssil está 0 (não há míssil)
	JZ loop_subir_missil
	
	MOV R0, 0
	MOV	[SELECIONA_ECRA], R0	; seleciona o ecrã onde apagar e desenhar o míssil

;apaga o míssil
	MOV R1, [R4+2]				; guarda a linha do míssil
	MOV R3, 0					; guarda a cor 0 (para apagar)
	CALL escreve_pixel			

;limite superior do mísil
	MOV R0, MIN_LINHA_MISSIL	; guarda a linha do limite superior que o míssil pode chegar
	CMP	R1, R0					; verifica se o míssil já está no limite superior
	JZ apaga_missil

;desenha míssil
	SUB R1, 2					; sobe o míssil 2 pixeis para cima
	MOV R3, OURO				; guarda a cor do míssil
	CALL escreve_pixel

	MOV [R4+2], R1				; guarda a linha do míssil 

	MOV R0, 0
	MOV [evento_int + 2], R0	; põe indicador da interrupção 1 a 0
	JMP loop_subir_missil

apaga_missil:
	MOV R0, 0
	MOV [R4], R0				; guarda a coluna do míssil a 0
	MOV [R4+2], R0				; guarda a linha do míssil a 0
	MOV [evento_int + 2], R0	; põe indicador da interrupção a 0
	JMP loop_subir_missil


; **********************************************************************
; DECRESCE_DISPLAY - Processo de decréscimo periódico da energia.
;		
; **********************************************************************
PROCESS SP_inicial_relogio_energia

loop_decrescimo_energia:
	YIELD 

	MOV R0, [ESTADO_JOGO]
	CMP R0, 1						; verifica se está em modo de jogo
	JNZ loop_decrescimo_energia
	MOV  R1, [evento_int + 4]		; guarda o valor que indica se ocorreu a interrução 2
	CMP	 R1, 0      		     	; verificar se ocorreu interrupção
	JZ   loop_decrescimo_energia 	; se estiver a 0, não é suposto decrescer a energia
	
; diminuir o valor no display 
	MOV R0, [VALOR_DISPLAY]		 	; guarda o valor atual de energia no display 
	SUB R0, 5					 	; decresce 5 ao valor atual de energia
	MOV R3, 0                       
	MOV [evento_int + 4], R3        ; põe indicador da interrupção a 0
	CMP R0, 0                       ; verifica se a energia chegou a 0
	JN  boneco_morreu               ; se sim, o steve (a nave) morreu
	MOV [VALOR_DISPLAY], R0		    ; atualiza o endereço que guarda o valor a ser mostrado no display
	CALL calcula_display            
	JMP loop_decrescimo_energia

boneco_morreu:
	MOV     R4, 3
	MOV		[ESTADO_JOGO], R4                   ; seleciona o modo de fim de jogo
	MOV  	[APAGA_ECRÃ], R1					; apaga todos os pixels desenhados no ecrã	
	MOV     [PARA_TODOS_SONS], R1				; para a reprodução de todos os sons
	MOV     R1, 3
	MOV     [SELECIONA_CENARIO_FRONTAL], R1	    ; seleciona o cenário de 0 energia
    MOV     R1, SOM_DE_FIM						; seleciona o som de fim
	MOV     [VIDEO_SOM_LOOP], R1	            ; inicia a reprodução do som de fim
	MOV  	R1, MIN_ENERGIA                      	
	MOV  	[DISPLAYS], R1                      ; coloca o "display" a 0
	MOV 	R1, MIN_ENERGIA
	MOV  	[VALOR_DISPLAY],R1		            ; atualiza o endereço que guarda o valor a ser mostrado no display a 0
	JMP loop_decrescimo_energia


; **********************************************************************
; PROCESSO Trata da tecla 0 - Move o Steve para a esquerda enquanto a 
;                             tecla 0 for premida.
; 
; **********************************************************************

PROCESS	SP_inicial_tecla_0

trata_tecla_0:
	MOV		R1, DEF_STEVE		; guarda o endereço da nave
	MOV		R2, POSICAO_STEVE	; guarda o endereço da posição da nave
	MOV 	R3, ENDEREÇOS_ALVO	; guarda endereço do boneco alvo

loop_tecla_0:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1					; verifica se o jogo está a ativamente a decorrer
	JNZ loop_tecla_0
	MOV R0, [VALOR_TECLADO]		; guarda o valor do teclado
	CMP	R0, TECLA_0				; compara a tecla premida com o 0
	JNZ loop_tecla_0			; volta ao início do loop se não for 0
	
	MOV	[SELECIONA_ECRA], R0
	
	CALL atraso					; abranda o movimento do Steve

;apaga o Steve
	MOV [R3], R1				; guarda o endereço da tabela do Steve a ser apagado no Alvo
	MOV [R3+2], R2				; guarda o endereço da posição do Steve a ser apagado no Alvo
	CALL apaga_boneco			; apaga boneco no Alvo

;move o Steve para a esquerda
	MOV	R4, [R2]				; guarda o valor atual da coluna do Steve
	SUB	R4, 1	            	; desloca o Steve para a esquerda
	MOV	[R2], R4				; guarda a coluna do Steve na memória

	CALL testa_limites		; assegura que o Steve não sai do ecrã
	CALL desenha_boneco		; desenha boneco no Alvo
	JMP loop_tecla_0

; **********************************************************************
; PROCESSO Trata da tecla 1: Dispara o "missil"
; 
; **********************************************************************

PROCESS	SP_inicial_tecla_1

trata_tecla_1:
	MOV		R4, POSICAO_MISSIL	; guarda o endereço da posição do míssil
	MOV		R5, POSICAO_STEVE	; guarda o endereço da posição do Steve

loop_tecla_1:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1			        ; verifica se está em modo de jogo
	JNZ loop_tecla_1			; volta ao início do loop se não for 1
	MOV R0, [VALOR_TECLADO]		; guarda o valor do teclado
	CMP	R0, TECLA_1				; compara a tecla premida com o 1
	JNZ loop_tecla_1			; volta ao início do loop se não for 1
	MOV R0, [R4]
	CMP R0, 0					; verifica se a coluna do míssil é zero
	JNZ loop_tecla_1			; se não for 0, ainda há um míssil no ecrã e não se pode disparar

	MOV	[SELECIONA_ECRA], R0
	
;cria e guarda o míssil
	MOV R1, LINHA_INICIAL_MISSIL ; guarda a linha incial do míssil
	MOV [R4+2], R1				; guarda a linha inicial no endereço da posição do míssil
	MOV R2, [R5]				; guarda a coluna do Steve
	ADD R2, 2					; calcula coluna do centro do Steve
	MOV [R4], R2				; guarda a coluna no endereço da posição do míssil


	MOV	R3, OURO				; cor do míssil 
	MOV R6, [VALOR_DISPLAY]		; guarda o valor atual de energia no display 
	SUB R6, 5					; decresce 5 ao valor atual de energia
	CMP R6, 0					; verifica se o valor ficou negativo
	JP  continua_display		
	MOV  R6, 0					; se ficou negativo, passa a 0

continua_display:
	MOV [VALOR_DISPLAY], R6		; atualiza o valor a ser mostrado no display
	CALL calcula_display
	MOV R7, SOM_MISSIL			; guarda o valor do som do míssil
	MOV [TOCA_SOM_VIDEO], R7	; toca o som do míssil
	MOV [PARA_VIDEO_SOM], R7	; pára o som do míssil
	CALL escreve_pixel			; desenha o pixel do míssil na posição inicial

	JMP loop_tecla_1

; **********************************************************************
; Processo
; Tecla 2: Move o Steve para a direita enquanto a tecla 2 for premida.
;  
; **********************************************************************

PROCESS	SP_inicial_tecla_2

trata_tecla_2:
	MOV		R1, DEF_STEVE	; guarda o endereço da nave
	MOV		R2, POSICAO_STEVE	; guarda o endereço da posição da nave
	MOV 	R3, ENDEREÇOS_ALVO		; guarda endereço do boneco alvo

loop_tecla_2:
	YIELD
	MOV R0, [ESTADO_JOGO]
	CMP R0, 1			; verifica se o jogo está a ativamente a decorrer
	JNZ loop_tecla_2
	MOV R0, [VALOR_TECLADO]		; guarda o valor do teclado
	CMP	R0, TECLA_2				; compara a tecla premida com o 2
	JNZ loop_tecla_2			; volta ao início do loop se não for 2

	MOV R0, 0
	MOV	[SELECIONA_ECRA], R0

	CALL atraso					; abranda o movimento do Steve

;apaga o Steve
	MOV [R3], R1			; guarda o endereço da tabela de desenho do Steve a ser apagado no Alvo
	MOV [R3+2], R2			; guarda o endereço da posição do Steve a ser apagado no Alvo
	CALL apaga_boneco		; apaga boneco no Alvo

;move o Steve para a direita
	MOV	R4, [R2]			; guarda o valor atual da coluna do Steve
	ADD	R4, 1	            ; desloca o Steve para a esquerda
	MOV	[R2], R4			; guarda a coluna do Steve na memória

	CALL testa_limites		; assegura que o Steve não sai do ecrã
	CALL desenha_boneco		; desenha boneco no Alvo
	JMP loop_tecla_2


; **********************************************************************
; Processo
; Tecla C- Recomeça o jogo quando a tecla C é premida.
;					 
; **********************************************************************

PROCESS SP_inicial_tecla_C

loop_tecla_c:
	YIELD
	MOV R1, [VALOR_TECLADO]
	MOV R2, [ESTADO_JOGO]
	
	MOV R3, TECLA_C
	CMP	R1, R3
	JNZ	loop_tecla_c                    
	CMP	R2, 1				                ; verifica se está em modo de jogo 
	JZ	loop_tecla_c						; o jogo só deve poder recomeçar se estiver no início, em pausa ou no fim
   
; reiniciar o movimento dos meteoros	
	MOV	R1, POSICAO_METEORO_1
	MOV	R10, 0
reset_meteoros:
	YIELD
	CALL coloca_topo_aleatorio
	ADD		R1, 4
	ADD		R10, 1
	CMP		R10, 4
	JNZ		reset_meteoros
 
; parar o modo de pausa/fim
	MOV	 R1, 1				            
	MOV  [ESTADO_JOGO], R1					; seleciona o estado do jogo
	MOV  [APAGA_ECRÃ], R1					; apaga todos os pixels desenhados
	MOV  [APAGA_CENARIO_FRONTAL], R1    	; apaga o ecrã de morte/ de pausa
	MOV  [PARA_TODOS_SONS], R1				; para todos os sons

; reiniciar o jogo	
	MOV  R1, 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1		; seleciona o cenário de fundo 
	MOV  R1, SOM_DE_JOGO
	MOV  [VIDEO_SOM_LOOP], R1				; inicia a reprodução da música de fundo
	MOV  R3, MAX_ENERGIA                 	; inicializa os displays a 100
	MOV  [DISPLAYS], R3
	MOV  R4, 100
	MOV  [VALOR_DISPLAY],R4					; inicializa o valor a mostrar nos displays a 100

; inicializar a posição do Steve	
	MOV  R1, COLUNA_STEVE					
	MOV  [POSICAO_STEVE], R1
	MOV  R1, LINHA_STEVE
	MOV  [POSICAO_STEVE + 2], R1

; inicializa a posição do missil	
	MOV  R1, 0
	MOV [POSICAO_MISSIL], R1
	MOV [POSICAO_MISSIL+2], R1

	CALL mostra_Steve						

	JMP loop_tecla_c

	
; **********************************************************************
; Processo Tecla D- Pausa e Continua o jogo quando a tecla D é premida.
;			 
; **********************************************************************

PROCESS SP_inicial_tecla_D

trata_tecla_d:

loop_tecla_d:
	YIELD
	MOV R1, [VALOR_TECLADO]
	MOV R2, [ESTADO_JOGO]
	MOV R3, TECLA_D
	CMP	R1, R3
	JNZ	loop_tecla_d
	MOV R3, [TECLA_JA_EXECUTADA]
	CMP R3, 1						; verifica se a tecla já foi premida
	JZ loop_tecla_d					; se sim, espera que largue a tecla e a pressione de novo 
	CMP	R2, 2				        ; testa se o jogo está em pausa   
	JZ	loop_tecla_d_continuar      ; se sim, permite a continuação do jogo
	CMP	R2, 1						; testa se o jogo está a correr
	JZ	loop_tecla_d_pausar         ; se sim, pausa o jogo
	CMP R2, 0						; se o jogo estiver no início, a tecla D não funciona
	JZ  loop_tecla_d
	CMP R2, 3						; se o jogo estiver no fim, a tecla D não funciona
	JZ  loop_tecla_d
	

loop_tecla_d_pausar:

    MOV  [APAGA_ECRÃ], R1	                ; apaga todos os pixels já desenhados
	MOV	 R1, 2  
	MOV  [ESTADO_JOGO], R1				    ; seleciona o modo de pausa
	MOV  R1, SOM_DE_JOGO
	MOV  [PAUSA_VIDEO_SOM], R1          	; para a música de fundo
	MOV  R1, 1
    MOV  [SELECIONA_CENARIO_FRONTAL], R1	; seleciona o cenário de pausa
	MOV  [TECLA_JA_EXECUTADA], R1		    ; guarda 1, para indicar que a tecla já foi executada
	MOV  R1, SOM_DE_PAUSA
	MOV  [VIDEO_SOM_LOOP], R1				; inicia a reprodução da música do menu de pausa
	JMP  loop_tecla_d
	
loop_tecla_d_continuar:	

	MOV	 R1, 1		            
	MOV  [ESTADO_JOGO], R1				; indica que o jogo pode continuar 
	MOV  [TECLA_JA_EXECUTADA], R1		; guarda 1, para indicar que a tecla já foi executada
	MOV  [APAGA_CENARIO_FRONTAL], R2    ; apaga o ecrã de pausa 
	MOV  R1, SOM_DE_PAUSA
	MOV  [PARA_VIDEO_SOM], R1          	; para a música de fundo
	MOV  R1, 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo do jogo
	MOV  R1, SOM_DE_JOGO
	MOV  [CONTINUA_VIDEO_SOM], R1	    ; continua a reprodução do som de jogo


	CALL mostra_Steve						
	JMP  loop_tecla_d

; **********************************************************************
; PROCESSO Tecla E- Termina o jogo quando a tecla E é premida.
;					 
; **********************************************************************

PROCESS SP_inicial_tecla_E

loop_tecla_e:
	YIELD
	MOV R1, [VALOR_TECLADO]
	MOV R2, [ESTADO_JOGO]
	
	MOV R3, TECLA_E
	CMP	R1, R3                              ; verifica se a tecla E foi premida
	JNZ	loop_tecla_e                 
	CMP	R2, 0				                ; testa se o jogo está no ínicio
	JZ	loop_tecla_e
	CMP R2, 3								; testa se o jogo terminou 
	JZ  loop_tecla_e
	
  
	MOV	 R1, 3			            
	MOV  [ESTADO_JOGO], R1				    ; seleciona o modo de jogo terminado
; apagar imagens e sons do modo de jogo	
	MOV  [APAGA_ECRÃ], R1					; apaga todos os pixels desenhados no ecrã			
	MOV  [PARA_TODOS_SONS], R1				; para a reprodução do som de todos os sons

; mostrar imagem e sons do modo de fim  	
	MOV  R1, 2
	MOV  [SELECIONA_CENARIO_FRONTAL], R1	; seleciona o cenário de morte
    MOV  R1, SOM_DE_FIM
	MOV  [VIDEO_SOM_LOOP], R1				; inicia a reprodução da música de fim de jogo

	JMP loop_tecla_e


; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
;				Escreve na tabela que indica se a interrupção ocorreu 
;				ou não. 
; **********************************************************************

rot_int_0:
	PUSH R1
	PUSH R2
	
	MOV  R1, evento_int
	MOV  R2, 1
	MOV	 [R1], R2	                 ; desbloqueia processo de interrupções
	
	POP  R2
	POP	 R1
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
;				Escreve na tabela que indica se a interrupção ocorreu 
;				ou não. 
; **********************************************************************

rot_int_1:
	PUSH R1
	PUSH R2
	
	MOV  R1, evento_int
	MOV  R2, 1
	MOV	 [R1+2], R2	                 ; desbloqueia processo de interrupções
	
	POP  R2
	POP	 R1
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;				Escreve na tabela que indica se a interrupção ocorreu 
;				ou não. 
; **********************************************************************

rot_int_2:
	PUSH R1
	PUSH R2
	
	MOV  R1, evento_int
	MOV  R2, 1
	MOV	 [R1+4], R2	                 ; desbloqueia processo de interrupções
	
	POP  R2
	POP	 R1
	RFE