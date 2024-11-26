terraform {
  required_providers {

    # Installing terraform provider for AWS 
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"    
    }
  }

  # Configuring the S3 backend, tfstate file location and dynamodb table for locking
  backend "s3" {
    bucket         = "asavbacket"
    encrypt        = true
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    access_key     = "AKIAX5ZI55F3IQW4NHXC,tDg"
    secret_key     = "UgX+cLt27W1yqwopSqsJG5ZezIqCkz9FmhhB"
    dynamodb_table = "terraform-asavelyev-lock-table"
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key    = "AKIAX5ZI55F3IQW4NHXC,tDg"
  secret_key    = "UgX+cLt27W1yqwopSqsJG5ZezIqCkz9FmhhB"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}