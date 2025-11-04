/* Define the AWS Lambda function resource.
This creates a Lambda function named "image_resizer_lambda"
using the deployment package "lambda_function.zip", Python 3.9 runtime,
and the IAM role arn specified in aws_iam_role.lambda_role.
 */
resource "aws_lambda_function" "image_resizer" {
  filename         = "lambda_function.zip"
  function_name    = "image_resizer_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.original_images.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.original_images.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
