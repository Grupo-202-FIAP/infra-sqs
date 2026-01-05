region = "us-east-1"

# Tags
tags = {
  Owner = "nexTime-food"
}

sqs_queues = {
  "order-queue" = {
    queue_name                 = "order-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  },
  "order-callback-queue" = {
    queue_name                 = "order-callback-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  },
  "production-queue" = {
    queue_name                 = "production-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  },
  "production-callback-queue" = {
    queue_name                 = "production-callback-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  },
  "payment-queue" = {
    queue_name                 = "payment-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  },
  "payment-callback-queue" = {
    queue_name                 = "payment-callback-queue"
    delay_seconds              = 0
    max_message_size           = 262144
    message_retention_seconds  = 345600
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 30
    max_receive_count          = 3
    enable_queue_policy        = false
  }
}

# SNS Topics
# sns_topics = {
#   "order-topic" = {
#     topic_name   = "order-topic"
#     display_name = "Order Notifications Topic"
#     subscriptions = {
#       "email-subscription" = {
#         protocol = "email"
#         endpoint = "orders@example.com"
#       },
#       "sqs-subscription" = {
#         protocol             = "sqs"
#         endpoint             = "arn:aws:sqs:us-east-1:123456789012:order-queue"
#         raw_message_delivery = true
#       }
#     }
#   }
# }

