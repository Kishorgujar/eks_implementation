terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Update this to a compatible version as needed
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  required_version = ">= 1.0.0" # Set this to your desired Terraform version
}

provider "aws" {
  region = "ap-south-1"
}