output "sns_topic_id" {
  description = "ID do tópico SNS"
  value       = aws_sns_topic.main.id
}

output "sns_topic_arn" {
  description = "ARN do tópico SNS"
  value       = aws_sns_topic.main.arn
}

output "sns_topic_name" {
  description = "Nome do tópico SNS"
  value       = aws_sns_topic.main.name
}

output "sns_topic_owner" {
  description = "ID da conta AWS que possui o tópico SNS"
  value       = aws_sns_topic.main.owner
}

output "sns_subscriptions" {
  description = "Mapa de subscrições SNS criadas"
  value       = { for k, v in aws_sns_topic_subscription.main : k => v.arn }
}
