variable "topic_name" {
  description = "Nome do tópico SNS"
  type        = string
}

variable "display_name" {
  description = "Nome de exibição do tópico SNS"
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "Política de entrega do tópico SNS em formato JSON"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Se o tópico é FIFO (First-In-First-Out)"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Habilita deduplicação baseada em conteúdo para tópicos FIFO"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "ID da chave KMS para criptografia (opcional, usa a chave padrão da AWS se não especificado)"
  type        = string
  default     = null
}

variable "enable_topic_policy" {
  description = "Habilitar política de acesso customizada para o tópico"
  type        = bool
  default     = false
}

variable "topic_policy" {
  description = "Política JSON para controle de acesso ao tópico"
  type        = string
  default     = null
}

variable "subscriptions" {
  description = "Mapa de subscrições para o tópico SNS"
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = optional(bool, false)
    filter_policy          = optional(string, null)
    filter_policy_scope    = optional(string, null)
    raw_message_delivery   = optional(bool, false)
    redrive_policy         = optional(string, null)
  }))
  default = {}
}

variable "tags" {
  description = "Tags adicionais para o tópico SNS"
  type        = map(string)
  default     = {}
}
