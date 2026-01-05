module "sqs" {
  for_each                   = var.sqs_queues
  source                     = "./modules/sqs"
  queue_name                 = each.value.queue_name
  delay_seconds              = each.value.delay_seconds
  max_message_size           = each.value.max_message_size
  message_retention_seconds  = each.value.message_retention_seconds
  receive_wait_time_seconds  = each.value.receive_wait_time_seconds
  visibility_timeout_seconds = each.value.visibility_timeout_seconds
  dead_letter_queue_arn      = each.value.dead_letter_queue_arn
  max_receive_count          = each.value.max_receive_count
  kms_master_key_id          = each.value.kms_master_key_id
  enable_queue_policy        = each.value.enable_queue_policy
  queue_policy               = each.value.queue_policy
  tags                       = merge(var.tags, each.value.tags)
}

module "sns" {
  for_each                    = var.sns_topics
  source                      = "./modules/sns"
  topic_name                  = each.value.topic_name
  display_name                = each.value.display_name
  delivery_policy             = each.value.delivery_policy
  fifo_topic                  = each.value.fifo_topic
  content_based_deduplication = each.value.content_based_deduplication
  kms_master_key_id           = each.value.kms_master_key_id
  enable_topic_policy         = each.value.enable_topic_policy
  topic_policy                = each.value.topic_policy
  subscriptions               = each.value.subscriptions
  tags                        = merge(var.tags, each.value.tags)
}

