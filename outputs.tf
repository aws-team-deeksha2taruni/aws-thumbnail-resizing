output "iam_policy_arn" {
  description = "IAM Policy ARN"
  value       = aws_iam_policy.lambda_s3_policy.arn
}

output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.create_thumbnail_lambda_function.function_name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch Log Group ARN"
  value       = aws_cloudwatch_log_group.create_thumbnail_lambda_function_cloudwatch.arn
}