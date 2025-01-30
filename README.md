# Deploy de Aplicações Flask com Docker e Kubernetes

Este projeto foi desenvolvido para containerizar e implantar duas aplicações Flask (`app` e `redirect`) usando Docker, Docker Compose e Kubernetes (Minikube). Abaixo, explico o que foi feito, como executar o projeto e como testar as aplicações.

## O que foi feito

### Containerização das Aplicações
- Criados dois `Dockerfiles` (um para cada aplicação) para empacotar as aplicações em containers.
- Utilizada a imagem base `python:3.9-slim` e instaladas as dependências do `requirements.txt`.
- Criados scripts (`start.sh` e `start-redirect.sh`) para iniciar as aplicações em portas diferentes (`5000` para `app` e `5001` para `redirect`).

### Deploy com Docker Compose
- Criado um arquivo `docker-compose.yml` para rodar as duas aplicações juntas.
- Configurada a comunicação entre os containers e expostas as portas para acesso externo.

### Deploy em Kubernetes (Minikube)
- Criados manifestos YAML para os Deployments, Services e Ingress.
- Utilizado o Minikube para simular um cluster Kubernetes e configurado o Ingress para expor as aplicações com os domínios `app.local` e `redirect.local`.

### Testes
- Testadas todas as rotas para garantir que as aplicações estão funcionando corretamente.

---

## Como executar o projeto

### Pré-requisitos
- Docker instalado.
- Minikube instalado (para o deploy em Kubernetes).
- `kubectl` instalado (para interagir com o Kubernetes).

### 1. Containerização

Construa as imagens Docker:

```bash
docker build -t app:latest -f Dockerfile .
docker build -t redirect:latest -f Dockerfile-redirect .
```

Verifique se as imagens foram criadas:

```bash
docker images
```

### 2. Deploy com Docker Compose

Crie o arquivo `docker-compose.yml`:

```yaml
version: '3.8'
services:
  app:
    image: app:latest
    ports:
      - "5000:5000"
  redirect:
    image: redirect:latest
    ports:
      - "5001:5001"
    environment:
      - TARGET_SERVICE=http://app:5000
```

Inicie os containers:

```bash
docker-compose up --build
```

Acesse as aplicações:
- `app`: [http://localhost:5000](http://localhost:5000)
- `redirect`: [http://localhost:5001/rota1](http://localhost:5001/rota1)

### 3. Deploy em Kubernetes (Minikube)

Inicie o Minikube e ative o Ingress:

```bash
minikube start --driver=docker
minikube addons enable ingress
```

Configure o Docker para usar o Minikube:

```bash
eval $(minikube docker-env)
```

Construa as imagens no Minikube:

```bash
docker build -t app:latest -f Dockerfile .
docker build -t redirect:latest -f Dockerfile-redirect .
```

Aplique os manifestos Kubernetes:

```bash
kubectl apply -f app-deployment.yaml
kubectl apply -f redirect-deployment.yaml
kubectl apply -f app-service.yaml
kubectl apply -f redirect-service.yaml
kubectl apply -f ingress.yaml
```

Configure o `/etc/hosts`:

Adicione as linhas abaixo (substitua o IP pelo IP do Minikube, obtido com `minikube ip`):

```
192.168.49.2 app.local
192.168.49.2 redirect.local
```

### 4. Testes

Acesse a rota raiz da aplicação `app`:

```bash
curl http://app.local
```

**Resposta esperada:**

```json
{"message": "Olá, mundo!"}
```

Verifique a rota `/health` da aplicação `app`:

```bash
curl http://app.local/health
```

**Resposta esperada:**

```json
{"status": "UP"}
```

Teste a rota `/rota1` da aplicação `redirect`:

```bash
curl http://redirect.local/rota1
```

**Resposta esperada (redirecionamento para `/health` da aplicação `app`)**:

```json
{"status": "UP"}
```

