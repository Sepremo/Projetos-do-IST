"""Projeto nº2_O Prado 
O projeto é constituido por 3 TADs e 2 funções adicionais:

    #TAD posição: Representa uma posição (x, y) de um prado arbitrariamente 
grande, sendo x e y dois valores inteiros não negativos.

    #TAD animal: Representa os animais do simulador de ecossistemas que habitam 
o prado, existindo de dois tipos: predadores e presas. Os predadores são 
caracterizados pela espécie, idade, frequência de reprodução, fome e 
frequência de alimentação. As presas são apenas caracterizadas pela espécie, 
idade e frequência de reprodução.

    #TAD prado: usado para representar o mapa do ecossistema e as animais que se
encontram dentro.

    #Função geracao: função auxiliar que modifica o prado fornecido como 
argumento de acordo com a evolução correspondente a uma geração completa, e 
devolve o próprio prado.

    #Funçao simula_ecossistema: Função principal que permite simular o 
ecossistema de um prado.

Miguel Fernandes _ nº estudante: 103573 _ Data da última alteração: 18/11/2021
email: miguel.e.fernandes@tecnico.ulisboa.pt

############################# 2.1.1  TAD posição ###############################
"""
#R[x, y] = (x, y)
#cria_posicao: int X int -> posicao
#cria_copia_posicao: posicao -> posicao
#obter_pos_x: posicao -> int
#obter_pos_y: posicao -> int
#eh_posicao: universal -> booleano
#posicoes_iguais: posicao X posicao -> booleano
#posicao_para_str: posicao -> str

#Construtor
def cria_posicao(x, y):
    """cria_posicao: int X int -> posicao
    
    Recebe os valores correspondentes às coordenadas de uma posição e devolve 
    a posição correspondente.
    O construtor verifica a validade dos seus argumentos, gerando um ValueError 
    com a mensagem ‘cria_posicao: argumentos invalidos’ caso os seus argumentos 
    não sejam válidos.
    R[x, y] = (x, y)
    """
    if type(x) != int or type(y) != int or x < 0 or y < 0:
        raise ValueError("cria_posicao: argumentos invalidos")
    return (x, y)

def cria_copia_posicao(posicao):
    """cria_copia_posicao: posicao -> posicao

    Recebe uma posição e devolve uma cópia nova da posição
    """
    return (posicao[0], posicao[1])

#Seletores
def obter_pos_x(posicao):
    """obter_pos_x: posicao -> int

    Recebe uma posição e devolve a componente x da posição.
    """
    return posicao[0]

def obter_pos_y(posicao):
    """obter_pos_y: posicao -> int

    Recebe uma posição e devolve a componente y da posição.
    """
    return posicao[1]

#Reconhecedor
def eh_posicao(x):
    """eh_posicao: universal -> booleano

    Recebe um argumento qualquer e devolve True caso esse argumento seja um 
    TAD posicao e False caso contrário.
    """
    if type(x) == tuple and len(x) == 2:
        x_pos, y_pos = x[0], x[1]
        if type(x_pos) == int and type(y_pos) == int and x_pos >= 0 and y_pos >= 0:
            return True
        
    return False

#Teste
def posicoes_iguais(pos1, pos2):
    """posicoes_iguais: posicao X posicao -> booleano

    Recebe duas posições e devolve True apenas se são ambas posições TAD e são 
    iguais.
    """
    return pos1 == pos2

#Transformador
def posicao_para_str(pos):
    """posicao_para_str: posicao -> str

    Recebe uma posição e devolve a cadeia de caracteres '(x, y)' que representa 
    o seu argumento, sendo os valores x e y as coordenadas da posição.
    """
    return "(" + str(obter_pos_x(pos)) + ", " + str(obter_pos_y(pos)) + ")"


#Funções de alto nível
def obter_posicoes_adjacentes(pos):
    """obter_posicoes_adjacentes: posicao -> tuplo

    Recebe uma posição e devolve um tuplo com as posições adjacentes à posição, 
    começando pela posição acima da posiçao recebido e seguindo no sentido horário.
    """
    x, y = obter_pos_x(pos), obter_pos_y(pos)
    coordenadas = ((x,y -1), (x +1,y), (x, y +1), (x -1, y))
    adjacentes = ()
    for cords in coordenadas:
        if cords[0] >= 0 and cords[1] >= 0:
            adjacentes += (cria_posicao(cords[0], cords[1]), )
   
    return adjacentes

def ordenar_posicoes(tuplo_pos):
    """ordenar_posicoes: tuplo -> tuplo

    Recebe um tuplo de posições e devolve um tuplo contendo as mesmas posições 
    do tuplo fornecido como argumento, ordenadas de acordo com a ordem de 
    leitura do prado.
    """
    return tuple(sorted(tuplo_pos , key=lambda k: [obter_pos_y(k), obter_pos_x(k)]))

#Função auxiliar de avaliação
def posicao_em_tuplo(posicao, tuplo_pos):
    """posicao_em_tuplo: posicao X tuplo -> booleano

    Função auxiliar
    Recebe uma posição e um tuplo de posições e devolve True apenas se a posição 
    estiver no tuplo.
    """
    return any([posicoes_iguais(posicao, pos) for pos in tuplo_pos])

"""
############################# 2.1.2  TAD animal ################################    
"""
#R[especie, freq_reprod, freq_alim] =
#{"especie": especie, "Reproducao": [int, freq_reprod], "Alimentacao": [int, freq_alim]}
#cria_animal: str X int X int -> animal
#cria_copia_animal: animal -> animal
#obter_especie: animal -> str
#obter_freq_reproducao: animal -> int
#obter_freq_alimentacao: animal -> int
#obter_idade: animal -> int
#obter_fome: animal -> int
#aumenta_idade: animal -> animal
#reset_idade: animal -> animal
#aumenta_fome: animal -> animal
#reset_fome: animal -> animal
#eh_animal: universal -> booleano
#eh_predador: universal -> booleano
#eh_presa: universal -> booleano
#animais_iguais: animal X animal -> booleano
#animal_para_char: animal -> str
#animal_para_str: animal -> str

#Construtor
def cria_animal(especie, freq_reprod, freq_alim):
    """cria_animal: str X int X int -> animal

    Recebe uma cadeia de caracteres especie não vazia correspondente à espécie do 
    animal e dois valores inteiros correspondentes á frequência de reprodução 
    freq_reprod (maior do que 0) e à frequência de alimentação freq_alim (maior 
    ou igual que 0); e devolve o animal. Animais com frequência de alimentação 
    maior que 0 são considerados predadores, caso contrário são considerados presas.
    O construtor verifica a validade dos seus argumentos, gerando um ValueError 
    com a mensagem 'cria_animal: argumentos invalidos' caso os seus argumentos 
    não sejam válidos.
    R[especie, freq_reprod, freq_alim] =
    {"especie": especie, "Reproducao": [int, freq_reprod], "Alimentacao": [int, freq_alim]}
    """
    if type(especie) != str or len(especie) == 0 or type(freq_reprod) != int or \
    type(freq_alim) != int or freq_reprod <= 0 or freq_alim < 0:
        raise ValueError("cria_animal: argumentos invalidos")

    return {"especie": especie, "Reproducao": [0, freq_reprod], "Alimentacao": [0, freq_alim]}

def cria_copia_animal(animal):
    """cria_copia_animal: animal -> animal

    Recebe um animal e devolve uma nova cópia do animal.
    """
    animal_copia = {}
    animal_copia["especie"] = animal["especie"]
    animal_copia["Reproducao"] = animal["Reproducao"].copy()
    animal_copia["Alimentacao"] = animal["Alimentacao"].copy()
    return animal_copia

#Seletores
def obter_especie(animal):
    """obter_especie: animal -> str

    Recebe um animal e devolve a cadeia de caracteres 
    correspondente à espécie do animal.
    """
    return animal["especie"]

def obter_freq_reproducao(animal):
    """obter_freq_reproducao: animal -> int

    Recebe um animal e devolve a frequência de reprodução do animal.
    """
    return animal["Reproducao"][1]

def obter_freq_alimentacao(animal):
    """obter_freq_alimentacao: animal -> int

    Recebe um animal e devolve a frequência de alimentação do animal (as presas 
    devolvem sempre 0).
    """
    return animal["Alimentacao"][1]

def obter_idade(animal):
    """obter_idade: animal -> int

    Recebe um animal e devolve a idade do animal.
    """
    return animal["Reproducao"][0]

def obter_fome(animal):
    """obter_fome: animal -> int

    Recebe um animal e devolve a fome do animal (as presas devolvem sempre 0).
    """
    return animal["Alimentacao"][0]

#Modificadores
def aumenta_idade(animal):
    """aumenta_idade: animal -> animal

    Recebe um animal e modifica destrutivamente o animal a incrementando o valor 
    da sua idade em uma unidade, e devolve o próprio animal.
    """
    animal["Reproducao"][0] += 1
    return animal

def reset_idade(animal):
    """reset_idade: animal -> animal

    Recebe um animal e modifica destrutivamente o animal a definindo o valor da 
    sua idade igual a 0, e devolve o próprio animal.
    """
    animal["Reproducao"][0] = 0
    return animal

def aumenta_fome(animal):
    """aumenta_fome: animal -> animal

    Recebe um animal e modifica destrutivamente o animal predador incrementando 
    o valor da sua fome em uma unidade, e devolve o próprio animal. Esta 
    operação não modifica os animais presa.
    """
    if eh_predador(animal):
        animal["Alimentacao"][0] += 1
    return animal    
    
def reset_fome(animal):
    """reset_fome: animal -> animal

    Recebe um animal e modifica destrutivamente o animal predador definindo o 
    valor da sua fome igual a 0, e devolve o próprio animal. Esta operaçãao não 
    modifica os animais presa.
    """
    animal["Alimentacao"][0] = 0
    return animal    

#Reconhecedor
def eh_animal(x):
    """eh_animal: universal -> booleano

    Recebe um argumento e devolve True caso o seu argumento seja um TAD animal e
    False caso contrário. Verificando se é um dicionário com três elementos em 
    que as chaves são 'especie', 'Reproducao' e 'Alimentacao' associadas aos 
    valores, respetivamente, string, lista de duas int e outra lista de duas int.
    """
    if type(x) != dict or len(x) != 3 or \
    not all(key in ("especie", "Reproducao", "Alimentacao") for key in x) or \
    type(x["especie"]) != str or len(x["especie"]) == 0 or \
    type(x["Reproducao"]) != list or type(x["Alimentacao"]) != list:
        return False
    
    Seletores = (obter_idade, obter_freq_reproducao, obter_fome, obter_freq_alimentacao)
    if any(type(seletor(x)) != int for seletor in Seletores) :
        return False
    if obter_idade(x) < 0 or obter_freq_reproducao(x) <= 0 or \
    obter_fome(x) < 0 or obter_freq_alimentacao(x) < 0:
        return False
     
    return True

def eh_predador(x):
    """eh_predador: universal -> booleano

    Recebe um argumento e devolve True caso o seu argumento seja um TAD animal do
    tipo predador e False caso contrário. Para verificar que é predador vê se a 
    frequência de alimentação é diferente de 0.
    """
    if not eh_animal(x) or obter_freq_alimentacao(x) == 0:
        return False 
    return True

def eh_presa(x):
    """eh_presa: universal -> booleano

    Recebe um argumento e devolve True caso o seu argumento seja um TAD animal do
    tipo presa e False caso contrário. Para verificar que é presa vê se a 
    frequência de alimentação é igual a 0.
    """
    if not eh_animal(x) or obter_freq_alimentacao(x) != 0:
        return False
    return True

#Teste
def animais_iguais(animal1, animal2):
    """animais_iguais: animal X animal -> booleano

    Recebe dois animais e devolve True apenas se são animais e são iguais.
    """
    if not eh_animal(animal1) or not eh_animal(animal2) or animal1 != animal2:
        return False
    return True

#Transformadores
def animal_para_char(animal):
    """animal_para_char: animal -> str

    Recebe um animal e devolve a cadeia de caracteres dum único elemento 
    correspondente ao primeiro carácter da espécie do animal passada por 
    argumento, em maiúscula para animais predadores e em minúscula para 
    animais presa.
    """
    if obter_freq_alimentacao(animal) == 0:
        return obter_especie(animal)[0].lower()
    else:
        return obter_especie(animal)[0].upper()
    
def animal_para_str(animal):
    """animal_para_str: animal -> str

    Recebe um animal e devolve a cadeia de caracteres que representa o animal
    como mostrado nos exemplos a seguir.
    'fox [0/20;0/10]'
    """
    s = obter_especie(animal)
    i, r = obter_idade(animal), obter_freq_reproducao(animal)
    f, a = obter_fome(animal), obter_freq_alimentacao(animal)
    if a == 0:
        return str(s) +" ["+ str(i) +"/"+ str(r) +"]"
    else:
        return str(s) +" ["+ str(i) +"/"+ str(r) +";"+ str(f) +"/"+ str(a) +"]"

#Funções de alto nível
def eh_animal_fertil(animal):
    """eh_animal_fertil: animal -> booleano

    Recebe um animal e devolve True caso o animal a tenha atingido a idade de 
    reprodução e False caso contrário. Verificando que a idade do animal é maior 
    ou igual á sua frequência de operação.
    """
    idade, freq_reprod = obter_idade(animal), obter_freq_reproducao(animal)
    return idade >= freq_reprod

def eh_animal_faminto(animal):
    """eh_animal_faminto: animal -> booleano

    Recebe um animal e devolve True caso o animal a tenha atingindo um valor de
    fome igual ou superior à sua frequência de alimentação e False caso contrário. 
    As presas devolvem sempre False. Verificando se a frequência de alimentação 
    do animal é diferente de 0 e menor ou igual á idade do animal.
    """
    fome, freq_alimentacao = obter_fome(animal), obter_freq_alimentacao(animal)
    if freq_alimentacao == 0 or fome < freq_alimentacao:
        return False
    return True

def reproduz_animal(animal_pai):
    """reproduz_animal: animal -> animal

    Recebe um animal e recebe um animal devolvendo um novo animal da mesma
    espécie com idade e fome igual a 0, e modificando destrutivamente o animal 
    passado como argumento alterando a sua idade para 0.
    """
    animal_pai = reset_idade(animal_pai)
    animal_filho = cria_copia_animal(animal_pai)
    animal_filho = reset_fome(animal_filho)
    return animal_filho
"""
############################# 2.1.3  TAD prado #################################    
"""
#R[canto, rochas_pos, animais, animais_pos] =
#{"canto": canto, "rochas_pos": rochas_pos, "animais": animais, "animais_pos": animais_pos}
#cria_prado: posicao X tuplo X tuplo X tuplo -> prado
#cria_copia_prado: prado -> prado
#obter_tamanho_x: prado -> int
#obter_tamanho_y: prado -> int
#obter_numero_predadores: prado -> int
#obter_numero_presas: prado -> int
#obter_posicao_animais: prado -> tuplo posicoes
#obter_animal: prado X posicao -> animal
#eliminar_animal: prado X posicao -> prado
#mover_animal: prado X posicao X posicao -> prado
#inserir_animal: prado X animal X posicao -> prado
#eh_prado: universal -> booleano
#eh_posicao_animal: prado X posicao -> booleano
#eh_posicao_obstaculo: prado X posicao -> booleano
#eh_posicao_livre: prado X posicao -> booleano
#prados_iguais: prado X prado -> booleano
#prado_para_str: prado -> str

#Construtor
def cria_prado(canto, rochas_pos, animais, animais_pos):
    """cria_prado: posicao X tuplo X tuplo X tuplo -> prado

    Recebe uma posição correspondente à posição que ocupa a montanha do canto 
    inferior direito do prado, um tuplo de 0 ou mais posições correspondentes 
    aos rochedos que não são as montanhas dos limites exteriores do prado, um 
    tuplo de 1 ou mais animais, e um tuplo da mesma dimensão do tuplo a com 
    as posições correspondentes ocupadas pelos animais; e devolve o prado que 
    representa internamente o mapa e os animais presentes.
    O construtor verifica a validade dos seus argumentos, gerando um ValueError 
    com a mensagem 'cria_prado: argumentos invalidos' caso os seus argumentos 
    não sejam válidos.
    R[canto, rochas_pos, animais, animais_pos] =
    {"canto": canto, "rochas_pos": rochas_pos, "animais": animais, "animais_pos": animais_pos}
    """
    if not eh_posicao(canto) or type(rochas_pos) != tuple or type(animais) != tuple or \
    type(animais_pos) != tuple or len(animais) == 0 or len(animais) != len(animais_pos) \
    or not all(eh_posicao(pos) for pos in rochas_pos) or \
    not all(eh_animal(animal) for animal in animais) or \
    not all(eh_posicao(pos) for pos in animais_pos):
        raise ValueError("cria_prado: argumentos invalidos")

    x_canto, y_canto = obter_pos_x(canto), obter_pos_y(canto)
    if not all(0 < obter_pos_x(pos) < x_canto for pos in rochas_pos) or \
    not all(0 < obter_pos_y(pos) < y_canto for pos in rochas_pos) or \
    not all(0 < obter_pos_x(pos) < x_canto for pos in animais_pos) or \
    not all(0 < obter_pos_y(pos) < y_canto for pos in animais_pos) or \
    any(posicao_em_tuplo(pos, rochas_pos) for pos in animais_pos):
        raise ValueError("cria_prado: argumentos invalidos")
    
    return {"canto": canto, "rochas_pos": rochas_pos, "animais": animais, "animais_pos": animais_pos}
    
def cria_copia_prado(prado):
    """cria_copia_prado: prado -> prado

    Recebe um prado e devolve uma nova cópia do prado.
    """
    prado_copia = dict(prado)
    tuplo_animais = ()

    for animal in prado_copia["animais"]:
        tuplo_animais += (cria_copia_animal(animal), )
    prado_copia["animais"] = tuplo_animais
    
    return prado_copia

#Seletores
def obter_tamanho_x(prado):
    """obter_tamanho_x: prado -> int

    Recebe um prado e devolve o valor inteiro que corresponde à dimensão Nx do 
    prado.
    """
    return obter_pos_x(prado["canto"]) +1

def obter_tamanho_y(prado):
    """obter_tamanho_y: prado -> int

    Recebe um prado e devolve o valor inteiro que corresponde à dimensão Ny do 
    prado.
    """
    return obter_pos_y(prado["canto"]) +1

def obter_numero_predadores(prado):
    """obter_numero_predadores: prado -> int

    Recebe um prado e devolve o número de animais predadores no prado.
    """
    n_predadores = 0
    for animal in prado["animais"]:
        if eh_predador(animal):
            n_predadores += 1
     
    return n_predadores
    
def obter_numero_presas(prado):
    """obter_numero_presas: prado -> int

    Recebe um prado e devolve o número de animais presa no prado.
    """
    n_presas = 0
    for animal in prado["animais"]:
        if eh_presa(animal):
            n_presas += 1
     
    return n_presas   

def obter_posicao_animais(prado):
    """obter_posicao_animais: prado -> tuplo posicoes

    Recebe um prado e devolve um tuplo contendo as posições do prado ocupadas 
    por animais, ordenadas em ordem de leitura do prado.
    """
    return ordenar_posicoes(prado["animais_pos"])

def obter_animal(prado, pos):
    """obter_animal: prado X posicao -> animal

    Recebe um prado e uma posição e devolve o animal do prado que se encontra 
    nessa posição.
    """
    for i in range(len(prado["animais_pos"])):
        if posicoes_iguais(prado["animais_pos"][i], pos):
            return prado["animais"][i]
    
#Modificadores
def eliminar_animal(prado, posicao):
    """eliminar_animal: prado X posicao -> prado

    Recebe um prado e uma posição e modifica destrutivamente o prado eliminando 
    o animal da posição deixando-a livre. Devolve o próprio prado.

    """
    #Encontra o index da posição do animal a apagar
    for i1 in range(len(prado["animais_pos"])):
        if posicoes_iguais(prado["animais_pos"][i1], posicao):
            i = i1
            break
    prado["animais_pos"] = prado["animais_pos"][:i] + prado["animais_pos"][i +1:]
    prado["animais"] = prado["animais"][:i] + prado["animais"][i +1:]
    return prado

def mover_animal(prado, posicao1, posicao2):
    """mover_animal: prado X posicao X posicao -> prado

    Recebe um prado e duas posições e modifica destrutivamente o prado 
    movimentando o animal da posição posicao1 para a nova posição posicao2, 
    deixando livre a posição onde se encontrava. Devolve o próprio prado.
    """
    for i in range(len(prado["animais_pos"])):
        if posicoes_iguais(prado["animais_pos"][i], posicao1):
            prado["animais_pos"] = prado["animais_pos"][:i] + (posicao2, ) + \
                           prado["animais_pos"][i +1:]
            break
    return prado

def inserir_animal(prado, animal, posicao):
    """inserir_animal: prado X animal X posicao -> prado

    Recebe um prado, um animal e uma posição e modifica destrutivamente o prado 
    acrescentando nessa posição do prado o animal passado com argumento. 
    Devolve o próprio prado.
    """
    prado["animais"] += (animal, )
    prado["animais_pos"] += (posicao, )
    return prado

#Reconhecedores
def eh_prado(x):
    """eh_prado: universal -> booleano

    Recebe um prado e devolve True caso o seu argumento seja um TAD prado e 
    False caso contrário. Verificando se é um dicionário com quatro elementos em 
    que as chaves são 'canto', 'rochas_pos', 'animais' e 'animais_pos' associadas 
    aos valores, respetivamente, posição, tuplo de posições, tuplo de animais e 
    tuplo de posições desses animais.
    Também verifica que não há posições comuns entre o tuplo de posições das 
    rochas e dos animais.
    """
    keys_corretas = ("canto", "rochas_pos", "animais", "animais_pos")
    if type(x) != dict or len(x) != 4 or not all(key in keys_corretas for key in x) \
    or not eh_posicao(x["canto"]) or \
    any(type(m) != tuple for m in (x["rochas_pos"], x["animais"], x["animais_pos"])) \
    or len(x["animais"]) == 0 or len(x["animais"]) != len(x["animais_pos"]) or \
    not all(eh_posicao(pos) for pos in x["rochas_pos"]) or \
    not all(eh_animal(animal) for animal in x["animais"]) or \
    not all(eh_posicao(pos) for pos in x["animais_pos"]):
        return False

    x_canto, y_canto = (obter_tamanho_x(x) -1), (obter_tamanho_y(x) -1)
    if not all(0 < obter_pos_x(pos) < x_canto for pos in x["rochas_pos"]) or \
    not all(0 < obter_pos_y(pos) < y_canto for pos in x["rochas_pos"]) or \
    not all(0 < obter_pos_x(pos) < x_canto for pos in x["animais_pos"]) or \
    not all(0 < obter_pos_y(pos) < y_canto for pos in x["animais_pos"]) or \
    any(posicao_em_tuplo(pos, x["rochas_pos"]) for pos in x["animais_pos"]):
        return False

    return True

def eh_posicao_animal(prado, posicao):
    """eh_posicao_animal: prado X posicao -> booleano

    Recebe um prado e uma posição e devolve True apenas no caso da posição do 
    prado estar ocupada por um animal.
    """
    for pos in obter_posicao_animais(prado):
        if posicoes_iguais(pos, posicao):
            return True

    return False

def eh_posicao_obstaculo(prado, pos):
    """eh_posicao_obstaculo: prado X posicao -> booleano

    Recebe um prado e uma posição e devolve True apenas no caso da posição do 
    prado corresponder a uma montanha ou rochedo.
    """
    x_pos, y_pos = obter_pos_x(pos), obter_pos_y(pos)
    x_canto, y_canto = (obter_tamanho_x(prado) -1), (obter_tamanho_y(prado) -1)
    if x_pos in (0, x_canto) or y_pos in (0, y_canto) or posicao_em_tuplo(pos, prado["rochas_pos"]):
        return True
    return False

def eh_posicao_livre(prado, pos):
    """eh_posicao_livre: prado X posicao -> booleano

    Recebe um prado e uma posição e devolve True apenas no caso da posição do 
    prado corresponder a um espaço livre (sem animais, nem obstáculos).
    """
    if eh_posicao_obstaculo(prado, pos) or eh_posicao_animal(prado, pos):
        return False
    return True

#Teste
def prados_iguais(prado1, prado2):
    """prados_iguais: prado X prado -> booleano

    Recebe dois prados e devolve True apenas se forem prados e forem iguais.
    """
    if not eh_prado(prado1) or not eh_prado(prado2):
        return False
    return prado1["canto"] == prado2["canto"] and prado1["rochas_pos"] == prado2["rochas_pos"] \
    and prado1["animais"] == prado2["animais"] and prado1["animais_pos"] == prado2["animais_pos"]

#Transformador
def prado_para_str(prado):
    """prado_para_str: prado -> str

    Recebe um prados e devolve uma cadeia de caracteres que representa o prado
    como mostrado no exemplo:
    +----------+
    |....rL...r|
    |...@@.r...|
    |..........|
    +----------+
    '+', '-' e'|' representam monhanhas
    '@' representam rochas
    'r' e 'L' representam, respetivamente, presas e predadores
    '.' representam espaços livres
    """
    x_canto, y_canto = (obter_tamanho_x(prado) -1), (obter_tamanho_y(prado) -1)
    linhas_limite = "+" + "-" * (x_canto -1) + "+"
    linhas_meio = ""
     
    for y_atual in range(1, y_canto):
        linhas_meio += "|"
        for x_atual in range(1, x_canto):
            
            pos_atual = cria_posicao(x_atual, y_atual)
            if eh_posicao_obstaculo(prado, pos_atual): #Se é rocha
                linhas_meio += "@"
                
            elif posicao_em_tuplo(pos_atual, prado["animais_pos"]): #Se é animal
                linhas_meio += animal_para_char(obter_animal(prado, pos_atual))

            else: #Se não é rocha nem animal, está vazio
                linhas_meio += "."
         
        linhas_meio += "|\n"
    
    return linhas_limite + "\n" + linhas_meio + linhas_limite

#Funções de alto nível
def obter_valor_numerico(prado, posicao):
    """obter_valor_numerico: prado X posicao -> int

    Recebe um prado e uma posição e devolve o valor numérico da posição 
    correspondente à ordem de leitura no prado, calculado assim:
    valor numérico = coordenada y da posição * número total de colunas do prado 
    + coordenada x da posição
    """
    n_colunas = obter_tamanho_x(prado)
    x_pos, y_pos = obter_pos_x(posicao), obter_pos_y(posicao)
    index_leitura = y_pos * n_colunas + x_pos
    return index_leitura

def obter_movimento(prado, posicao):
    """obter_movimento: prado X posicao -> posicao

    Recebe um prado e uma posição e devolve a posição seguinte do animal na 
    posição recebida dentro do prado de acordo com as regras de movimento dos 
    animais no prado.
    """
    pos_pra_mover = obter_posicoes_adjacentes(posicao)
    animal = obter_animal(prado, posicao)
    if eh_predador(animal) and \
    any(eh_presa(obter_animal(prado, pos)) for pos in pos_pra_mover if eh_posicao_animal(prado, pos)):
        pos_pra_mover = tuple(filter(lambda pos: eh_presa(obter_animal(prado, pos)), pos_pra_mover))
    else:
        pos_pra_mover = tuple(filter(lambda pos: eh_posicao_livre(prado, pos), pos_pra_mover))
    
    if pos_pra_mover == ():#Se não há uma posição pra onde mover, fica parado
        return posicao

    valor_pos_inicial = obter_valor_numerico(prado, posicao)    
    index_pos_alvo = valor_pos_inicial % len(pos_pra_mover)
    return pos_pra_mover[index_pos_alvo]
"""
########################## 2.2 Funções adicionais ##############################    
"""
def geracao(prado):
    """geracao: prado -> prado

    Função auxiliar que modifica o prado fornecido como argumento de acordo com 
    a evolução correspondente a uma geração completa, e devolve o próprio prado. 
    Isto é, seguindo a ordem de leitura do prado, cada animal (vivo) realiza o 
    seu turno de açãoo de acordo com as regras:
    1) Começa por aumentar a idade do animal e a fome(este só se for predador).
    2) Move o animal e, caso o animal mova para uma posição com uma presa (é 
    predador), o animal nessa posição é eliminado e o animal a mover faz reset à 
    sua fome.
    3) Depois, se o animal atingiu a idade de reprodução e ter-se movido, deixa na 
    sua posição anterior uma cópia sua com fome 0.
    4) No final, se o animal estiver faminto é eliminado.
    """
    animais_pos_ordenadas = obter_posicao_animais(prado)
    animais_pos_mortos = ()
    
    for posicao_inicial in animais_pos_ordenadas:
        #Verifico que o animal não foi morto para não o tentar mover 'mortos'
        if eh_posicao_animal(prado, posicao_inicial) \
        and not posicao_em_tuplo(posicao_inicial, animais_pos_mortos):
            
            animal = obter_animal(prado, posicao_inicial)
            animal = aumenta_idade(animal)
            animal = aumenta_fome(animal)

            posicao_final = obter_movimento(prado, posicao_inicial)
            if not posicoes_iguais(posicao_inicial, posicao_final):
                if eh_posicao_animal(prado, posicao_final):
                    prado = eliminar_animal(prado, posicao_final)
                    animais_pos_mortos += (posicao_final, )
                    animal = reset_fome(animal)

                prado = mover_animal(prado, posicao_inicial, posicao_final)
                
                if eh_animal_fertil(animal):
                    inserir_animal(prado, reproduz_animal(animal), posicao_inicial)
                    animal = reset_idade(animal)
            
            if eh_animal_faminto(animal):
                eliminar_animal(prado, posicao_final)
    return prado

def simula_ecossistema(ficheiro, n_geracoes, modo):
    """simula_ecossistema: str X int X booleano -> tuplo

    Função principal que permite simular o ecossistema de um prado. 
    A função recebe uma cadeia de caracteres, um valor inteiro e um valor booleano 
    e devolve o tuplo de dois elementos correspondentes ao número de predadores 
    e presas no prado no fim da simulação. A cadeia de caracteres passada por 
    argumento corresponde ao nome do ficheiro de configuração da simulação. O 
    valor inteiro corresponde ao número de gerações a simular. O argumento 
    booleano ativa o modo verboso (True) ou o modo quiet (False). No modo quiet 
    mostra-se pela saída standard o prado, o número de animais e o número de 
    geração no início da simulação e após a última geração. No modo verboso, após 
    cada geração, mostra-se também o prado, o número de animais e o número de 
    geração, apenas se o número de animais predadores ou presas se tiver alterado. 
    """
    def info_para_str(prado, n_geracao):
        """info_para_str: prado X int 

        Função auxiliar que faz a saída do prado, do número de animais e do 
        número de geração.
        A função recebe um prado e um inteiro e não devolve valor. Faz print do 
        prado em string e de uma linha de string com o número de predadores, 
        número de presas e o número da geração. 
        """
        n_preds = str(obter_numero_predadores(prado))
        n_presas = str(obter_numero_presas(prado))
        n_geracao = str(n_geracao)
        print("Predadores:", n_preds, "vs Presas:", n_presas, "(Gen.", n_geracao +")")
        print(prado_para_str(prado))

    f = open(ficheiro, "r")
    linhas_f = f.readlines()
    f.close()
    linhas_f = [eval(string) for string in linhas_f]

    canto = cria_posicao(linhas_f[0][0], linhas_f[0][1])
    rochas_pos = tuple([cria_posicao(tuplo[0], tuplo[1]) for tuplo in linhas_f[1]])
    animais = tuple([cria_animal(linha[0], linha[1], linha[2]) for linha in linhas_f[2:]])
    animais_pos = tuple([cria_posicao(linha[3][0], linha[3][1]) for linha in linhas_f[2:]])

    prado = cria_prado(canto, rochas_pos, animais, animais_pos)
    info_para_str(prado, 0)
    if modo:
        for ger in range(1, n_geracoes +1):
            pred1, pres1 = obter_numero_predadores(prado), obter_numero_presas(prado)
            prado = geracao(prado)
            pred2, pres2 = obter_numero_predadores(prado), obter_numero_presas(prado)
            if pred1 != pred2 or pres1 != pres2:
                info_para_str(prado, ger)
    else:
        for ger in range(1, n_geracoes +1):
            prado = geracao(prado)
        info_para_str(prado, n_geracoes)

    n_preds, n_presas = obter_numero_predadores(prado), obter_numero_presas(prado)
    return (n_preds, n_presas)

print(simula_ecossistema("test208.txt", 40, True))