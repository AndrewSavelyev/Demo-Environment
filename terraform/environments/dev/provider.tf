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
    access_key     = "AKIAX5ZI55F3KFNU5B6E"
    secret_key     = "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"
    dynamodb_table = "terraform-asavelyev-lock-table"
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key    = "AKIAX5ZI55F3KFNU5B6E"
  secret_key    = "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"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}