## Conferences API

DESCRIÇÃO DO PROJETO
Você está planejando uma grande conferência de programação e recebeu diversas propostas de
palestras, mas você está com problemas para organizá-las de acordo com as restrições de tempo
do dia. Então, você decide escrever um programa para fazer isso por você.

FUNCIONALIDADES
1.
Criar um cadastro das palestras, sendo uma estrutura de CRUD (Create, Read, Update
e Delete) em um banco de dados.
2.
Criar uma API REST com um endpoint que receba um arquivo contendo uma listagem de
palestras e seus respectivos tempos de duração (Dados de Entrada existentes no final
desse arquivo).
3.
O endpoint criado deve organizar a listagem de palestras recebidas de acordo com as
seguintes regras:

- A conferência tem várias tracks, cada qual tendo uma sessão pela manhã e outra
pela tarde.
- Cada sessão contém várias palestras.
- Sessões pela manhã começam às 9h e devem terminar às 12h, para o almoço.
- Sessões pela tarde começam às 13h e devem terminar a tempo de realizar o evento de networking.
- O evento de networking deve começar entre 16h e 17h.
- Nenhum dos nomes das palestras possui números.
- A duração de todas as palestras são fornecidas em minutos ou definidas como lightning (palestras de 5 minutos).

Os palestrantes serão bastante pontuais, então não há a necessidade de
intervalos entre as palestras.
4.
Criar uma aplicação simples de frontend utilizando Ruby on Rails, mas podendo ser
também em Vue.js, onde o usuário possa cadastrar, alterar, remover as palestras ou
fazer o upload de um arquivo e submetê-lo para o endpoint descrito no ponto
anterior. A resposta do endpoint deve ser usada para exibir a programação do evento.

### Pré-requisitos

- Ruby 3.0.2
- Rails 7.x

### Setup de Desenvolvimento Local

```
    bundle install
```

Estruturar o banco
```
     rails db:migrate
```

Para criar banco
```
      rails db:drop db:create db:migrate
```
Para criar rodar os testes
```
     rspec
```
Subir o servidor 
```
     rails s 
```
Agora a API deve estar disponível em `http://localhost:3000/`.
### Setup de Desenvolvimento Docker

Utilizando Docker e Docker Compose:

```sh
cd api_de_palestras
	ARG_USER_UID=$(id -u) ARG_USER_GID=$(id -g) docker compose config
  ARG_USER_UID=$(id -u) ARG_USER_GID=$(id -g) docker compose build
  docker compose up -d
  docker compose exec app bash
    bundle
    rails db:drop db:create db:migrate
		rspec
    rails s
    # Brower: http://localhost:3000
    # Press: CTRL+C
    exit
  docker compose down
```

### Como Rodar o Projeto

1. Inicie o servidor Rails:

```bash
docker-compose up -d
docker compose exec app bash
  rails s
```

Agora a API deve estar disponível em `http://localhost:3000/`.

### Como Rodar os Testes

1. RSpec para testes de unidade e integração:

    ```bash
    rspec
    ```

2. Link da Documentação do Postman:

    ```bash
    https://documenter.getpostman.com/view/30124778/2s9YR6ZDsb
    ```

### Informações Adicionais

1. Existe uma coleção do postman exportada no projeto para testes da API:
2. Através da API só está disponivel a opção de criar e organizar (listar) os eventos! 
3. No projeto existe um arquivo CSV para exportação das palestras, é necessario que o formato
seja o CSV