terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28.0"
    }
  }

  # Uncomment to configure remote state on S3
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "infra-api/python_api/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}
