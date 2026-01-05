output "sns_topic_id" {
  description = "ID do tópico SNS"
  value       = aws_sns_topic.payment_notification.id
}

output "sns_topic_arn" {
  description = "ARN do tópico SNS"
  value       = aws_sns_topic.payment_notification.arn
}

output "sns_topic_name" {
  description = "Nome do tópico SNS"
  value       = aws_sns_topic.payment_notification.name
}

output "sns_subscription_arn" {
  description = "ARN da subscription SQS"
  value       = aws_sns_topic_subscription.sqs_subscription.arn
}

output "sns_subscription_id" {
  description = "ID da subscription SQS"
  value       = aws_sns_topic_subscription.sqs_subscription.id
}

