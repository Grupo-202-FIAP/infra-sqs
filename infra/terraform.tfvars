region = "us-east-1"

# Tags
tags = {
  Owner = "fast-food-fiap"
}

# =====================
# SQS - Lista de Filas
# =====================
sqs_queues = {
  "fastfood-queue" = {
    queue_name                  = "fastfood-queue"
    delay_seconds               = 0
    max_message_size            = 262144
    message_retention_seconds   = 345600
    receive_wait_time_seconds   = 0
    visibility_timeout_seconds = 30
    max_receive_count           = 3
    enable_queue_policy         = false
    tags                        = {}
  }
  # Exemplo de segunda fila (descomente e ajuste conforme necessário):
  # "fastfood-dlq" = {
  #   queue_name                  = "fastfood-dlq"
  #   delay_seconds               = 0
  #   max_message_size            = 262144
  #   message_retention_seconds   = 1209600  # 14 dias
  #   receive_wait_time_seconds   = 0
  #   visibility_timeout_seconds  = 30
  #   max_receive_count           = 3
  #   enable_queue_policy         = false
  #   tags                        = {}
  # }
}

