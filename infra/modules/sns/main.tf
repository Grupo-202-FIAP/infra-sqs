# Criação do tópico SNS
resource "aws_sns_topic" "main" {
  name                        = var.topic_name
  display_name                = var.display_name
  delivery_policy             = var.delivery_policy
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication

  # Criptografia
  kms_master_key_id = var.kms_master_key_id

  # Tags
  tags = merge(
    {
      Name = var.topic_name
    },
    var.tags
  )
}

# Política de acesso (opcional)
resource "aws_sns_topic_policy" "main" {
  count  = var.enable_topic_policy && var.topic_policy != null ? 1 : 0
  arn    = aws_sns_topic.main.arn
  policy = var.topic_policy
}

# Subscrição SNS (opcional)
resource "aws_sns_topic_subscription" "main" {
  for_each = var.subscriptions

  topic_arn              = aws_sns_topic.main.arn
  protocol               = each.value.protocol
  endpoint               = each.value.endpoint
  endpoint_auto_confirms = each.value.endpoint_auto_confirms
  filter_policy          = each.value.filter_policy
  filter_policy_scope    = each.value.filter_policy_scope
  raw_message_delivery   = each.value.raw_message_delivery
  redrive_policy         = each.value.redrive_policy
}
