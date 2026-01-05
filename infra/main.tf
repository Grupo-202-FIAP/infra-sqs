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
  for_each             = var.sns_topics
  source               = "./modules/sns"
  topic_name           = each.value.topic_name
  environment          = each.value.environment
  queue_arn            = module.sqs[each.value.sqs_subscription_key].sqs_queue_arn
  queue_url            = module.sqs[each.value.sqs_subscription_key].sqs_queue_url
  raw_message_delivery = each.value.raw_message_delivery
  tags                 = merge(var.tags, each.value.tags)

  depends_on = [module.sqs]
}

