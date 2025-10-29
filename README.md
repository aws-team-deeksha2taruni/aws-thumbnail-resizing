# Create Thumbnail Images with AWS Lambda & S3 Trigger

This project demonstrates how to create and configure an AWS Lambda function that automatically generates thumbnail images when a new image is uploaded to an Amazon S3 bucket. The Lambda function resizes the image and saves the thumbnail in a same S3 bucket.

## Prerequisites

- AWS account with permissions to create S3 buckets, Lambda functions, IAM roles, and policies.
- AWS CLI installed and configured (optional, you can use AWS Console).
- Python or Node.js installed locally if creating deployment package manually.
- (Windows users) May need Windows Subsystem for Linux (WSL) to use bash commands like `zip`.


## Step 1: Create Source and Destination S3 Buckets

Create bucket:

- **Source bucket**: Where you upload original images.
- **Destination bucket**: Where Lambda will store the generated thumbnails.

picture dalni h.....................

## Step 2: Upload a Test Image to Source Bucket

Upload any JPG or PNG image to your source bucket to test the Lambda function later.

picture dalni h........................

## Step 3: Create a Permissions Policy for Lambda

Create an IAM policy which grants permission for the Lambda function to:

- Read objects from the source S3 bucket
- Write objects to the destination S3 bucket
- Write logs to CloudWatch Logs

Example policy JSON snippet:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::source-bucket-name/*",
        "arn:aws:s3:::destination-bucket-name/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}

































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

