terraform {
  backend "s3" {
    bucket = "terraform-state-cicd-bucket1"
    key    = "lambda/terraform.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



# Load S3, IAM, and Lambda configurations from respective files


