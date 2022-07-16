/* segundo projeto de IAED
 * autor: Nah, Im not telling you
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_NUM_AEROPORTOS 40	/* número máximo de areoportos */
#define MAX_NUM_VOOS 30000	/* número máximo de voos */

#define MAX_CODIGO_AEROPORTO 4	/* dimensão do código do aeroporto */
#define MAX_NOME_PAIS 31	/* dimensão do nome do pais */
#define MAX_NOME_CIDADE 51	/* dimensão do nome da cidade */

#define MAX_CODIGO_VOO 7	/* dimensão do código do voo */
#define MAX_DATA 11		/* dimensão da data */
#define MAX_HORA 6		/* dimensão da hora */

#define NAO_EXISTE -1		/* código de erro */

#define ANO_INICIO 2022		/* ano inicial do sistema */
#define DIAS_ANO 365		/* número de dias no ano */
#define HORAS_DIA 24		/* número de horas por dia */
#define MINUTOS_HORA 60		/* número de minutos numa hora */
#define MINUTOS_DIA 1440	/* número de minutos do dia */

#define TRUE 1			/* verdadeiro */
#define FALSE 0			/* falso */

#define MAX_INSTRUCAO 65535 /* dimensão máxima de cada instrução */
#define MAX_HASHTABLE 20047 /* dimensão das hashtables */

/* Tipos de Dados */

typedef struct {
	char id[MAX_CODIGO_AEROPORTO];
	char pais[MAX_NOME_PAIS];
	char cidade[MAX_NOME_CIDADE];
	int numVoos;
} Aeroporto;

typedef struct {
	int dia;
	int mes;
	int ano;
} Data;

typedef struct {
	int hora;
	int minuto;
} Hora;

typedef struct {
	char id[MAX_CODIGO_VOO];
	char partida[MAX_CODIGO_AEROPORTO];
	char chegada[MAX_CODIGO_AEROPORTO];
	Data data;
	Hora hora;
	Hora duracao;
	int capacidade;
	int horaPartida;
	int horaChegada;
	int lotacao;
	int numReservas;
} Voo;

typedef struct Reserva{
	char id[MAX_CODIGO_VOO];
	Data data;
	char *codigo;
	int numPassageiros;
	struct Reserva *next_V;
    struct Reserva *next_R;
} *link;

typedef struct global{
	link HashV[MAX_HASHTABLE];
	link HashR[MAX_HASHTABLE];
	int numR;
} Sistema;

/* Variaveis Globais */

int _numAeroportos = 0;		/* número de aeroportos introduzidos */
Aeroporto _aeroportos[MAX_NUM_AEROPORTOS];	/* vetor de aeroportos */

int _numVoos = 0		/* número de voos introduzidos */;
Voo _voos[MAX_NUM_VOOS];	/* vetor de voos */

Data _hoje = { 1, 1, 2022 };	/* data atual do sistema */

const int _diasMesAc[] =	/* dias acumulados por mês (jan=1) */
	{ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 };


/* Funcoes Leitura */

Hora leHora() {
	Hora h;
	scanf("%d:%d", &h.hora, &h.minuto);
	return h;
}


Data leData() {
	Data d;
	scanf("%d-%d-%d", &d.dia, &d.mes, &d.ano);
	return d;
}


int leProximaPalavra(char str[]) {
	char c = getchar();
	int i = 0;
	while (c == ' ' || c == '\t')
		c = getchar();
	while (c != ' ' && c != '\t' && c != '\n') {
		str[i++] = c;
		c = getchar();
	}
	str[i] = '\0';
	return (c == '\n');
}


void lePalavraAteFimDeLinha(char str[]) {
	char c = getchar();
	int i = 0;
	while (c == ' ' || c == '\t')
		c = getchar();
	while (c != '\n') {
		str[i++] = c;
		c = getchar();
	}
	str[i] = '\0';
}


void leAteFimDeLinha() {
	char c = getchar();
	while (c != '\n')
		c = getchar();
}


/* Funcoes Datas e Horas */

void mostraData(Data d) {
    printf("%02d-%02d-%d", d.dia, d.mes, d.ano);
}


void mostraHora(Hora h) {
    printf("%02d:%02d", h.hora, h.minuto);
}


int converteDataNum(Data d) {
	return (d.ano - ANO_INICIO) * DIAS_ANO + _diasMesAc[d.mes - 1] +
		d.dia - 1;
}


int converteHoraNum(Hora h) {
	return ((h.hora * MINUTOS_HORA) + h.minuto);
}


int converteDataHoraNum(Data d, Hora h) {
	return converteDataNum(d) * MINUTOS_DIA + converteHoraNum(h);
}


Hora converteNumHora(int num) {
	Hora h;
	h.minuto = num % MINUTOS_HORA;
	h.hora = ((num - h.minuto) / MINUTOS_HORA) % HORAS_DIA;
	return h;
}


Data converteNumData(int num) {
	Data d;
	int i = 0;
	num = (num - (num % MINUTOS_DIA)) / MINUTOS_DIA;
	d.ano = (num / DIAS_ANO) + ANO_INICIO;
	num = num - ((d.ano - ANO_INICIO) * DIAS_ANO);
	while (i <= 11 && num >= _diasMesAc[i])
		i++;
	d.mes = i;
	d.dia = num - _diasMesAc[i - 1] + 1;
	return d;
}


int validaData(Data d) {
	int numData = converteDataNum(d);
	Data proximoAno = _hoje;
	proximoAno.ano++;
	return !(numData < converteDataNum(_hoje)
		 || numData > converteDataNum(proximoAno));
}


int validaHora(Hora h) {
	return !(h.hora > 12 || (h.hora == 12 && h.minuto > 0));
}


/* Algoritmo de ordenação BubbleSort */

void bubbleSort(int indexes[], int size, int (*cmpFunc) (int a, int b)) {
  int i, j, done;
  
  for (i = 0; i < size-1; i++){
    done=1;
    for (j = size-1; j > i; j--) 
      if ((*cmpFunc)(indexes[j-1], indexes[j])) {
		int aux = indexes[j];
		indexes[j] = indexes[j-1];
		indexes[j-1] = aux;
		done=0;
      }
    if (done) break;
  }
}


/* Funcoes Aeroportos */


int aeroportoInvalido(char id[]) {
	int i;
	for (i = 0; id[i] != '\0'; i++)
		if (!(id[i] >= 'A' && id[i] <= 'Z'))
			return TRUE;
	return FALSE;
}


int encontraAeroporto(char id[]) {
	int i;
	for (i = 0; i < _numAeroportos; i++)
		if (!strcmp(id, _aeroportos[i].id))
			return i;
	return NAO_EXISTE;
}


void adicionaAeroporto() {
	Aeroporto a;

	leProximaPalavra(a.id);
	leProximaPalavra(a.pais);
	lePalavraAteFimDeLinha(a.cidade);

	if (aeroportoInvalido(a.id))
		printf("invalid airport ID\n");
	else if (_numAeroportos == MAX_NUM_AEROPORTOS)
		printf("too many airports\n");
	else if (encontraAeroporto(a.id) != NAO_EXISTE)
		printf("duplicate airport\n");
	else {
		strcpy(_aeroportos[_numAeroportos].id, a.id);
		strcpy(_aeroportos[_numAeroportos].pais, a.pais);
		strcpy(_aeroportos[_numAeroportos].cidade, a.cidade);
		_aeroportos[_numAeroportos].numVoos = 0;
		_numAeroportos++;
		printf("airport %s\n", a.id);
	}
}


void mostraAeroporto(int index) {
	printf("%s %s %s %d\n", _aeroportos[index].id,
	       _aeroportos[index].cidade, _aeroportos[index].pais,
	       _aeroportos[index].numVoos);
}


int cmpAeroportos(int a, int b) {
  return (strcmp(_aeroportos[a].id, _aeroportos[b].id) > 0);
}


void listaTodosAeroportos() {
	int i;
	int indexAeroportos[MAX_NUM_AEROPORTOS];

	for (i = 0; i < _numAeroportos; i++)
		indexAeroportos[i] = i;

	bubbleSort(indexAeroportos, _numAeroportos, cmpAeroportos);

	for (i = 0; i < _numAeroportos; i++)
		mostraAeroporto(indexAeroportos[i]);
}


void listaAeroportos() {
	char id[MAX_CODIGO_AEROPORTO];
	int indexAeroporto, ultima = 0;

	ultima = leProximaPalavra(id);
	if (strlen(id) == 0)
		listaTodosAeroportos();
	else {
		while (strlen(id) != 0) {
			indexAeroporto = encontraAeroporto(id);
			if (indexAeroporto == NAO_EXISTE)
				printf("%s: no such airport ID\n", id);
			else
				mostraAeroporto(indexAeroporto);
			if (!ultima)
				ultima = leProximaPalavra(id);
			else
				break;
		}
	}
}



/* Funcoes Voos */

void mostraVoo(int index) {
	printf("%s %s %s ", _voos[index].id, _voos[index].partida,
	       _voos[index].chegada);
	mostraData(_voos[index].data);
	printf(" ");
	mostraHora(_voos[index].hora);
	printf("\n");
}

void mostraVooPartida(int index) {
	printf("%s %s ", _voos[index].id, _voos[index].chegada);
	mostraData(_voos[index].data);
	printf(" ");
	mostraHora(_voos[index].hora);
	printf("\n");
}

void mostraVooChegada(int index) {
	Hora h = converteNumHora(_voos[index].horaChegada);
	printf("%s %s ", _voos[index].id, _voos[index].partida);
	mostraData(converteNumData(_voos[index].horaChegada));
	printf(" ");
	mostraHora(h);
	printf("\n");
}



int encontraVoo(char id[], Data d) {
	int numData = converteDataNum(d);
	int i;

	for (i = 0; i < _numVoos; i++)
		if (!strcmp(id, _voos[i].id)
		    && numData == converteDataNum(_voos[i].data))
			return i;
	return NAO_EXISTE;
}


int validaIDVoo(char id[]) {
	int i = 0, l = strlen(id);
	if (l < 3)
		return FALSE;
	for (i = 0; i < 2; i++)
		if (!(id[i] >= 'A' && id[i] <= 'Z'))
			return FALSE;

	while (id[i] != '\0') {
		if (!(id[i] >= '0' && id[i] <= '9'))
			return FALSE;
		i++;
	}
	return TRUE;
}

int validaVoo(Voo v) {
	if (validaIDVoo(v.id) == FALSE)
		printf("invalid flight code\n");
	else if (encontraVoo(v.id, v.data) != NAO_EXISTE)
		printf("flight already exists\n");
	else if (encontraAeroporto(v.partida) == NAO_EXISTE)
		printf("%s: no such airport ID\n", v.partida);
	else if (encontraAeroporto(v.chegada) == NAO_EXISTE)
		printf("%s: no such airport ID\n", v.chegada);
	else if (_numVoos == MAX_NUM_VOOS)
		printf("too many flihts\n");
	else if (validaData(v.data) == FALSE)
		printf("invalid date\n");
	else if (validaHora(v.duracao) == FALSE)
		printf("invalid duration\n");
	else if (v.capacidade < 10)
		printf("invalid capacity\n");
	else
		return TRUE;
	return FALSE;
}

void criaVoo(Voo v) {
	strcpy(_voos[_numVoos].id, v.id);
	strcpy(_voos[_numVoos].partida, v.partida);
	strcpy(_voos[_numVoos].chegada, v.chegada);
	_voos[_numVoos].data = v.data;
	_voos[_numVoos].hora = v.hora;
	_voos[_numVoos].duracao = v.duracao;
	_voos[_numVoos].capacidade = v.capacidade;
	_voos[_numVoos].horaPartida =
		converteDataHoraNum(_voos[_numVoos].data,
				    _voos[_numVoos].hora);
	_voos[_numVoos].horaChegada =
		_voos[_numVoos].horaPartida +
		converteHoraNum(_voos[_numVoos].duracao);
	_voos[_numVoos].lotacao = 0;
	_voos[_numVoos].numReservas = 0;
	_numVoos++;
}

void adicionaListaVoos() {
	Voo v;
	int i;

	if (leProximaPalavra(v.id)) {
		for (i = 0; i < _numVoos; i++)
			mostraVoo(i);
		return;
	} else {
		leProximaPalavra(v.partida);
		leProximaPalavra(v.chegada);
		v.data = leData();
		v.hora = leHora();
		v.duracao = leHora();
		scanf("%d", &v.capacidade);
		leAteFimDeLinha();
	}

	if (validaVoo(v))
		criaVoo(v);
}


int cmpVoosPartida(int a, int b) {
	return (_voos[a].horaPartida > _voos[b].horaPartida);
}


int cmpVoosChegada(int a, int b) {
	return (_voos[a].horaChegada > _voos[b].horaChegada);
}


void listaVoosPartida() {
	int indexVoos[MAX_NUM_VOOS], i, n = 0;
	char partida[MAX_CODIGO_AEROPORTO];

	lePalavraAteFimDeLinha(partida);

	if (encontraAeroporto(partida) == NAO_EXISTE)
		printf("%s: no such airport ID\n", partida);

	for (i = 0; i < _numVoos; i++) {
		if (!strcmp(_voos[i].partida, partida))
			indexVoos[n++] = i;
	}

	bubbleSort(indexVoos, n, cmpVoosPartida);

	for (i = 0; i < n; i++)
		mostraVooPartida(indexVoos[i]);
}


void listaVoosChegada() {
	int indexVoos[MAX_NUM_VOOS], i, n = 0;
	char chegada[MAX_CODIGO_AEROPORTO];

	lePalavraAteFimDeLinha(chegada);

	if (encontraAeroporto(chegada) == NAO_EXISTE)
		printf("%s: no such airport ID\n", chegada);

	for (i = 0; i < _numVoos; i++) {
		if (!strcmp(_voos[i].chegada, chegada))
			indexVoos[n++] = i;
	}

	bubbleSort(indexVoos, n, cmpVoosChegada);

	for (i = 0; i < n; i++)
		mostraVooChegada(indexVoos[i]);
}


void alteraData() {
	Data d;

	d = leData();
	leAteFimDeLinha();
	if (validaData(d) == FALSE)
		printf("invalid date\n");
	else {
		_hoje = d;
		mostraData(_hoje);
		printf("\n");
	}
}



/* Funcoes Reserva e Voos */

void init(Sistema *sistem){
	int i;
	for (i=0; i < MAX_HASHTABLE; i++)
		sistem->HashR[i] = sistem->HashV[i] = NULL;
	sistem->numR = 0;
}

/*
void freeRamo(Sistema *sistem, int i){
	link t = sistem->HashV[i];
	while (t != NULL){
		sistem->HashV[i] = t->next_V;
		free(t->codigo);
		free(t);
		t = sistem->HashV[i];
	}
} */
link nextV(link ptr){ return ptr->next_V; }
link nextR(link ptr){ return ptr->next_R; }

void destroy(link reserva_ptr, link (*next) (link ptr)) 
{
    if ((*next)(reserva_ptr) == NULL){
		free(reserva_ptr->codigo);
		free(reserva_ptr);
	}
    else 
    {
        destroy((*next)(reserva_ptr), (*next));
		free(reserva_ptr->codigo);
        free(reserva_ptr);
    }
    return;
}

void freeTUDO(Sistema *sistem){
	int i=0;
	for (i=0; i < MAX_HASHTABLE; i++){
		if (sistem->HashV[i] != NULL)
			destroy(sistem->HashV[i], nextV);
	}
}

void *try_malloc(Sistema *sistem, size_t size){
    void *t = malloc(size);

    if (t != NULL) return t;

    printf("No memory.\n");
    freeTUDO(sistem);
    exit(0);
	return NULL;
}



int hash_index(char* cod) {
	long int hash, a = 31415, b = 27183;

	for (hash = 0; *cod != '\0'; cod++, a = a * b % (MAX_HASHTABLE - 1)) {
		hash = (a * hash + *cod) % MAX_HASHTABLE;
	}
	return hash;
}

link NEW(Sistema *sistem, char *buffer){
	link x = (link) try_malloc(sistem, sizeof(struct Reserva));
	x->codigo = (char*) try_malloc(sistem, sizeof(char)*(strlen(buffer)+1));
	strcpy(x->codigo, buffer);
	x->next_R = x->next_V = NULL;
	return x;
}

link insereReserva(Sistema *sistem, char *codReserva, char *idVoo){
	link x = NEW(sistem, codReserva);
	x->next_V = sistem->HashV[hash_index(idVoo)];
    x->next_R = sistem->HashR[hash_index(codReserva)];
	return x;
}

link encontraReserva(Sistema *sistem, char* codigo){
    int lenght = strlen(codigo);
	link t=NULL, head=NULL;
    if (lenght < 10){
        head = sistem->HashV[hash_index(codigo)];
        for(t = head; t != NULL; t = t->next_V)
            if(strcmp(t->id, codigo) == 0)
                return t;
    }
    else{
        head = sistem->HashR[hash_index(codigo)];
        for(t = head; t != NULL; t = t->next_R)
            if(strcmp(t->codigo, codigo) == 0)
                return t;
    }  
	return NULL;
}


int validaCodigoReserva(char *buffer) {
	int i, l = strlen(buffer);
	if (l < 10)
		return FALSE;
	for (i = 0; i < l; i++)
		if (!(buffer[i] >= 'A' && buffer[i] <= 'Z') 
			&& !(buffer[i] >= '0' && buffer[i] <= '9'))
			return FALSE;

	return TRUE;
}

int validaLotacao(int index, int num){
	if (_voos[index].lotacao + num > _voos[index].capacidade)
		return FALSE;
	return TRUE;
}

int validaReserva(Sistema *sistem, char id[], Data d, char *codigo, int num){
	if (validaCodigoReserva(codigo) == FALSE)
		printf("invalid reservation code\n");
	else if (encontraVoo(id, d) == NAO_EXISTE)
		printf("%s: flight does not exist\n", id);
	else if (encontraReserva(sistem, codigo) != NULL)
		printf("%s: flight reservation already used\n", codigo);
	else if (validaLotacao(encontraVoo(id, d), num) == FALSE)
		printf("too many reservations\n");
	else if (validaData(d) == FALSE)
		printf("invalid date\n");
	else if (num <= 0)
		printf("invalid passenger number\n");
	else
		return TRUE;
	return FALSE;
}

int getPonteiros_idVoo(Sistema *sistem, link **ponteiros, char idVoo[], 
						Data d, int IndexV){
    link t=NULL;
    int count=0, dataNum = converteDataNum(d);
    link head = sistem->HashV[hash_index(idVoo)];
	*ponteiros = (link*) 
				try_malloc(sistem,sizeof(link) * (_voos[IndexV].numReservas));
    for(t=head; t != NULL; t = t->next_V)
        if (!strcmp(t->id, idVoo) && converteDataNum(t->data) == dataNum)
            (*ponteiros)[count++] = t;
    
    return count;
}
/* 
int getPonteiros_idVoo(Sistema sistem, link ponteiros[], char idVoo[], Data d, int IndexV){
    link t=NULL;
    int count=0, dataNum = converteDataNum(d);
    link head = sistem.HashV[hash_index(idVoo)];
    for(t=head; t != NULL; t = t->next_V)
        if (!strcmp(t->id, idVoo) && converteDataNum(t->data) == dataNum)
            ponteiros[count++] = t;
    
    return count;
} */


void bubbleSortPonteiros(link ponts[], int N_ponts){
  int i, j, done;
  
  for (i = 0; i < N_ponts-1; i++){
    done=1;
    for (j = N_ponts-1; j > i; j--) 
      if (strcmp(ponts[j-1]->codigo, ponts[j]->codigo) > 0){
		link aux = ponts[j];
		ponts[j] = ponts[j-1];
		ponts[j-1] = aux;
		done=0;
      }
    if (done) break;
  }
}

void printReservas(link ponts[], int N_ponts){
    int i;
    for(i=0; i < N_ponts; i++) 
        printf("%s %d\n", ponts[i]->codigo, ponts[i]->numPassageiros);
}

void adicionaListaReservas(Sistema *sistem){
	char id[MAX_CODIGO_VOO], buffer[MAX_INSTRUCAO];
	Data d;
	int num, N_ponts, IndexV;
	link *ponteiros=NULL;

	leProximaPalavra(id);
	d = leData();
		
	if(leProximaPalavra(buffer)) {
		if ((IndexV = encontraVoo(id, d)) == NAO_EXISTE)
			printf("%s: flight does not exist\n", id);
		else if (validaData(d) == FALSE)
			printf("invalid date\n");
		else{
			N_ponts = getPonteiros_idVoo(sistem, &ponteiros, id, d, IndexV);
			bubbleSortPonteiros(ponteiros, N_ponts);
			printReservas(ponteiros, N_ponts);
			free(ponteiros);
		}
		return;
	}
	scanf("%d", &num);
	leAteFimDeLinha();

	if (validaReserva(sistem, id, d, buffer, num)){
		link head = insereReserva(sistem, buffer, id);
		IndexV = encontraVoo(id, d);
        sistem->HashV[hash_index(id)] = head;
        sistem->HashR[hash_index(buffer)] = head;
		strcpy(head->id, id);
		head->data = d;
		head->numPassageiros = num;
		_voos[IndexV].lotacao += num;
		_voos[IndexV].numReservas++;
		sistem->numR++;
	}
}


void delete_Reserva_id(Sistema *sistem, char* idVoo)
{
	link t=NULL, prev=NULL, head = sistem->HashV[hash_index(idVoo)];
	char *codigo=NULL;
	for(t = head, prev = NULL; t != NULL; prev = t, t = t->next_V) {
		if(strcmp(t->id, idVoo) == 0) {
			codigo = (char*) 
					try_malloc(sistem, (strlen(t->codigo)+1)* sizeof(char));			
			strcpy(codigo, t->codigo);
			if(t == head)
				head = t->next_V;
			else
				prev->next_V = t->next_V;
			break;
		}
	}
	sistem->HashV[hash_index(idVoo)] = head;

	head = sistem->HashR[hash_index(codigo)];
	for(t = head, prev = NULL; t != NULL; prev = t, t = t->next_R) {
		if(strcmp(t->codigo, codigo) == 0) {
			if(t == head)
				head = t->next_R;
			else
				prev->next_R = t->next_R;
			break;
		}
	}
	free(t->codigo);
	free(t);
	sistem->HashR[hash_index(codigo)] = head;
	free(codigo);
	sistem->numR--;
}

int encontraVooIndex(char *idVoo){
	int i;
	for (i=0; i< _numVoos; i++)
		if(!strcmp(_voos[i].id, idVoo))
			return i;
	return NAO_EXISTE;
}


void deleteVoo(char *idVoo, int index){
	int i, j=index;
	for(i = index; i < _numVoos; i++){
		if(strcmp(_voos[i].id, idVoo))
			_voos[j++] = _voos[i];
	}
	_numVoos = j;
}

void delete_Reserva_codigo(Sistema *sistem, char* codigo)
{
	link t=NULL, prev=NULL, head = sistem->HashR[hash_index(codigo)];
	char idVoo[MAX_CODIGO_VOO];
	int IndexV;
	for(t = head, prev = NULL; t != NULL; prev = t, t = t->next_R) {
		if(strcmp(t->codigo, codigo) == 0) {
			strcpy(idVoo, t->id);
			if(t == head)
				head = t->next_R;
			else
				prev->next_R = t->next_R;
			break;
		}
	}
	IndexV = encontraVoo(idVoo, t->data);
	_voos[IndexV].lotacao -= t->numPassageiros;
	_voos[IndexV].numReservas--;

	sistem->HashR[hash_index(codigo)] = head;
	head = sistem->HashV[hash_index(idVoo)];
	for(t = head, prev = NULL; t != NULL; prev = t, t = t->next_V) {
		if(strcmp(t->codigo, codigo) == 0) {
			if(t == head)
				head = t->next_V;
			else
				prev->next_V = t->next_V;
			break;
		}
	}
	free(t->codigo);
	free(t);
	sistem->HashV[hash_index(idVoo)] = head;
	sistem->numR--;
}

void eliminaVoos_ou_Reservas(Sistema *sistem){
	char buffer[MAX_INSTRUCAO];
    int lenght, index;

	lePalavraAteFimDeLinha(buffer);
    lenght = strlen(buffer);


	if (lenght < 10){
		if ((index = encontraVooIndex(buffer)) == NAO_EXISTE){
			printf("not found\n");
			return;
		}
		deleteVoo(buffer, index);
		while(encontraReserva(sistem, buffer))
			delete_Reserva_id(sistem, buffer);
	}
	else{
		if(encontraReserva(sistem, buffer) == NULL){
			printf("not found\n");
			return;
		}
		delete_Reserva_codigo(sistem, buffer);
	}
}



int main() {
	int c;
	struct global sistem;
	init(&sistem);

	while ((c = getchar()) != EOF) {
		switch (c) {
		case 'q': freeTUDO(&sistem); 
			return 0;
		case 'a': adicionaAeroporto();
			break;
		case 'l': listaAeroportos();
			break;
		case 'v': adicionaListaVoos();
			break;
		case 'p': listaVoosPartida();
			break;
		case 'c': listaVoosChegada();
			break;
		case 't': alteraData();
			break;
		case 'r': adicionaListaReservas(&sistem);
			break;
		case 'e': eliminaVoos_ou_Reservas(&sistem);
			break;
		default: printf("Invalid comand: %c\n", c);
		}
	}
	return 0;
}