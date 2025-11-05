
# Configure the AWS provider
provider "aws" {
  region = var.aws_region  # Uses variable defined in variables.tf
}
