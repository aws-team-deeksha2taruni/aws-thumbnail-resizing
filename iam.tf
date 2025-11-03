# IAM Role: AWS Lambda Execution Role
# Purpose: Grants Lambda function permissions to interact with CloudWatch logs and S3 buckets
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_image_resizer_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy: Permissions for Lambda
# Grants permissions to create logs and access specified S3 buckets
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_s3_image_resizer_policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"  # CloudWatch log permissions
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.original_images.arn + "/*",  # Access to original images bucket
          aws_s3_bucket.resized_images.arn + "/*"   # Access to resized images bucket
        ]
      }
    ]
  })
}

# Attach the IAM Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
