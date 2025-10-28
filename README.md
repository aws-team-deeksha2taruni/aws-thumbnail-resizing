#Using AWS S3 trigger to create thumbnail image

This project demonstrates how to automatically resize images uploaded to an Amazon S3 bucket using AWS Lambda. When a new image is added to the source bucket, the Lambda function is triggered, generates a thumbnail, and stores it in a destination bucket — all provisioned using Terraform.

To set up this workflow, you’ll need:

1.An AWS Account (Free Tier or Enterprise)

2.Terraform installed on your machine

3.Basic knowledge of AWS services like S3, Lambda, IAM, and CloudWatch

Steps to Complete the Project

1.Create Two Amazon S3 Buckets

One bucket for uploading original images.Another bucket for storing generated thumbnails Upload a sample JPG or PNG image to the source bucket for testing.

2.Write the Lambda Function

The function reads the uploaded image, resizes it to a thumbnail (e.g., 500×500), and saves it to the destination bucket.It uses the Pillow (PIL) library for image processing.

3.Define IAM Permissions

Create a policy that allows the Lambda function to read from the source bucket, write to the destination bucket, and log to CloudWatch.Create an IAM role with a trust relationship for lambda.amazonaws.com and attach the policy.

4.Package and Deploy the Lambda Function

Bundle the Python code and dependencies into a ZIP file.Deploy the function using Terraform, referencing the ZIP and IAM role.

5.Configure the S3 Trigger

Set up an S3 event notification that invokes the Lambda function when a new object is created in the source bucket.This can be done via Terraform or the AWS Console.

6.Test the Lambda Function

First, invoke the function manually using a sample event to verify it runs correctly.Then, upload an image to the source bucket and confirm that a thumbnail is generated in the destination bucket.

Terraform Commands

$ terraform init

$ terraform plan

$ terraform apply

$ terraform destroy

AWS CLI Commands $ aws iam list-policies --query 'Policies[?PolicyName == thumbnail_s3_policy]'

$ aws iam list-roles --query 'Roles[?RoleName == thumbnail_lambda_role]'

$ aws lambda list-functions --query 'Functions[?FunctionName == thumbnail_generation_lambda]'

$ aws s3 ls | grep cp-

$ aws s3 ls s3://cp-original-image-bucket

$ aws s3 ls s3://cp-thumbnail-image-bucket

$ aws logs describe-log-groups --query 'logGroups[?logGroupName == /aws/lambda/thumbnail_generation_lambda]'

$ aws logs tail /aws/lambda/thumbnail_generation_lambda

$ aws s3 cp high_resolution_image.jpeg s3://cp-original-image-bucket

$ aws logs tail /aws/lambda/thumbnail_generation_lambda

$ aws s3 ls s3://cp-original-image-bucket

$ aws s3 ls s3://cp-thumbnail-image-bucket

