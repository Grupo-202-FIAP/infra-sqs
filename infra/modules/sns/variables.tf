variable "topic_name" {
  description = "Nome do tópico SNS"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, production)"
  type        = string
  default     = "dev"
}

variable "queue_arn" {
  description = "ARN da fila SQS que receberá as notificações"
  type        = string
}

variable "queue_url" {
  description = "URL da fila SQS para aplicar a política"
  type        = string
}

variable "raw_message_delivery" {
  description = "Se true, envia mensagens sem o envelope JSON do SNS"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais para o tópico SNS"
  type        = map(string)
  default     = {}
}

