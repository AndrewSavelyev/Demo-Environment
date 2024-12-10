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
    encrypt        = true
    bucket         = "asbacket"
    key            = "state/terraform.tfstate"   
    dynamodb_table = "terraform-as-lock-table"
    region         = "us-east-1"          
  }
}

provider "aws" {
  region         = "us-east-1" 
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}