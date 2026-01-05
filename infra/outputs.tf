output "sqs_queue_ids" {
  description = "Mapa de IDs das filas SQS (chave: identificador da fila, valor: ID da fila)"
  value       = { for k, v in module.sqs : k => v.sqs_queue_id }
}

output "sqs_queue_arns" {
  description = "Mapa de ARNs das filas SQS (chave: identificador da fila, valor: ARN da fila)"
  value       = { for k, v in module.sqs : k => v.sqs_queue_arn }
}

output "sqs_queue_urls" {
  description = "Mapa de URLs das filas SQS (chave: identificador da fila, valor: URL da fila)"
  value       = { for k, v in module.sqs : k => v.sqs_queue_url }
}

output "sqs_queue_names" {
  description = "Mapa de nomes das filas SQS (chave: identificador da fila, valor: nome da fila)"
  value       = { for k, v in module.sqs : k => v.sqs_queue_name }
}

output "sqs_queues" {
  description = "Mapa completo com todas as informações das filas SQS"
  value = {
    for k, v in module.sqs : k => {
      id   = v.sqs_queue_id
      arn  = v.sqs_queue_arn
      url  = v.sqs_queue_url
      name = v.sqs_queue_name
    }
  }
}

# SNS Outputs
output "sns_topic_ids" {
  description = "Mapa de IDs dos tópicos SNS (chave: identificador do tópico, valor: ID do tópico)"
  value       = { for k, v in module.sns : k => v.sns_topic_id }
}

output "sns_topic_arns" {
  description = "Mapa de ARNs dos tópicos SNS (chave: identificador do tópico, valor: ARN do tópico)"
  value       = { for k, v in module.sns : k => v.sns_topic_arn }
}

output "sns_topic_names" {
  description = "Mapa de nomes dos tópicos SNS (chave: identificador do tópico, valor: nome do tópico)"
  value       = { for k, v in module.sns : k => v.sns_topic_name }
}

output "sns_subscription_arns" {
  description = "Mapa de ARNs das subscriptions SNS (chave: identificador do tópico, valor: ARN da subscription)"
  value       = { for k, v in module.sns : k => v.sns_subscription_arn }
}

output "sns_topics" {
  description = "Mapa completo com todas as informações dos tópicos SNS"
  value = {
    for k, v in module.sns : k => {
      id               = v.sns_topic_id
      arn              = v.sns_topic_arn
      name             = v.sns_topic_name
      subscription_arn = v.sns_subscription_arn
      subscription_id  = v.sns_subscription_id
    }
  }
}

