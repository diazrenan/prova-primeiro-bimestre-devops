# Entrega — Prova do Primeiro Bimestre (DevOps)

**Aluno:** Renan Dias  
**RA:** 6325033

## Descrição do Projeto

API de Reservas containerizada com Docker e infraestrutura provisionada na AWS via Terraform modularizado.

A aplicação é uma API REST construída em Node.js/Express que gerencia reservas, com banco de dados PostgreSQL. O ambiente local é orquestrado com Docker Compose e o ambiente de produção é provisionado na AWS com Terraform.

## Estrutura do Repositório

```
prova-primeiro-bimestre-devops/
├── app/                        # API de Reservas (Node.js/Express)
│   ├── src/                    # Código-fonte da aplicação
│   ├── Dockerfile
│   ├── package.json
│   └── .dockerignore
├── docker-compose.yml          # API + PostgreSQL (ambiente local)
├── .env.example                # Variáveis de ambiente de exemplo
├── infra/                      # Terraform modularizado
│   ├── modules/
│   │   ├── vpc/                # VPC, subnets, internet gateway
│   │   ├── security-group/     # Security groups para EC2 e RDS
│   │   ├── ec2/                # Instância EC2 para a aplicação
│   │   └── rds/                # Banco de dados PostgreSQL gerenciado
│   ├── backend/                # S3 + DynamoDB para remote state
│   ├── main.tf                 # Composição dos módulos
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf            # Provider AWS + backend S3
├── evidencias/                 # Capturas de tela e logs
└── relatorio.md                # Relatório do processo com IA
```

## Como Executar Localmente

**Pré-requisitos:** Docker e Docker Compose instalados.

1. Copie o arquivo de variáveis de ambiente:
   ```bash
   cp .env.example .env
   ```

2. Edite o `.env` com os valores desejados.

3. Suba os containers:
   ```bash
   docker compose up --build
   ```

4. A API estará disponível em `http://localhost:3000`.

## Infraestrutura AWS (Terraform)

**Pré-requisitos:** Terraform >= 1.5.0 e credenciais AWS configuradas.

### 1. Provisionar o backend de remote state (primeira vez)

```bash
cd infra/backend
terraform init
terraform apply
```

### 2. Provisionar a infraestrutura principal

```bash
cd infra
terraform init
terraform plan
terraform apply
```

### Recursos provisionados

| Recurso | Descrição |
|---|---|
| VPC | Rede isolada com subnets públicas e privadas |
| Security Groups | Regras de firewall para EC2 (HTTP/SSH) e RDS (PostgreSQL) |
| EC2 | Instância para hospedar a aplicação com Docker |
| RDS | Banco de dados PostgreSQL gerenciado |
| S3 | Bucket para armazenar o Terraform state |
| DynamoDB | Tabela para lock do Terraform state |
