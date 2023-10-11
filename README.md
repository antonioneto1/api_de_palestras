## Conferences API

### Pré-requisitos

- Ruby 3.0.2
- Rails 5.x
### Setup de Desenvolvimento Docker

Utilizando Docker e Docker Compose:

```sh
cd api_de_palestras
	ARG_USER_UID=$(id -u) ARG_USER_GID=$(id -g) docker compose config
  ARG_USER_UID=$(id -u) ARG_USER_GID=$(id -g) docker compose build
  docker compose up -d
  docker compose exec app bash
    bundle
    rails db:drop db:create db:migrate db:seed
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

2. RSwag para geração da documentação Swagger:

    ```bash
    rake rswag:specs:swaggerize
    ```