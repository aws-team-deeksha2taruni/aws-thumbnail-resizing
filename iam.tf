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
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.original_images.arn,
          "${aws_s3_bucket.original_images.arn}/*",
          aws_s3_bucket.resized_images.arn,
          "${aws_s3_bucket.resized_images.arn}/*"
        ]
      }
    ]
  })
}
