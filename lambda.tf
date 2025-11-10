# Lambda function configuration
resource "aws_lambda_function" "image_resizer" {
  function_name = "image_resizer_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  # Path to deployment package (ZIP file)
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  # Environment variables for Lambda
  environment {
    variables = {
      THUMBNAIL_BUCKET = aws_s3_bucket.resized_images.bucket
    }
  }

  # Include pre-built Pillow layer for Python 3.12
  layers = [
    "arn:aws:lambda:ap-south-1:764866452798:layer:Klayers-python3.12-Pillow:40"
  ]
}

# Allow S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.original_images.arn
}

# Configure S3 bucket notification to trigger Lambda when a new image is uploaded
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.original_images.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
