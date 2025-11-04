# Grant S3 permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
# Unique identifier for the permission statement
  statement_id  = "AllowS3Invoke"
  
  # Action that allows Lambda to be invoked
  action        = "lambda:InvokeFunction"
  
  # Name of the Lambda function to be invoked
  function_name = aws_lambda_function.image_resizer.function_name
  
  # Principal (the AWS service) that can invoke the Lambda — here, Amazon S3
  principal     = "s3.amazonaws.com"
  
  # ARN of the S3 bucket that is allowed to invoke the Lambda
  source_arn    = aws_s3_bucket.original_images.arn
}

# Configure S3 bucket notifications to trigger the Lambda function
resource "aws_s3_bucket_notification" "bucket_notification" {
  # The S3 bucket where notifications will be set up
  bucket = aws_s3_bucket.original_images.id

# Define the Lambda function trigger configuration
  lambda_function {
    # ARN of the Lambda function to be invoked
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    
    # Event type — triggers the Lambda when a new object is created in the bucket
    events              = ["s3:ObjectCreated:*"]
  }

  # Ensure permission is created before setting up notification
  depends_on = [aws_lambda_permission.allow_s3]
}
