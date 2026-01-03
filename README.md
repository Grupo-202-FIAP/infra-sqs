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

## 📁 Estrutura do Projeto

```
infra-sqs/
├── infra/
│   ├── main.tf              # Módulo principal que instancia as filas SQS
│   ├── variables.tf         # Variáveis do módulo raiz
│   ├── outputs.tf           # Outputs da infraestrutura
│   ├── providers.tf         # Configuração de providers e backend
│   ├── terraform.tfvars     # Valores das variáveis (customize aqui)
│   └── modules/
│       └── sqs/
│           ├── main.tf       # Recurso SQS
│           ├── variables.tf # Variáveis do módulo SQS
│           └── outputs.tf    # Outputs do módulo SQS
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
   - Bucket: `terraform-state-bucket-nextime`
   - Região: `us-east-1`
   - O bucket deve existir antes de executar `terraform init`

## ⚙️ Configuração

### 1. Configurar o Backend S3

O backend está configurado no arquivo `infra/providers.tf`. Certifique-se de que:

- O bucket `terraform-state-bucket-nextime` existe na região `us-east-1`
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

## 📤 Outputs

A infraestrutura expõe os seguintes outputs:

| Output | Descrição |
|--------|-----------|
| `sqs_queue_ids` | Mapa de IDs das filas SQS (chave: identificador, valor: ID) |
| `sqs_queue_arns` | Mapa de ARNs das filas SQS (chave: identificador, valor: ARN) |
| `sqs_queue_urls` | Mapa de URLs das filas SQS (chave: identificador, valor: URL) |
| `sqs_queue_names` | Mapa de nomes das filas SQS (chave: identificador, valor: nome) |
| `sqs_queues` | Mapa completo com todas as informações das filas (id, arn, url, name) |

### Exemplo de Uso dos Outputs

```bash
# Ver todos os outputs
terraform output

# Ver um output específico
terraform output sqs_queue_urls

# Usar em outro módulo/stack
output "queue_url" {
  value = module.sqs_infra.sqs_queue_urls["order-queue"]
}
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

## 🎛️ Recursos Suportados

### Dead Letter Queue (DLQ)

Para configurar uma Dead Letter Queue, você precisa:

1. Criar uma fila DLQ primeiro
2. Referenciar o ARN da DLQ na fila principal

```hcl
sqs_queues = {
  "dlq-exemplo" = {
    queue_name = "dlq-exemplo"
    # ... outras configurações
  },
  "fila-principal" = {
    queue_name            = "fila-principal"
    dead_letter_queue_arn = "arn:aws:sqs:us-east-1:123456789012:dlq-exemplo"
    max_receive_count     = 3
    # ... outras configurações
  }
}
```

### Criptografia KMS

Para usar criptografia com uma chave KMS customizada:

```hcl
sqs_queues = {
  "fila-criptografada" = {
    queue_name        = "fila-criptografada"
    kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    # ... outras configurações
  }
}
```

### Política de Acesso Customizada

Para adicionar uma política de acesso:

```hcl
sqs_queues = {
  "fila-com-politica" = {
    queue_name         = "fila-com-politica"
    enable_queue_policy = true
    queue_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = "*"
      }]
    })
    # ... outras configurações
  }
}
```

### Long Polling

Para habilitar long polling (reduz custos e latência):

```hcl
sqs_queues = {
  "fila-long-polling" = {
    queue_name              = "fila-long-polling"
    receive_wait_time_seconds = 20  # Máximo 20 segundos
    # ... outras configurações
  }
}
```

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
aws s3 mb s3://terraform-state-bucket-nextime --region us-east-1
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



