# Terraform configuration
# Loads provider requirements; actual resources are in other .tf files
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Include provider configuration (defined in providers.tf)
# Include S3, IAM, and Lambda configurations from respective files

