# Infraestrutura SQS - Terraform

Este projeto contém a infraestrutura como código (IaC) para criar e gerenciar filas Amazon SQS na AWS usando Terraform. A infraestrutura é modular e permite criar múltiplas filas SQS com configurações personalizadas.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Configuração](#configuração)
- [Uso](#uso)
- [Variáveis](#variáveis)
- [Outputs](#outputs)
- [Módulo SQS](#módulo-sqs)
- [Módulo SNS](#módulo-sns)
- [Recursos Suportados](#recursos-suportados)
- [Exemplos](#exemplos)

## 🎯 Visão Geral

Esta infraestrutura permite criar e gerenciar filas SQS na AWS com suporte a:

- ✅ Múltiplas filas SQS configuráveis
- ✅ Dead Letter Queue (DLQ) para tratamento de mensagens falhas
- ✅ Criptografia com KMS
- ✅ Políticas de acesso customizadas
- ✅ Tags para organização e custos
- ✅ Configurações avançadas (long polling, visibility timeout, etc.)
- ✅ Backend S3 para armazenamento do state do Terraform
- ✅ Criação de tópicos SNS e assinatura automática de filas SQS

## 📁 Estrutura do Projeto

```
infra-sqs/
├── infra/
│   ├── main.tf              # Módulo principal que instancia as filas SQS e SNS
│   ├── variables.tf         # Variáveis do módulo raiz
│   ├── outputs.tf           # Outputs da infraestrutura
│   ├── providers.tf         # Configuração de providers e backend
│   ├── terraform.tfvars     # Valores das variáveis (customize aqui)
│   └── modules/
│       ├── sqs/
│       │   ├── main.tf       # Recurso SQS
│       │   ├── variables.tf # Variáveis do módulo SQS
│       │   └── outputs.tf    # Outputs do módulo SQS
│       └── sns/
│           ├── main.tf       # Tópico SNS e assinatura SQS
│           ├── variables.tf # Variáveis do módulo SNS
│           └── outputs.tf    # Outputs do módulo SNS
└── README.md
```

## 🔧 Pré-requisitos

Antes de usar esta infraestrutura, certifique-se de ter:

1. **Terraform** instalado (versão 1.0 ou superior)
   ```bash
   terraform version
   ```

2. **AWS CLI** configurado com credenciais válidas
   ```bash
   aws configure
   ```

3. **Permissões AWS** necessárias:
   - `sqs:CreateQueue`
   - `sqs:GetQueueAttributes`
   - `sqs:SetQueueAttributes`
   - `sqs:TagQueue`
   - `kms:DescribeKey` (se usar criptografia KMS)
   - `s3:GetObject`, `s3:PutObject` (para o backend S3)

4. **Bucket S3** para o backend do Terraform (já configurado no `providers.tf`):
   - Bucket: `nextime-food-state-bucket`
   - Região: `us-east-1`
   - O bucket deve existir antes de executar `terraform init`

## ⚙️ Configuração

### 1. Configurar o Backend S3

O backend está configurado no arquivo `infra/providers.tf`. Certifique-se de que:

- O bucket `nextime-food-state-bucket` existe na região `us-east-1`
- Você tem permissões para acessar o bucket
- A criptografia está habilitada (já configurada)

### 2. Personalizar Variáveis

Edite o arquivo `infra/terraform.tfvars` para configurar suas filas:

```hcl
region = "us-east-1"

tags = {
  Owner = "nexTime-food"
  Environment = "production"
}

sqs_queues = {
  "minha-fila" = {
    queue_name                 = "minha-fila"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    visibility_timeout_seconds = 30
    # ... outras configurações
  }
}
```

## 🚀 Uso

### Inicialização

```bash
cd infra
terraform init
```

### Validação

Valide a configuração antes de aplicar:

```bash
terraform validate
```

### Planejamento

Visualize as mudanças que serão aplicadas:

```bash
terraform plan
```

### Aplicação

Aplique a infraestrutura:

```bash
terraform apply
```

Confirme digitando `yes` quando solicitado.

### Destruição

Para remover toda a infraestrutura:

```bash
terraform destroy
```

⚠️ **Atenção**: Isso irá deletar todas as filas SQS criadas!

## 📝 Variáveis

### Variáveis do Módulo Raiz

| Variável | Tipo | Descrição | Padrão | Obrigatória |
|----------|------|-----------|--------|-------------|
| `region` | `string` | Região da AWS onde os recursos serão criados | - | ✅ Sim |
| `tags` | `map(string)` | Tags globais aplicadas a todos os recursos | `{}` | ❌ Não |
| `sqs_queues` | `map(object)` | Mapa de filas SQS a serem criadas | `{}` | ❌ Não |
| `sns_topics` | `map(object)` | Mapa de tópicos SNS a serem criados e assinaturas SQS | `{}` | ❌ Não |

### Variáveis do Objeto `sqs_queues`

Cada entrada no mapa `sqs_queues` pode conter as seguintes propriedades:

| Variável | Tipo | Descrição | Padrão |
|----------|------|-----------|--------|
| `queue_name` | `string` | Nome da fila SQS | - |
| `delay_seconds` | `number` | Tempo de atraso antes das mensagens ficarem disponíveis (0-900) | `0` |
| `max_message_size` | `number` | Tamanho máximo da mensagem em bytes (1024-262144) | `262144` |
| `message_retention_seconds` | `number` | Retenção de mensagens não processadas em segundos (60-1209600) | `345600` |
| `receive_wait_time_seconds` | `number` | Tempo de long polling em segundos (0-20) | `0` |
| `visibility_timeout_seconds` | `number` | Tempo de invisibilidade após recebimento em segundos | `30` |
| `dead_letter_queue_arn` | `string` | ARN da Dead Letter Queue (opcional) | `null` |
| `max_receive_count` | `number` | Número máximo de tentativas antes de enviar para DLQ | `3` |
| `kms_master_key_id` | `string` | ID da chave KMS para criptografia (opcional) | `null` |
| `enable_queue_policy` | `bool` | Habilitar política de acesso customizada | `false` |
| `queue_policy` | `string` | Política JSON para controle de acesso | `null` |
| `tags` | `map(string)` | Tags específicas para esta fila | `{}` |

### Variáveis do Objeto `sns_topics`

| Variável | Tipo | Descrição | Padrão |
|----------|------|-----------|--------|
| `topic_name` | `string` | Nome do tópico SNS | - |
| `environment` | `string` | Ambiente (dev, staging, production) | `"dev"` |
| `sqs_subscription_key` | `string` | Chave da fila em `sqs_queues` que será assinada neste tópico | - |
| `raw_message_delivery` | `bool` | Envia mensagem sem envelope JSON do SNS | `false` |
| `tags` | `map(string)` | Tags específicas para este tópico | `{}` |

## 📤 Outputs

A infraestrutura expõe os seguintes outputs:

| Output | Descrição |
|--------|-----------|
| `sqs_queue_ids` | Mapa de IDs das filas SQS (chave: identificador, valor: ID) |
| `sqs_queue_arns` | Mapa de ARNs das filas SQS (chave: identificador, valor: ARN) |
| `sqs_queue_urls` | Mapa de URLs das filas SQS (chave: identificador, valor: URL) |
| `sqs_queue_names` | Mapa de nomes das filas SQS (chave: identificador, valor: nome) |
| `sqs_queues` | Mapa completo com todas as informações das filas (id, arn, url, name) |
| `sns_topic_ids` | Mapa de IDs dos tópicos SNS (chave: identificador, valor: ID) |
| `sns_topic_arns` | Mapa de ARNs dos tópicos SNS (chave: identificador, valor: ARN) |
| `sns_topic_names` | Mapa de nomes dos tópicos SNS (chave: identificador, valor: nome) |
| `sns_subscription_arns` | Mapa de ARNs das subscriptions SNS (chave: identificador, valor: ARN) |
| `sns_topics` | Mapa completo com todas as informações dos tópicos (id, arn, name, subscription_arn, subscription_id) |

### Exemplo de Uso dos Outputs

```bash
# Ver todos os outputs
terraform output

# Ver um output específico
terraform output sqs_queue_urls
terraform output sns_topic_arns
```

## 🧩 Módulo SQS

O módulo `sqs` é reutilizável e pode ser usado em outros projetos. Ele cria:

1. **Fila SQS** (`aws_sqs_queue.main`)
   - Configurações de performance e comportamento
   - Suporte a Dead Letter Queue
   - Criptografia KMS
   - Tags automáticas

2. **Política de Acesso** (`aws_sqs_queue_policy.main`) - Opcional
   - Criada apenas se `enable_queue_policy = true`
   - Permite controle granular de acesso

### Outputs do Módulo

Cada instância do módulo retorna:

- `sqs_queue_id`: ID da fila
- `sqs_queue_arn`: ARN da fila
- `sqs_queue_url`: URL da fila
- `sqs_queue_name`: Nome da fila

## 🧩 Módulo SNS

O módulo `sns` cria tópicos SNS e assina automaticamente uma fila SQS existente, além de aplicar a política necessária para permitir que o SNS publique na fila.

1. **Tópico SNS** (`aws_sns_topic.payment_notification`)
   - Tags herdadas do módulo raiz + tags específicas
2. **Assinatura SQS** (`aws_sns_topic_subscription.sqs_subscription`)
   - Assina a fila referenciada por `sqs_subscription_key`
   - Suporta `raw_message_delivery`
3. **Política da fila** (`aws_sqs_queue_policy.allow_sns`)
   - Libera `sqs:SendMessage` apenas para o tópico SNS

### Outputs do Módulo SNS

- `sns_topic_id`: ID do tópico
- `sns_topic_arn`: ARN do tópico
- `sns_topic_name`: Nome do tópico
- `sns_subscription_arn`: ARN da assinatura
- `sns_subscription_id`: ID da assinatura

## 💡 Exemplos

### Exemplo 1: Fila Simples

```hcl
sqs_queues = {
  "fila-simples" = {
    queue_name = "fila-simples"
  }
}
```

### Exemplo 2: Fila com DLQ

```hcl
sqs_queues = {
  "dlq" = {
    queue_name = "dlq"
  },
  "fila-com-dlq" = {
    queue_name            = "fila-com-dlq"
    dead_letter_queue_arn = "arn:aws:sqs:us-east-1:123456789012:dlq"
    max_receive_count     = 5
  }
}
```

### Exemplo 3: Fila com Tags Específicas

```hcl
sqs_queues = {
  "fila-com-tags" = {
    queue_name = "fila-com-tags"
    tags = {
      Environment = "production"
      Team        = "backend"
      Project     = "payment-service"
    }
  }
}
```

### Exemplo 4: Múltiplas Filas

```hcl
sqs_queues = {
  "order-queue" = {
    queue_name                 = "order-queue"
    visibility_timeout_seconds = 60
  },
  "payment-queue" = {
    queue_name                 = "payment-queue"
    visibility_timeout_seconds = 120
    message_retention_seconds  = 604800  # 7 dias
  },
  "notification-queue" = {
    queue_name              = "notification-queue"
    receive_wait_time_seconds = 20  # Long polling
  }
}
```

### Exemplo 5: Tópico SNS com assinatura SQS (payment-callback)

```hcl
sqs_queues = {
  "payment-callback-queue" = {
    queue_name          = "payment-callback-queue"
    enable_queue_policy = true # necessário para receber política do SNS
  }
}

sns_topics = {
  "payment-callback" = {
    topic_name           = "payment-callback"
    environment          = "dev"
    sqs_subscription_key = "payment-callback-queue"
    raw_message_delivery = false
    tags = {
      Service = "Payment"
    }
  }
}
```

## 🔒 Segurança

### Boas Práticas Implementadas

- ✅ Criptografia do state do Terraform no S3
- ✅ Suporte a criptografia KMS nas filas
- ✅ Políticas de acesso configuráveis
- ✅ Tags para organização e governança

### Recomendações

1. **Credenciais AWS**: Use IAM roles ou variáveis de ambiente, nunca hardcode credenciais
2. **State File**: Mantenha o backend S3 com versionamento e criptografia habilitados
3. **Políticas de Acesso**: Sempre defina políticas restritivas quando usar `enable_queue_policy`
4. **Tags**: Use tags consistentes para facilitar gestão de custos e compliance

## 🐛 Troubleshooting

### Erro: "Backend initialization required"

```bash
terraform init
```

### Erro: "InvalidClientTokenId"

Verifique suas credenciais AWS:

```bash
aws sts get-caller-identity
```

### Erro: "Bucket does not exist"

Crie o bucket S3 antes de inicializar:

```bash
aws s3 mb s3://nextime-food-state-bucket --region us-east-1
```

### Erro: "Queue name already exists"

Os nomes de filas SQS devem ser únicos globalmente. Escolha um nome diferente.

## 📚 Referências

- [Documentação AWS SQS](https://docs.aws.amazon.com/sqs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue)
- [Terraform Documentation](https://www.terraform.io/docs)

## 📄 Licença

Este projeto é parte do sistema nexTime-food.

## 👥 Contribuição

Para contribuir com este projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

**Desenvolvido para nexTime-food** 🚀

