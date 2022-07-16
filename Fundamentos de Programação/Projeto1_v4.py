"""Projeto nº1_Buggy Data Base (BDB)
O projeto são 5 pontos com várias funções cada que servem para corrigir erros, 
validar argumentos e organizar resultados de cada ponto:

1. Corrigir um texto com erros (surto de letras)
2. Descobrir o PIN através de instruções de movimentos
3. Encontrar dados cujo argumento não é válido ou que elemntos sejam incoerentes
4. Desencriptar frases usando números de segurança
5. Encontrar utilizadores que introduziram senhas erradas

Miguel Fernandes _ nº estudante: 103573 _ Data da última alteração: 30/10/2021
email: miguel.e.fernandes@tecnico.ulisboa.pt

####################### 1. Correção da documentação ############################
"""
######### 1.2.1 #############
def corrigir_palavra(string):
    """Corrige a palavra, apagando erros tipo "aA"
    
    Usa o código ASCII associado a cada letra para detetar e apagar letras 
    maiúsculas seguidas da sua versão minúscula e vice-versa (ex: Aa; bB)
    """
    i = 0
    while i + 1 < len(string): 
        #nºASCII de uma letra maiúscula +32 = nºASCII dessa letra minúscula
        if abs(ord(string[i]) - ord(string[i + 1])) == 32:
            string = string[0:i] + string[i + 2:]
            if i < 2: 
                i = -1
            else:                
                i = i - 2       
        i += 1
    return string

############# 1.2.2 ##############
def eh_anagrama(string1, string2):
    """Diz se as palavras são anagramas uma da outra
    
    Avalio se cada tipo de caracter aparece o mesmo número de vezes em ambas as
    palavras em string1 e string2. Se sim, retorna True, caso contrario, string1 
    não é anagrama de string2 e retorna Falso
    """
    string1 = string1.lower()  
    string2 = string2.lower()
    
    string1= sorted(string1)
    string2= sorted(string2)
    return string1 == string2

######## 1.2.3 ########
def corrigir_doc(Texto):
    """Verifica que o texto é válido e corrije, se válido
    
    Uso o código ASCII para verificar que o Texto tem apenas palavras 
    constituídas por letras e espaços entre as palavras. Depois corrigo as 
    palavras e vejo se são anagramas umas das outras, apagando o segundo 
    anagrama que encontro. Retorna uma string do Texto corrigido
    """
    if type(Texto) != str or len(Texto) == 0:
        raise ValueError("corrigir_doc: argumento invalido")
    
    for i in  range(len(Texto) -1):
        #Verifica que o Texto tem só letras ou espaços
        if not all(car.isalpha() or car.isspace() for car in Texto):
            raise ValueError("corrigir_doc: argumento invalido")
        
        #Verifica que um espaço não é seguido por outro espaço
        if Texto[i].isspace() and Texto[i + 1].isspace():
            raise ValueError("corrigir_doc: argumento invalido")
        i += 1
       
    
    listaTexto = Texto.split()
    listaTexto = [corrigir_palavra(palavra) for palavra in listaTexto]
    
    i1 = 0
    while i1 < len(listaTexto):
        palavra = listaTexto[i1]
        i2 = i1 + 1
        while i2 < len(listaTexto):
            
            #Apaga o segundo anagrama, exepto quando é a mesma palavra
            if eh_anagrama(palavra, listaTexto[i2]) and \
            palavra.lower() != listaTexto[i2].lower():
                listaTexto.remove(listaTexto[i2])
                
            else: i2 += 1
        i1 += 1
    return (" ".join(listaTexto))

"""               
########################### 2. Descoberta do PIN ###############################
"""
############ 2.2.1 #############
def obter_posicao (letra, nPIN):
    """Dá o número do PIN após cada movimento indicado por cada letra
    
    Associo a cada numero do PIN a coordenadas que altero de acordo com o 
    movimento indicado pela letra, devolvendo o número associado ás 
    coordenadas resultantes:
                 Colunas:
               (1) (2) (3)    A primeira coordenada é a linha e a segunda 
            (1) 1   2   3     coordenada é a coluna, por exemplo:
    Linhas: (2) 4   5   6     (2, 3) -> 6    (3, 3) -> 9    (3, 1) -> 7
            (3) 7   8   9
            
    """
    tuploPos = ((1, 1), (1, 2), (1, 3), (2, 1), (2, 2), \
                (2, 3), (3, 1), (3, 2), (3, 3))
    Pos = tuploPos[nPIN - 1]
    if letra == "C":
        if Pos[0] > 1:
            Pos = (Pos[0] - 1, Pos[1])
    if letra == "B":
        if Pos[0] < 3:
            Pos = (Pos[0] + 1, Pos[1])        
    if letra == "D":
        if Pos[1] < 3:
            Pos = (Pos[0], Pos[1] + 1)        
    if letra == "E":
        if Pos[1] > 1:
            Pos = (Pos[0], Pos[1] - 1)
    
    nPIN = tuploPos.index(Pos) + 1 
    return nPIN

########### 2.2.2 ############
def obter_digito(letras, num):
    """Encontra o número do PIN
    
    Recebe várias letras e devolve o número na posição final, após executar 
    todos os movimentos indicados pelas letras usando o obter_posicao ()
    """
    for car in letras:
        num = obter_posicao(car, num)
    return num

####### 2.2.3 ####### 
def obter_pin(tuploLetras):
    """Verifica a validade do tuplo de letras e retorna o PIN
    
    Verifico que é introduzida uma lista de 4 a 10 instruções constituídas por
    C, B, E ou D. Depois retorna um tuplo dos números do PIN, que são obtidos por 
    movimentos indicados pelas letras, que iniciam da posição do número anterior
    """
    if type(tuploLetras) != tuple:
        raise ValueError("obter_pin: argumento invalido")    
    
    if not 4 <= len(tuploLetras) <= 10:
        raise ValueError("obter_pin: argumento invalido")
    
    LetrasAceites = ("C", "B", "E", "D")
    for i in range(len(tuploLetras)):
        if not tuploLetras[i].isalpha() or not tuploLetras[i].isupper() \
        or any([letra not in LetrasAceites for letra in tuploLetras[i]]):
            raise ValueError("obter_pin: argumento invalido")
    
    digito = 5
    PIN = []
    for i in range(len(tuploLetras)):
        PIN.append(obter_digito(tuploLetras[i], digito))
        digito = obter_digito(tuploLetras[i], digito)
    
    return tuple(PIN)

"""               
########################### 3. Verificação de dados ############################
"""
####### 3.2.1 ########
def eh_entrada(tuplo):
    """Verifico se a entrada é válida
    
    Verifico que os 3 campos do tuplo inserido têm as características 
    requeridas: tuplo(cifra, checksum, nSegurança)
    cifra: palavras constituídas por letras minusculas e separadas por "-"
    checksum: string de 5 letras minúsculas entre parenteses retos [ ]
    nSegurança: tuplo de 2 ou mais números inteiros positivos (ex:(80, 34))
    Retorna True se verificar tudo isto e False se algo não se verificar
    """
    #Vê se é um tuplo com 3 elementos e que o primeiro elemento dele não é vazio
    if type(tuplo) != tuple or len(tuplo) != 3 or type(tuplo[0]) != str or \
    len(tuplo[0]) < 1:
        return False
    
    #Vê se tuplo[1] é uma string de 5 elementos entre parênteses retos
    if type(tuplo[1]) != str or len(tuplo[1]) != 7 or tuplo[1][0] != "[" or \
    tuplo[1][6] != "]" or not tuplo[1][1:6].islower():
        return False
    
    if type(tuplo[2]) != tuple or len(tuplo[2]) < 2:
        return False
    
    #Vê se o tuplo[0] é string de palavras com letras minúsculas separadas por "-"
    if tuplo[0].startswith("-") or tuplo[0].endswith("-"):
        return False
    for car in tuplo[0]:
        if car != "-":
            if not car.isalpha() or not car.islower():
                return False           
    
    #Vê se tuplo[1] tem apenas letras minúsculas entre os parênteses retos
    for i in range(1, 6):
        if not tuplo[1][i].isalpha():
            return False
    for i in range(len(tuplo[2])):
        if type(tuplo[2][i]) != int or tuplo[2][i] <= 0:
            return False
    
    return True

############## 3.2.2 #############
def validar_cifra(cifra, checksum):
    """Verifica se a cifra é coerente com o checksum
    
    Vê quais são os 5 caracteres que mais ocorrem na cifra, ordenado-os primeiro 
    por nº ocorrências e depois alfabeticamente e verifica se o resultado é 
    igual ao checksum, retornando True se for igual e False se for diferente
    """
    cifra= cifra.replace("-", "")
    
    dictletras= {}
    while len(cifra) != 0:
        #Cada letra fica Key, associada ao valor do seu nº ocorrências na cifra
        dictletras[cifra[0]] = cifra.count(cifra[0])
        cifra= cifra.replace(cifra[0], "")
   
    result = ""
    while len(dictletras) != 0 and len(result) < 5:
        nMax = max(dictletras.values())
        #Pegar nas letras que ocorrem nMax vezes (o maior número de vezes)
        letrasMax = [k for k, v in dictletras.items() if v == nMax]
        
        for car in letrasMax:
            del dictletras[car]
        
        letrasMax.sort()
        #Junto os characteres na lista letrasMax num string sem espaços
        result += "".join([str(item) for item in letrasMax])
        
    result = "["+ result[:5] + "]"
    return result == checksum

######## 3.2.3 ########
def filtrar_bdb(lista):
    """Verifica se entradas são válidas e retorna as incoerentes
    
    Verifica que recebe uma lista com uma ou mais entradas e que essas entradas 
    são válidas. De seguida, retorna uma lista das entradas em que a cifra não é
    coerente com o checksum da mesma
    """
    if type(lista) != list or len(lista) <= 0:
        raise ValueError("filtrar_bdb: argumento invalido")
    
    for entrada in lista:
        if not eh_entrada(entrada):
            raise ValueError("filtrar_bdb: argumento invalido")
    
    return [entrada for entrada in lista if not validar_cifra(entrada[0], \
            entrada[1])]

"""               
######################### 4. Desencriptação de dados ###########################
"""
##4.2.1 (eh_entrada() já definido)##

############# 4.2.2 ##############
def obter_num_seguranca(TuploNum):
    """Determinar o número de segurança
    
    Ordeno os números no tuplo numa lista por ordem crescente e retorno o menor 
    valor absoluto da diferença entre cada número e o numero do index seguinte
    """
    TuploNum = list(TuploNum)
    TuploNum.sort()
    return min([abs(TuploNum[i]-TuploNum[i+1]) for i in range(len(TuploNum)-1)])

############# 4.2.3 ##############
def decifrar_texto(cifra, nSegur):
    """Decifra a cifra usando o número de segurança
    
    Pego no número ASCII de cada letra e adiciono o resto da divisão da soma do 
    número de segurança e o x, onde x é 1 se a letra estiver num posição par e 
    -1 se a letra estiver numa posição ímpar. [ chr(ord(letra1) +26)= letra1 ]
    Retorna a cifra correspondente à alteração indicada pelo nºSegurança
    """
    for i in range(len(cifra)):
        if cifra[i].isalpha():
            if i % 2 == 0: x = 1 
            else: x = -1
            
            #Adicionar 26 a uma letra, dá uma "volta completa" e ela fica igual
            nASCII= ord(cifra[i])+ (nSegur + x) % 26
            if nASCII > 122:
                cifra= cifra[:i]+ chr(nASCII -26) +cifra[i+1:]
            
            else: cifra= cifra[:i]+ chr(nASCII) +cifra[i+1:]
        
        else: cifra= cifra[:i]+ " " +cifra[i+1:]
    return cifra

############# 4.2.4 ############  
def decifrar_bdb(listaEntradas):
    """Verificação de elementos e decriptação de cifras
    
    Verifica que cada um dos elementos da lista são entradas válidas e substitui 
    cada entrada válida pela sua cifra desencriptada de acordo com o nºSegurança 
    da mesma cifra. Retorna a lista de cifras decriptadas
    """
    if type(listaEntradas) != list:
        raise ValueError("decifrar_bdb: argumento invalido")
    
    for i in range(len(listaEntradas)):
        if not eh_entrada(listaEntradas[i]):
            raise ValueError("decifrar_bdb: argumento invalido")
        #Substitui cada entrada pela sua cifra decifrada
        listaEntradas[i]= (decifrar_texto(listaEntradas[i][0], \
        obter_num_seguranca(listaEntradas[i][2])))
        
    return listaEntradas

"""               
########################## 5. Depuração de senhas ##############################
"""
########### 5.2.1 ###########  
def eh_utilizador(dictGeral):
    """Verifica se a entrada é válida
    
    Avalia o que é introduzido perante todas as condições necessárias para que o 
    dicionário com nome, palavra passe e regra sejam válidos. Se forem, retorna 
    True, caso contrário retorna False
    """
    #Ver se é dicionário com pelo menos as três keys necessárias
    if type(dictGeral) != dict or len(dictGeral) != 3 or \
       not all(key in dictGeral for key in ("name","pass","rule")):
        return False
    
    #Ver se os valores dos items do "name" e "pass" são strings não vazios
    if type(dictGeral["name"]) != str or type(dictGeral["pass"]) != str or \
       any(value == "" for value in dictGeral.values()):
        return False
    
    #Ver se o dicionário de "rules" tem as duas keys necessárias
    if type(dictGeral["rule"]) != dict or \
       not all(key in dictGeral["rule"] for key in ("vals","char")):
        return False
    
    #Ver de o valor de "vals" é um tuplo de 2 elementos
    if type(dictGeral["rule"]["vals"]) != tuple or \
       len(dictGeral["rule"]["vals"]) != 2:
        return False
    
    #Ver se os elementos de "vals" são numeros interos positivos, com o primeiro
    # menor ou igual ao valor do segundo
    if not all(type(num) == int for num in dictGeral["rule"]["vals"]) or \
       dictGeral["rule"]["vals"][0] > dictGeral["rule"]["vals"][1] or \
       any(num <= 0 for num in dictGeral["rule"]["vals"]):
        return False
    
    #Ver se o valor de "char" é uma letra minúscula
    if not dictGeral["rule"]["char"].isalpha() or \
       not dictGeral["rule"]["char"].islower() or \
       len(dictGeral["rule"]["char"]) != 1:
        return False
    
    return True

################ 5.2.2 ################  
def eh_senha_valida(senha, dictRegras):
    """Verifica se a senha é válida
    
    Avalia se a senha (string) cumpre a regra geral, tendo, pelo menos, 3 vogais 
    e 2 ou mais letras repetidas consecutivamente e a regra individual (que vem 
    no dictRegras), a letra de dictRegras["char"] ocorrer um número de vezes 
    entre o mínimo e máximo definidos, respetivamente, pelos números inteiros em 
    dictRegras["vals"]
    Retorna True se tudo isto se verificar e False se algo não se verifica.
    """
    if type(senha) != str or type(dictRegras) != dict: return False
    
    #Verificar que senha tem pelo menos 3 vogais (1ª regra geral)
    nVogais= 0
    for car in senha:
        if car in "aeiou":
            nVogais += 1
    if nVogais < 3: return False
    
    #Se nenhuma letra for igual á seguinte, retorna falso (2ª regra geral)
    correto = False
    for i in range(len(senha) -1):
        if senha[i] == senha[i +1]:
            correto = True
    if not correto: return False
    
    nCar = senha.count(dictRegras["char"])
    if not dictRegras["vals"][0] <= nCar <= dictRegras["vals"][1]: return False
    return True

############### 5.2.3 ################ 
def filtrar_senhas(listaUtilizadores):
    """Devolve uma lista dos utilizadores com a senha errada
    
    Verifica se cada um dos dicionários introduzidos são válidos com o 
    eh_utilizador(). Depois coloca todos os nomes de utilizadores, cuja senha 
    esteja errada, numa lista e retorna essa lista por ordem alfabética
    
    """
    #Verificar que é uma lista com um ou mais elementos
    if type(listaUtilizadores) != list or len(listaUtilizadores) < 1:
        raise ValueError("filtrar_senhas: argumento invalido")
    
    #Verificar que cada elemento da lista é um dicionário válido
    lista_Utli_Errados = []
    for dicionario in listaUtilizadores:
        if not eh_utilizador(dicionario):
            raise ValueError("filtrar_senhas: argumento invalido")
        
        #Adicionar o nome dos utilizadores com senha errada a uma listas
        if not eh_senha_valida(dicionario["pass"], dicionario["rule"]):
            lista_Utli_Errados.append(dicionario["name"])
    
    lista_Utli_Errados.sort()
    return lista_Utli_Errados
