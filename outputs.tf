# Output for IAM Policy ARN
output "iam_policy_arn" {
  description = "The ARN of the IAM policy attached to the Lambda function"
  value       = aws_iam_policy.lambda_policy.arn
}

# Output for Lambda Function Name
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.image_resizer.function_name
}

# Output for Lambda Function ARN
output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.image_resizer.arn
}

# Optional: Output for IAM Role ARN (helpful for debugging)
output "lambda_role_arn" {
  description = "The ARN of the IAM role assumed by Lambda"
  value       = aws_iam_role.lambda_role.arn
}

