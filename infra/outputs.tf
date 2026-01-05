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

output "sns_topic_owners" {
  description = "Mapa de proprietários dos tópicos SNS (chave: identificador do tópico, valor: ID da conta AWS)"
  value       = { for k, v in module.sns : k => v.sns_topic_owner }
}

output "sns_subscriptions" {
  description = "Mapa de subscrições SNS criadas (chave: identificador do tópico, valor: mapa de ARNs das subscrições)"
  value       = { for k, v in module.sns : k => v.sns_subscriptions }
}

output "sns_topics" {
  description = "Mapa completo com todas as informações dos tópicos SNS"
  value = {
    for k, v in module.sns : k => {
      id            = v.sns_topic_id
      arn           = v.sns_topic_arn
      name          = v.sns_topic_name
      owner         = v.sns_topic_owner
      subscriptions = v.sns_subscriptions
    }
  }
}

