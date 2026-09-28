Questão 1 — A Jornada Completa (Aulas 01 a 07)
Descreva como você conectou as peças do bimestre para entregar a API de Reservas: do versionamento (Git) à infraestrutura na nuvem (Terraform + módulos + remote state). Explique a ordem que seguiu e por quê. Onde cada aula (01 a 07) apareceu na sua solução?

Repostas: Como começei pela parte de docker na prova, então segui com ajuda dos primeiros TF "Aula 01-02" para fazer as configurações e conectar o docker para inicar e ajudar na parte de git, foi com ajuda desses dois arquvios que me auxilio de como começar e testar.

Na parte de terraform e IAM contei com auxilio da pasta "aula 03" que me ajudou na separação de responsabilidades de groups e na criação de alguns arquivos e modificações

Da "aula 04 a 06" me ajudou nos testes e validação do terraform e na criação do modules até subir para AWS e fazer os testes

E a "aula 07" me ajudou a passar specs objetivas para o kiro para ele não gerar de forma alucinada e fazer o que não estava nos requisitos da prova e fugir do que eu queria, o que consegui adintar para economizar tokens e ao pedir para alterar ou criar algo ja deixando claro o que eu queria e onde buscar.



Questão 2 — O Processo com IA como Copiloto
Qual ferramenta de IA você usou e como? Descreva os prompts principais, o que a IA gerou bem e o que precisou corrigir. Se usou Kiro Spec, descreva o fluxo requisitos → design → tarefas. Compare com fazer manualmente: onde a IA economizou tempo e onde atrapalhou?

reposta: Nessa prova eu utilizei duas ferramentas de IA o "Kiro e Gemini" o kiro para criação e modificação das pastas e o gemini como duvidas e sugestão e explicação.

Primeiro antes de passar qualquer prompt para o kiro sobre a estrutura do projeto, analisei a arvore e os arquivos e entendi como ia funcionar, alguns dos arquivos criei manualmente preenchendo com auxilio dos TFs de aulas anteriores, com isso pronto fiz o primeiro prompt para o kiro.
Kiro: "quero que monte essa estrutura de repositorio, já deixei criado algumas pastas e arquivos, não precisa recriar ou apagar para construir de novo, quero que analisa os que criei e caso estiver errado o modifique, mas se não tiver não precisa mexer, siga esse exemplo:

prova-primeiro-bimestre-devops/
├── README.md # Nome, RA, descrição do projeto
├── .gitignore
├── app/ # API de Reservas
│ ├── src/
│ ├── package.json
│ ├── Dockerfile
│ └── .dockerignore
├── docker-compose.yml # API + PostgreSQL (ambiente local)
├── .env.example
├── infra/ # Terraform modularizado
│ ├── modules/
│ │ ├── vpc/
│ │ ├── security-group/
│ │ ├── ec2/
│ │ └── rds/
│ ├── main.tf # Composição dos módulos
│ ├── variables.tf
│ ├── outputs.tf
│ ├── providers.tf # Provider AWS + backend S3
│ └── backend/ # S3 + DynamoDB para remote state
├── evidencias/
│ ├── docker-build.txt # ou screenshot
│ ├── compose-ps.txt # docker compose ps
│ ├── terraform-plan.txt
│ └── (screenshots opcionais)
└── relatorio.md # Relatório do processo com IA"

Depois desta parte estava tendo um problema na hora do teste, pois não tinha pedido pra criar o .env foi quando usei meu segundo prompt
Kiro:"Verifica se foi criado o arquvio .env se caso não tiver criado crie e o modifique"

junto com esse arquivo precisa fazer a criação do app.js para conseguir testar o docker, fiz a criação manualmente e adicionei as informações dentro dela e pedi para o kiro visualizar para ver se estava corrretas.
Kiro:"Fiz a criação do arquivo app.js dentro da pasta app\src e ja coloquei informações lá, verifica se esta correto o arquivo e as informações dentro dela"

Depois finalizei a criação e a validação da parte do docker, e começei a parte do terraform, pedi para analisar os requisitos da prova com o meu infra para validar se estava de acordo.
Kiro:"agora quero que voce faça uma analise na infraestutura dentro do infra e verifica se esta batendo com esses requisitos que vou mencionar, caso não estiver me diga o que esta faltando, não modifique nem crie nada sem antes me perguntar, na dezscrição do que vou pedir pra validar eu ja fiz a modificação sobre esse ponto: "nãocrie IAM users/groups/roles — use LabRole / LabInstanceProfile. Região us-east-1". :

agora valida se esta dentro desses requisios:
VPC com subnets públicas e privadas em 2 AZs (módulo vpc)

Security Groups com menor privilégio (módulo security-group): EC2 (22, 3000) e RDS (5432 apenas do SG do EC2)

EC2 t2.micro na subnet pública com a API (módulo ec2) — use o instance profile LabInstanceProfile se precisar de acesso a serviços

RDS PostgreSQL db.t3.micro provisionado e funcional nas subnets privadas (módulo rds) — este é o banco de dados da API na nuvem, onde as rotas de CRUD gravam os dados. Deve ter publicly_accessible = false, storage_encrypted = true, db_subnet_group_name com as subnets privadas e ser acessível apenas a partir do Security Group da EC2 (porta 5432)

Remote State: backend S3 (com versionamento e encriptação) + DynamoDB para locking

Composição entre módulos (output de um alimenta input de outro)

Tags em todos os recursos e outputs úteis (IP da EC2, endpoint do RDS, URL da API)".


Com o gemini usei como auxiilio nas explicações sobre o que estava fazendo e ajuda para verificar ou explicar alguns erro que apareceu.


Gemini:"verifica se é essa parte dentro do ec2\main que é para modificar:

<!-- PROMPTS -->
resource "aws_instance" "app" {

  ami                    = data.aws_ami.amazon_linux.id

  instance_type          = var.instance_type

  subnet_id              = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  key_name} "

"ao subir meu ambiente docker ja configurado ao comando de docker compose up -d --build, ele fez a criação do restante mas apresentou esse erro, me explique o que significa e como podemos resolver:

 ✔ Image prova-primeiro-bimestre-devops-app            Built                                                                                                      22.5s

 ✔ Network prova-primeiro-bimestre-devops_default      Created                                                                                                     0.1s

 ✔ Volume prova-primeiro-bimestre-devops_postgres_data Created                                                                                                     0.0s

 ✘ Container reservas-db                               Error dependency postgres failed to start                                                                   4.1s

 ✔ Container reservas-app                              Created                                                                                                     0.3s

dependency failed to start: container reservas-db is unhealthy"

"O que esse erro e o que significa: 
logs reservas-db

Error: Database is uninitialized and superuser password is not specified.

       You must specify POSTGRES_PASSWORD to a non-empty value for the

       superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".



       You may also use "POSTGRES_HOST_AUTH_METHOD=trust" to allow all

       connections without a password. This is *not* recommended." 

"vou te enviar como o meu docker.yml esta configurado e voce me diz se esta de acordo como que esta pedindo:

services:

  app:

    build:

      context: ./app

      dockerfile: Dockerfile

    container_name: reservas-app

    ports:

      - "3000:3000"

    environment:

      - NODE_ENV=development

      - DB_HOST=postgres

      - DB_PORT=5432

      - DB_NAME=${DB_NAME}

      - DB_USER=${DB_USER}

      - DB_PASSWORD=${DB_PASSWORD}

    depends_on:

      postgres:

        condition: service_healthy

    restart: unless-stopped



  postgres:

    image: postgres:15-alpine

    container_name: reservas-db

    ports:

      - "5432:5432"

    environment:

      - POSTGRES_DB=${DB_NAME}

      - POSTGRES_USER=${DB_USER}

      - POSTGRES_PASSWORD=${DB_PASSWORD}

    volumes:

      - postgres_data:/var/lib/postgresql/data

    healthcheck:

      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]

      interval: 10s

      timeout: 5s

      retries: 5

    restart: unless-stopped



volumes:

  postgres_data:"

"me explique esse erro ao executar esse comando, acredito que o erro porque não tem com esse nome se caso for isso onde consigo o nome certo para testar:



C:\Users\Renan\prova-primeiro-bimestre-devops>docker compose exec postgres psql -U technova -d technova -c "SELECT 1;"

psql: error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL:  role "technova" does not exist"

"ja fiz as modificações e ainda persiste nesse errro o que pode estar ocorrendo?:
C:\Users\Renan\prova-primeiro-bimestre-devops>docker compose logs app
reservas-app  | node:internal/modules/cjs/loader:1210
reservas-app  |   throw err;
reservas-app  |   ^
reservas-app  |
reservas-app  | Error: Cannot find module '/app/app.js'
reservas-app  |     at Module._resolveFilename (node:internal/modules/cjs/loader:1207:15)
reservas-app  |     at Module._load (node:internal/modules/cjs/loader:1038:27)
reservas-app  |     at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:164:12)
reservas-app  |     at node:internal/main/run_main_module:28:49 {
reservas-app  |   code: 'MODULE_NOT_FOUND',
reservas-app  |   requireStack: []
reservas-app  | }
reservas-app  |
reservas-app  | Node.js v20.20.2
reservas-app  | node:internal/modules/cjs/loader:1210
reservas-app  |   throw err;"


"agora vamos rodar o terraform e fazer os testes no ambiente aws, ja fiz e modifiquei para cumprir todos os requisitos pedido abaixo:
VPC com subnets públicas e privadas em 2 AZs (módulo vpc)
Security Groups com menor privilégio (módulo security-group): EC2 (22, 3000) e RDS (5432 apenas do SG do EC2)
EC2 t2.micro na subnet pública com a API (módulo ec2) — use o instance profile LabInstanceProfile se precisar de acesso a serviços
RDS PostgreSQL db.t3.micro provisionado e funcional nas subnets privadas (módulo rds) — este é o banco de dados da API na nuvem, onde as rotas de CRUD gravam os dados. Deve ter publicly_accessible = false, storage_encrypted = true, db_subnet_group_name com as subnets privadas e ser acessível apenas a partir do Security Group da EC2 (porta 5432)
Remote State: backend S3 (com versionamento e encriptação) + DynamoDB para locking
Composição entre módulos (output de um alimenta input de outro)
Tags em todos os recursos e outputs úteis (IP da EC2, endpoint do RDS, URL da API)

agora me ajude a fazer os teste do começo até o destroy"

"ja tivemos um erro, vamos verificar o que pode ter causado e me explique o que eele significa:
C:\Users\Renan\prova-primeiro-bimestre-devops>terraform init
Terraform initialized in an empty directory!

The directory has no Terraform configuration files. You may begin working
with Terraform immediately by creating Terraform configuration files.

C:\Users\Renan\prova-primeiro-bimestre-devops>terraform validate
Success! The configuration is valid.


C:\Users\Renan\prova-primeiro-bimestre-devops>terraform plan
╷
│ Error: No configuration files
│
│ Plan requires configuration to be present. Planning without a configuration would mark everything for destruction, which is normally not what is desired. If you
│ would like to destroy everything, run plan with the -destroy option. Otherwise, create a Terraform configuration file (.tf file) and try again.
╵"
"o init dentro da pasta backend rodou, mas ao dar o apply apareceu esse erro, vamos concentrar pra entender o que esta acontecendo aqui:

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_dynamodb_table.tfstate_lock: Creating...
aws_s3_bucket.tfstate: Creating...
aws_dynamodb_table.tfstate_lock: Still creating... [00m10s elapsed]
aws_dynamodb_table.tfstate_lock: Creation complete after 19s [id=prova-devops-tfstate-lock]
╷
│ Error: reading S3 Bucket (prova-devops-tfstate) object lock configuration: operation error S3: GetObjectLockConfiguration, https response error StatusCode: 403, RequestID: E678BEFN12V72DXP, HostID: /uxGu05U6M5jBlgJrM/w/HsFV7hmrFQqDFoQOFq+dEIS7kpFGYrViIMoKbHqYJ4vBQFiIQLC634=, api error AccessDenied: User: arn:aws:sts::749283257418:assumed-role/voclabs/user5367892=Renan_Dias is not authorized to perform: s3:GetBucketObjectLockConfiguration on resource: "arn:aws:s3:::prova-devops-tfstate" with an explicit deny in a service control policy: arn:aws:organizations::246880240156:policy/o-nuzfir8dhd/service_control_policy/p-wg5dv83d
│
│   with aws_s3_bucket.tfstate,
│   on main.tf line 1, in resource "aws_s3_bucket" "tfstate":
│    1: resource "aws_s3_bucket" "tfstate""

"me de uma explicação do erro que tinhamos travado ontem e por que ele estava acontecendo e qual foi a solução que achamos"



Questão 3 — Infraestrutura, Segurança e o Learner Lab
Explique a arquitetura AWS que você provisionou (pode incluir diagrama). Por que o RDS fica na subnet privada e a EC2 na pública? Como funcionou o uso do LabRole/LabInstanceProfile em vez de criar IAM próprio? Que ajustes o AWS Academy Learner Lab exigiu em relação ao que foi ensinado (credenciais temporárias, região, restrições de IAM)?

Resposta: Para esse projeto, eu montei uma arquitetura clássica de duas camadas (Two-Tier) focada em isolamento de recursos. Tudo foi criado dentro de uma VPC na região us-east-1 (Norte da Virgínia).

Na minha infraestrutura, criei um Internet Gateway para dar acesso externo à VPC. A partir daí, dividi a rede em subnets públicas e privadas (distribuídas em 2 zonas de disponibilidade para garantir alta disponibilidade).
Na subnet pública, eu subi uma instância EC2 (Amazon Linux 2023) que atua como o servidor da nossa API Node.js. O Security Group dessa EC2 está configurado para receber tráfego da internet (0.0.0.0/0) apenas nas portas 22 (para eu acessar via SSH) e 3000 (onde a aplicação roda).
Na subnet privada, eu provisionei o banco de dados RDS PostgreSQL. O pulo do gato aqui foi no Security Group do banco: ele só aceita conexões na porta 5432 se a origem for o Security Group da própria EC2.

Por que o RDS fica na subnet privada e a EC2 na pública?
Eu fiz essa divisão por pura questão de segurança e boas práticas. A EC2 precisa estar na subnet pública (e ter um IP público) porque é ela quem recebe as requisições da internet para a nossa API. Ela é a "porta da frente".

Já o RDS guarda os dados e não tem nenhum motivo para ficar exposto para a internet, o que seria um risco enorme. Colocando o banco na subnet privada, ele fica sem rota para a internet, totalmente isolado e protegido contra ataques externos. A única forma de acessar o banco de dados é através da aplicação rodando na EC2, que atua como uma ponte segura.

Como funcionou o uso do LabRole/LabInstanceProfile em vez de criar IAM próprio?
Como eu fiz a prova usando o ambiente educacional do AWS Academy, a criação de novas regras de IAM (aws_iam_role) é bloqueada por segurança pelos administradores. Se eu tentasse criar uma role personalizada via Terraform, ia tomar um erro de permissão negada.

A solução foi bem simples: o laboratório já fornece um perfil genérico pré-criado chamado LabInstanceProfile. No meu código Terraform da EC2, em vez de pedir para ele criar uma IAM role do zero, eu apenas passei esse nome como parâmetro (iam_instance_profile = "LabInstanceProfile"). Assim, a máquina subiu com as permissões padrão de estudante do laboratório, sem bater de frente com os bloqueios de IAM da conta.

Que ajustes o AWS Academy Learner Lab exigiu em relação ao que foi ensinado (credenciais temporárias, região, restrições de IAM)?
Trabalhar no ambiente do Learner Lab me exigiu várias adaptações e algumas "gambiarras" oficiais comparado ao uso de uma conta AWS normal:

O bloqueio do Backend do Terraform (O maior desafio): A política de segurança (SCP) da faculdade bloqueia permissões avançadas do S3 (especificamente o s3:GetBucketObjectLockConfiguration). Por causa disso, o Terraform não conseguia criar o bucket S3 e a tabela do DynamoDB automaticamente para guardar o meu arquivo de estado (terraform.tfstate), dando erro AccessDenied. A solução que encontrei foi criar o bucket e a tabela manualmente pelo console da AWS e depois apenas configurar o Terraform para apontar para eles, pulando a etapa de criação por código.

Uso de chaves fixas: Para acessar a EC2, eu não pude criar chaves SSH customizadas. Tive que adaptar meu módulo da EC2 para exigir a chave padrão da plataforma, a famosa vockey.

Credenciais temporárias: Numa conta real, a gente usa chaves de acesso fixas no computador. No Learner Lab, a sessão expira rápido, então eu tive que ficar atualizando as variáveis de ambiente no meu terminal toda hora (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY e principalmente o AWS_SESSION_TOKEN) para o Terraform conseguir autenticar.

Região e IAM: Fiquei limitado a usar apenas a região us-east-1 (Norte da Virgínia) e tive que usar os perfis genéricos (LabInstanceProfile) em vez de aplicar o princípio do menor privilégio criando minhas próprias IAM Roles, porque a conta não deixava.

Questão 4 — Validação e Responsabilidade
Que checklist você aplicou antes de rodar terraform apply em código gerado por IA? Como validou que a infraestrutura estava correta e segura? O que aconteceria se você aceitasse o código da IA sem revisar? Como a evolução Git → Docker → Terraform → Modules preparou você para usar IA com responsabilidade?

Resposta:
Que checklist você aplicou antes de rodar terraform apply em código gerado por IA?
Antes de sair dando apply às cegas no código que a IA gerou, precisei fazer uma varredura manual para garantir que nada daria errado no ambiente do Learner Lab. Primeiro, rodei o terraform validate para filtrar qualquer erro bobo de sintaxe. Depois, fui direto checar as regras do nosso laboratório: garanti que não havia nenhuma criação de IAM Role (aws_iam_role), já que sabia que o AWS Academy bloqueia isso, e ajustei para usar o LabInstanceProfile. Também validei se o key_name da EC2 apontava certinho para a chave vockey do painel, em vez de tentar criar um key pair novo. Por fim, dei aquele terraform plan minucioso para conferir recurso por recurso (garantindo que só os 14 itens previstos seriam criados) e confirmei se a região estava travada em us-east-1 e se a senha do banco vinha via variáveis, sem nada exposto no código.

Como validou que a infraestrutura estava correta e segura?
A validação foi feita na prática, testando a rede e o isolamento dos serviços. Assim que o terraform apply finalizou, peguei o IP público (98.88.38.91) e me conectei na EC2 via SSH usando o nosso vockey.pem. Isso provou que a subnet pública, o Internet Gateway e as regras do Security Group na porta 22 estavam redondas. Estando dentro da EC2, fiz um teste direto de rede apontando para o endpoint do RDS PostgreSQL na porta 5432. O terminal retornou a conexão bem-sucedida de primeira, o que me deu a certeza de que a comunicação interna entre a aplicação e o banco estava funcionando. Para fechar a parte de segurança, garanti que o RDS ficasse com publicly_accessible = false e dentro de subnets privadas, ou seja, totalmente blindado e inacessível para a internet.

O que aconteceria se você aceitasse o código da IA sem revisar?
Se eu tivesse só copiado e colado o código da IA, a execução teria quebrado logo nos primeiros passos. O maior problema seria no backend: a IA gera o bloco do S3 tentando validar e gerenciar coisas avançadas como o Object Lock, o que dispararia o erro de AccessDenied na hora por conta das políticas (SCP) da faculdade. Além disso, ela tentaria criar uma IAM Role personalizada para a EC2 e um novo par de chaves SSH, fazendo o Terraform travar por falta de permissões e me deixando sem acesso à máquina. Para completar, IAs costumam sugerir regiões aleatórias (como us-west-2), o que daria erro de autenticação ou falta de recursos liberados na nossa conta de estudante.

Como a evolução Git → Docker → Terraform → Modules preparou você para usar IA com responsabilidade?
Passar por essa sequência de aprendizado foi o que me permitiu usar a IA como uma ferramenta de apoio, e não como uma "muleta". O Git me deu o controle de versionamento para saber exatamente o que estou alterando e isolar testes em branches. O Docker me ensinou como aplicações conversam em rede, como funcionam as variáveis de ambiente e a importância de isolar serviços. Quando cheguei no Terraform, eu já entendia o ciclo de vida da infraestrutura (init, plan, apply, destroy) e sabia ler o estado dos recursos. Por fim, trabalhar com Módulos me fez enxergar a arquitetura de forma organizada e reativa. No fim das contas, essa bagagem me deu a autonomia necessária para identificar onde a IA errou em relação às restrições do AWS Academy, diagnosticar a causa raiz e reescrever o código do jeito certo.