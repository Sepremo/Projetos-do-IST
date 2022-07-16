:- [codigo_comum].
/*
Projeto Logica para Programacao - Solucionador de Puzzles Hashi (Parte I)
Miguel Fernandes  n_aluno:103573
Data: 30/1/2022
*/ 
extrai_ilhas_linha(X, Linha, Ilhas):-
        findall(ilha(Po, (X, Y)), (nth1(Y, Linha, Po), Po \== 0), Ilhas).


ilhas(Puzzle, Ilhas):-
    findall(Lst_I, (nth1(X, Puzzle, Linha), extrai_ilhas_linha(X, Linha, Lst_I)), Lst_de_lsts),
    append(Lst_de_lsts, Ilhas).

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


pega_primeiro([], []):- !.
pega_primeiro([P|_], [P]).
pega_ultimo([], []):- !.
pega_ultimo(Lst, [U]):- last(Lst, U).

estado(Ilhas, Estado):-
        findall([Ilha, Vizis, []], (member(Ilha, Ilhas), vizinhas(Ilhas, Ilha, Vizis)), Estado).


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


cria_ponte(Pos1, Pos2, ponte(P1, P2)):- sort([Pos1, Pos2], [P1, P2]).

caminho_livre(Pos1, _, Posicoes1, ilha(_, PosI_1), ilha(_, PosI_2)):-
        posicoes_entre(PosI_1, PosI_2, Posicoes2),
        
        (Posicoes1 == Posicoes2, member(Pos1, [PosI_1, PosI_2]) 
        ; 
        findall(Pos, (member(Pos, Posicoes1), member(Pos, Posicoes2)), [])).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha,Vizis,Pontes], [Ilha,NovaVizis,Pontes]):-
        findall(Viz, (member(Viz, Vizis), caminho_livre(Pos1, Pos2, Posicoes, Ilha, Viz)), NovaVizis).


actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado):-
        posicoes_entre(Pos1, Pos2, Posicoes),

        findall(NovaEnt, (member(Ent, Estado),
        actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Ent, NovaEnt)), Novo_estado).


ilhas_terminadas(Estado, Ilhas_term):-
        findall(ilha(Po, Pos), (member([ilha(Po, Pos),_,LstPo], Estado),
        Po \== 'X', length(LstPo, Po)), Ilhas_term).


tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizis, Pos], [Ilha, NovaVizis, Pos]):-
        findall(Viz, (member(Viz, Vizis), \+ member(Viz, Ilhas_term)), NovaVizis).


tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
        maplist(tira_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).


marca_ilhas_terminadas_entrada(Ilhas_T, [ilha(P,(X,Y)), Viz, Pos], [ilha(Pnovo,(X,Y)), Viz, Pos]):-
        member(ilha(P,(X,Y)), Ilhas_T), Pnovo = 'X'
        ;
        \+ member(ilha(P,(X,Y)), Ilhas_T), Pnovo = P.


marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado):-
        maplist(marca_ilhas_terminadas_entrada(Ilhas_term), Estado, Novo_estado).




trata_ilhas_terminadas(Estado, Novo_estado):-
        ilhas_terminadas(Estado, Ilhas_term),
        marca_ilhas_terminadas(Estado, Ilhas_term, Temp_estado),
        tira_ilhas_terminadas(Temp_estado, Ilhas_term, Novo_estado).


junta_pontes(Estado_v1, Num_pontes, ilha(_, Pos1), ilha(_, Pos2), Novo_estado):- 
        length(Pontes1, Num_pontes), 
        
        maplist(cria_ponte(Pos1, Pos2), Pontes1),
        maplist(ad_ponte(Pos1, Pos2, Pontes1), Estado_v1, Estado_v2),

        actualiza_vizinhas_apos_pontes(Estado_v2, Pos1, Pos2, Estado_v3),
        trata_ilhas_terminadas(Estado_v3, Novo_estado).


ad_ponte(Pos1, Pos2, Pontes1, [ilha(Po, Pos), Viz, Pontes2], [ilha(Po, Pos), Viz, PontesNova]):-
        member(Pos, [Pos1, Pos2]), append([Pontes1, Pontes2], PontesNova)
        ;
        \+ member(Pos, [Pos1, Pos2]), Pontes2 = PontesNova.

