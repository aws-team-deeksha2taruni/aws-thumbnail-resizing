terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# IAM Policy for Lambda to access S3
resource "aws_iam_policy" "lambda_s3_policy" {
  name   = "LambdaS3Policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::s3-trigger-thumbnail-source-bucket-mnm/*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::s3-trigger-thumbnail-destination-bucket-mnm/*"
      }
    ]
  })
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_s3_role" {
  name               = "LambdaS3Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach custom policy to Lambda role
resource "aws_iam_policy_attachment" "assigning_policy_to_role" {
  name       = "AssigningPolicyToRole"
  roles      = [aws_iam_role.lambda_s3_role.name]
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

# Attach AWSLambdaBasicExecutionRole to Lambda role
resource "aws_iam_policy_attachment" "assigning_lambda_execution_role" {
  name       = "AssigningLambdaExecutionRole"
  roles      = [aws_iam_role.lambda_s3_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Archive Lambda source code
data "archive_file" "thumbnail_lambda_source_archive" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "create_thumbnail_lambda_function" {
  function_name    = "CreateThumbnailLambdaFunction"
  filename         = "${path.module}/lambda_function.zip"
  runtime          = "python3.9"
  handler          = "lambda_handler.lambda_handler"
  memory_size      = 256
  timeout          = 300
  source_code_hash = data.archive_file.thumbnail_lambda_source_archive.output_base64sha256
  role             = aws_iam_role.lambda_s3_role.arn

  layers = [
    "arn:aws:lambda:us-east-1:770693421928:layer:Klayers-p39-pillow:1"
  ]
}

# S3 Buckets
resource "aws_s3_bucket" "thumbnail_images_source_bucket" {
  bucket = "s3-trigger-thumbnail-source-bucket-mnm"
}

resource "aws_s3_bucket" "thumbnail_images_destination_bucket" {
  bucket = "s3-trigger-thumbnail-destination-bucket-mnm"
}

# Lambda Permission for S3 Invocation
resource "aws_lambda_permission" "thumbnail_allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_thumbnail_lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.thumbnail_images_source_bucket.arn
}

# S3 Notification to trigger Lambda
resource "aws_s3_bucket_notification" "thumbnail_notification" {
  bucket = aws_s3_bucket.thumbnail_images_source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.create_thumbnail_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.thumbnail_allow_bucket
  ]
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "create_thumbnail_lambda_function_cloudwatch" {
  name              = "/aws/lambda/${aws_lambda_function.create_thumbnail_lambda_function.function_name}"
  retention_in_days = 30
}


