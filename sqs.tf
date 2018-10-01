resource "aws_sqs_queue" "first_queue" {
  name                       = "hibicode-first-queue"
  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 5
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.first_queue_dlq.arn}\",\"maxReceiveCount\":5}"
  delay_seconds              = 0
}

resource "aws_sqs_queue" "first_queue_dlq" {
  name                       = "hibicode-first-queue-dlq"
  visibility_timeout_seconds = 30
  max_message_size           = 262144
  message_retention_seconds  = 1209600
  receive_wait_time_seconds  = 0
}


data "aws_iam_policy_document" "sqs_queue_policy_document" {
  statement {
    sid = "HibicodeSQSQueuesPolicy"

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "SQS:ChangeMessageVisibility",
      "SQS:DeleteMessage",
      "SQS:ListDeadLetterSourceQueues",
      "SQS:PurgeQueue",
      "SQS:ReceiveMessage",
      "SQS:SendMessage",
      "SQS:GetQueueUrl",
    ]

    resources = ["*"]
  }
}

resource "aws_sqs_queue_policy" "first_queue_policy" {
  queue_url = "${aws_sqs_queue.first_queue.id}"
  policy    = "${data.aws_iam_policy_document.sqs_queue_policy_document.json}"
}

resource "aws_sqs_queue_policy" "first_queue_dlq_policy" {
  queue_url = "${aws_sqs_queue.first_queue_dlq.id}"
  policy    = "${data.aws_iam_policy_document.sqs_queue_policy_document.json}"
}