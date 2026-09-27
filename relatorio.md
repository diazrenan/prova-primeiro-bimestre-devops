# Relatório — Prova do Primeiro Bimestre (DevOps)

**Aluno:** Renan Dias  
**RA:** 6325033

---

## 1. Descrição do Projeto

Este projeto consiste na criação de uma API de Reservas containerizada com Docker e em uma infraestrutura de produção provisionada na AWS utilizando Terraform modularizado. O objetivo foi aplicar os conceitos de DevOps vistos ao longo do bimestre: containers, orquestração local com Docker Compose e infraestrutura como código (IaC).

---

## 2. Uso de IA no Processo

Durante o desenvolvimento deste projeto, utilizei o Kiro (assistente de IA integrado ao IDE) para auxiliar nas seguintes etapas:

### Estruturação do Repositório
A IA ajudou a organizar a estrutura de pastas e arquivos do repositório, identificando arquivos que estavam em locais incorretos (como `Dockerfile` e `package.json` dentro de `app/src/` em vez de `app/`) e movendo-os para os lugares corretos.

### Terraform Modularizado
A IA gerou os arquivos Terraform para cada módulo (`vpc`, `security-group`, `ec2`, `rds`) seguindo boas práticas:
- Separação em `main.tf`, `variables.tf` e `outputs.tf` por módulo
- Uso de `depends_on` implícito via referências de output entre módulos
- Backend remoto com S3 versionado, criptografado e com acesso público bloqueado
- Lock de state via DynamoDB

### Docker Compose
A IA gerou o `docker-compose.yml` com healthcheck no serviço do PostgreSQL, garantindo que a aplicação só suba após o banco estar pronto.

### Decisões Técnicas Discutidas com a IA
- Uso de `db.t3.micro` para o RDS (elegível ao Free Tier da AWS)
- `t3.micro` para a EC2 (também no Free Tier)
- Subnets privadas para o RDS (sem acesso público direto)
- `skip_final_snapshot = true` no RDS para facilitar o teardown em ambiente de estudo

---

## 3. Etapas de Execução

### Ambiente Local (Docker Compose)

1. Criação do `Dockerfile` multi-stage otimizado para produção usando `node:20-alpine`
2. Configuração do `docker-compose.yml` com os serviços `app` e `postgres`
3. Build da imagem e verificação dos containers em execução

### Infraestrutura AWS (Terraform)

1. Criação do backend de remote state (`infra/backend`)
2. Criação dos módulos individuais de VPC, Security Groups, EC2 e RDS
3. Composição dos módulos no `infra/main.tf`
4. Execução do `terraform plan` para validação

---

## 4. Dificuldades Encontradas

- Configuração inicial do backend S3 antes de poder usá-lo como remote state — resolvido criando um módulo separado em `infra/backend` que deve ser aplicado primeiro.
- Estrutura de subnets privadas para o RDS exigiu atenção ao `db_subnet_group`, que precisa de pelo menos duas AZs.

---

## 5. Conclusão

O projeto demonstrou na prática como ferramentas de DevOps modernas — Docker, Docker Compose e Terraform — trabalham em conjunto para criar ambientes reproduzíveis e infraestruturas escaláveis. O uso de IA acelerou significativamente a geração de código boilerplate, permitindo focar nas decisões de arquitetura e nas boas práticas de cada ferramenta.
