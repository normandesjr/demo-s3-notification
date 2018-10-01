resource "aws_s3_bucket" "bucket" {
  bucket = "hibicode-bucket-sqs"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"

  queue {
    queue_arn     = "${aws_sqs_queue.first_queue.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "images/"
    id = "image-upload-event"
  }

  queue {
    queue_arn     = "${aws_sqs_queue.first_queue.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "videos/"
    id = "video-upload-event"
  }
}
