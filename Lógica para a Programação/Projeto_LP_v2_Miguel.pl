:- [codigo_comum].
/*
Projeto Logica para Programacao - Solucionador de Puzzles Hashi (Parte I)
Miguel Fernandes  n_aluno:103573
Data: 30/1/2022
*/ 

/* 2.1 ---------------------------------------------------------------------------------------
extrai_ilhas_linha(X, Linha, Ilhas)
Ilhas eh a lista ordenada cujos elementos sao as ilhas existentes
na linha X do puzzle.
---------------------------------------------------------------------------------------------- */
extrai_ilhas_linha(X, Linha, Ilhas):-
        findall(ilha(Po, (X, Y)), (nth1(Y, Linha, Po), Po \== 0), Ilhas).



/* 2.2 ---------------------------------------------------------------------------------------
ilhas(Puzzle, Ilhas)
Ilhas eh a lista ordenada cujos elementos sao as ilhas de Puzzle.
---------------------------------------------------------------------------------------------- */
ilhas(Puzzle, Ilhas):-
    findall(Lst_I, (nth1(X, Puzzle, Linha), extrai_ilhas_linha(X, Linha, Lst_I)), Lst_de_lsts),
    append(Lst_de_lsts, Ilhas).



/* 2.3 ---------------------------------------------------------------------------------------
vizinhas(Ilhas, Ilha, Vizinhas)
Ilhas eh a lista de ilhas de um puzzle e Ilha eh uma dessas ilhas,
Vizinhas eh a lista das ilhas vizinhas de Ilha.
---------------------------------------------------------------------------------------------- */
vizinhas(Ilhas, ilha(_,(X, Y)), Vizinhas):-
        sort(2, <, Ilhas, Ilhas_sorted),

        % X eh o numero de linha e Y eh o numero de coluna
        findall(ilha(Po,(X1, Y)), (member(ilha(Po,(X1, Y)), Ilhas_sorted), X1 < X), Acima),
        findall(ilha(Po,(X1, Y)), (member(ilha(Po,(X1, Y)), Ilhas_sorted), X1 > X), Baixo),
        findall(ilha(Po,(X, Y1)), (member(ilha(Po,(X, Y1)), Ilhas_sorted), Y1 < Y), Esquerda),
        findall(ilha(Po,(X, Y1)), (member(ilha(Po,(X, Y1)), Ilhas_sorted), Y1 > Y), Direita),
        
        pega_ultimo(Acima, Ilha_Ac), pega_ultimo(Esquerda, Ilha_Esq),
        pega_primeiro(Baixo, Ilha_Ba), pega_primeiro(Direita, Ilha_Di),
        
        append([Ilha_Ac, Ilha_Esq, Ilha_Di, Ilha_Ba], Vizinhas).

/* 2.3 (predicados auxiliares)  ------------------------------------
pega_primeiro(Lista_I, Ilha)
Lista_I eh uma lista de ilhas e Ilha eh a primeira ilha dessa lista.

pega_ultimo(Lista_I, Ilha)
Lista_I eh uma lista de ilhas e Ilha eh a ultima ilha dessa lista.
-------------------------------------------------------------------- */
pega_primeiro([], []):- !.
pega_primeiro([P|_], [P]).
pega_ultimo([], []):- !.
pega_ultimo(Lst, [U]):- last(Lst, U).



/* 2.4 ---------------------------------------------------------------------------------------
estado(Ilhas, Estado)
Estado eh a lista ordenada cujos elementos sao as entradas referentes a cada uma das
ilhas de Ilhas.
---------------------------------------------------------------------------------------------- */
estado(Ilhas, Estado):-
        findall([Ilha, Vizis, []], (member(Ilha, Ilhas), vizinhas(Ilhas, Ilha, Vizis)), Estado).



/* 2.5 ---------------------------------------------------------------------------------------
posicoes_entre(Pos1, Pos2, Posicoes)
Posicoes eh a lista ordenada de posicoes entre Pos1 e Pos2 (excluindo Pos1 e Pos2).
---------------------------------------------------------------------------------------------- */
% Pos1 e Pos2 na mesma linha
posicoes_entre((X, Y1), (X, Y2), Posicoes):- 
        /* Nsup e Ninf incluem valores de Pos1 e Pos2, por isso passo a Nmax e Nmin
        pois quero uma lista de posiocoes entre Pos1 e Pos2, nao inclusive */
        max_list([Y1, Y2], Nsup), min_list([Y1, Y2], Ninf), 
        Nmax is Nsup -1, Nmin is Ninf +1,

        findall((X, Y), (between(Nmin, Nmax, Y), integer(Y)), Posicoes).

% Pos1 e Pos2 na mesma coluna
posicoes_entre((X1, Y), (X2, Y), Posicoes):- 
        max_list([X1, X2], Nsup), min_list([X1, X2], Ninf), 
        Nmax is Nsup -1, Nmin is Ninf +1,

        findall((X, Y), (between(Nmin, Nmax, X), integer(X)), Posicoes).



/* 2.6 ---------------------------------------------------------------------------------------
cria_ponte(Pos1, Pos2, Ponte)
Ponte eh uma ponte entre Pos1 e Pos2.
---------------------------------------------------------------------------------------------- */
cria_ponte(Pos1, Pos2, ponte(P1, P2)):- sort([Pos1, Pos2], [P1, P2]).



/* 2.7 ---------------------------------------------------------------------------------------
caminho_livre(Pos1, Pos2, Posicoes, I, Vz)
Posicoes eh a lista ordenada de posicoes entre Pos1 e Pos2, I eh uma ilha, e Vz
eh uma das suas vizinhas, significa que a adicao da ponte ponte(Pos1, Pos2) nao faz
com que I e Vz deixem de ser vizinhas.
---------------------------------------------------------------------------------------------- */
caminho_livre(Pos1, _, Posicoes1, ilha(_, PosI_1), ilha(_, PosI_2)):-
        posicoes_entre(PosI_1, PosI_2, Posicoes2),
        
        (Posicoes1 == Posicoes2, member(Pos1, [PosI_1, PosI_2]) 
        ; 
        findall(Pos, (member(Pos, Posicoes1), member(Pos, Posicoes2)), [])).



/* 2.8 ---------------------------------------------------------------------------------------
actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada, Nova_Entrada)
Pos1 e Pos2 sao posicoes entre as quais sera adicionada uma ponte, Posicoes
eh a lista das Posicoes ordenadas entre Pos1 e Pos2 e Nova_Entrada eh a 
Entrada com a lista de vizinhas atualizada apos a adicao das pontes.
---------------------------------------------------------------------------------------------- */ 
actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha,Vizis,Pontes], [Ilha,NovaVizis,Pontes]):-
        findall(Viz, (member(Viz, Vizis), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz)), NovaVizis).



/* 2.9 ---------------------------------------------------------------------------------------
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) 
Estado eh um estado, Pos1 e Pos2 sao as posicoes entre as quais foi adicionada 
uma ponte, significa que Novo_estado eh o estado que se obtem de Estado apos a 
actualizacao das ilhas vizinhas de cada uma das suas entradas.
---------------------------------------------------------------------------------------------- */
actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado):-
        posicoes_entre(Pos1, Pos2, Posicoes),

        findall(NovaEnt, (member(Ent, Estado),
        actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Ent, NovaEnt)), Novo_estado).



/* 2.10 --------------------------------------------------------------------------------------
ilhas_terminadas(Estado, Ilhas_term)
Ilhas_term eh a lista de ilhas que ja tem todas as pontes associadas.
---------------------------------------------------------------------------------------------- */
ilhas_terminadas(Estado, Ilhas_term):-
        findall(ilha(Po, Pos), (member([ilha(Po, Pos),_,LstPo], Estado),
        Po \== 'X', length(LstPo, Po)), Ilhas_term).



/* 2.11 --------------------------------------------------------------------------------------
 tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)
Ilhas_term eh uma lista de ilhas terminadas e Entrada eh uma entrada,
significa que Nova_entrada eh a entrada resultante de remover as ilhas de
Ilhas_term, da lista de ilhas vizinhas da entrada.
---------------------------------------------------------------------------------------------- */
tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizis, Pos], [Ilha, NovaVizis, Pos]):-
        findall(Viz, (member(Viz, Vizis), \+ member(Viz, Ilhas_term)), NovaVizis).



/* 2.12 --------------------------------------------------------------------------------------
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado)
Novo_estado eh o resultado de aplicar o predicado tira_ilhas_terminadas_entrada a 
cada uma das entradas de Estado.
---------------------------------------------------------------------------------------------- */
tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
        maplist(tira_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).



/* 2.13 --------------------------------------------------------------------------------------
marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)
Nova_entrada eh a entrada obtida de Entrada: se a ilha de Entrada 
pertencer a Ilhas_term, o numero de pontes desta eh substituido por 'X';
em caso contrario Nova_entrada eh igual a Entrada.
---------------------------------------------------------------------------------------------- */
marca_ilhas_terminadas_entrada(Ilhas_T, [ilha(P,(X,Y)), Viz, Pos], [ilha(Pnovo,(X,Y)), Viz, Pos]):-
        member(ilha(P,(X,Y)), Ilhas_T), Pnovo = 'X'
        ;
        \+ member(ilha(P,(X,Y)), Ilhas_T), Pnovo = P.



/* 2.14 --------------------------------------------------------------------------------------
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado)
Ilhas_term eh uma lista de Ilhas Terminadas
Novo_estado eh o estado resultante de aplicar o predicado
marca_ilhas_terminadas_entrada a cada uma das entradas de Estado.
---------------------------------------------------------------------------------------------- */
marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
        maplist(marca_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).



/* 2.15 --------------------------------------------------------------------------------------
trata_ilhas_terminadas(Estado, Novo_estado)
Novo_estado eh o estado resultante de aplicar os predicados
marca_ilhas_terminadas_entrada e tira_ilhas_terminadas a Estado.
---------------------------------------------------------------------------------------------- */
trata_ilhas_terminadas(Estado, Novo_estado):-
        ilhas_terminadas(Estado, Ilhas_term),
        marca_ilhas_terminadas(Estado, Ilhas_term, Temp_estado),
        tira_ilhas_terminadas(Temp_estado, Ilhas_term, Novo_estado).



/* 2.16 --------------------------------------------------------------------------------------
junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado)
Estado eh um estado e Ilha1 e Ilha2 sao 2 ilhas, significa que Novo_estado eh
o estado que se obtem de Estado por adicao de Num_pontes pontes entre Ilha1 e
Ilha2.
---------------------------------------------------------------------------------------------- */
junta_pontes(Estado_v1, Num_pontes, ilha(_, Pos1), ilha(_, Pos2), Novo_estado):- 
        length(Pontes1, Num_pontes), 
        
        maplist(cria_ponte(Pos1, Pos2), Pontes1),
        maplist(ad_ponte(Pos1, Pos2, Pontes1), Estado_v1, Estado_v2),

        actualiza_vizinhas_apos_pontes(Estado_v2, Pos1, Pos2, Estado_v3),
        trata_ilhas_terminadas(Estado_v3, Novo_estado).

/* 2.16 (predicado auxiliar)  --------------------------------------------------------
ad_ponte(Pos1, Pos2, Pontes1, Entrada, Nova_entrada)
Pontes1 eh uma lista de pontes em que todas comecam e acabam nas posicoes Pos1 e Pos2.
Nova_entrada eh obtida da Entrada: Se a primeira ilha de Entrada estiver na posicao
Pos1 ou Pos2, eh lhe adicionada a lista Pontes1 ah lista de pontes da Entrada;
Caso contrario, Nova_entrada eh igual a Entrada.
-------------------------------------------------------------------------------------- */
ad_ponte(Pos1, Pos2, Pontes1, [ilha(Po, Pos), Viz, Pontes2], [ilha(Po, Pos), Viz, PontesNova]):-
        member(Pos, [Pos1, Pos2]), append([Pontes1, Pontes2], PontesNova)
        ;
        \+ member(Pos, [Pos1, Pos2]), Pontes2 = PontesNova.
