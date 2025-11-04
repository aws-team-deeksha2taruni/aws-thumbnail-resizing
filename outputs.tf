# Output IAM Policy ARN
output "iam_policy_arn" {
  description = "IAM Policy ARN"
  value       = aws_iam_policy.lambda_policy.arn
}

# Output Lambda Function Name
output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.image_resizer.function_name
}
