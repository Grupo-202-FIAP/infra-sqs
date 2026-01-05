resource "aws_sns_topic" "payment_notification" {
  name = var.topic_name

  tags = merge(
    {
      Name        = var.topic_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.payment_notification.arn
  protocol  = "sqs"
  endpoint  = var.queue_arn

  # Configurações opcionais
  raw_message_delivery = var.raw_message_delivery
}

# Política da fila SQS para permitir que o SNS envie mensagens
data "aws_iam_policy_document" "sqs_allow_sns" {
  statement {
    sid    = "AllowSNSToSendMessage"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      var.queue_arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.payment_notification.arn]
    }
  }
}

# Aplica a política na fila SQS
resource "aws_sqs_queue_policy" "allow_sns" {
  queue_url = var.queue_url
  policy    = data.aws_iam_policy_document.sqs_allow_sns.json
}

