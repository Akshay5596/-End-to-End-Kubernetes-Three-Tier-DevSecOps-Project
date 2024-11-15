terraform {
  backend "s3" {
    bucket         = "garba-121"
    region         = "ap-south-1"
    key            = "End-to-End-Kubernetes-Three-Tier-DevSecOps-Project/Jump-Server-TF/terraform.tfstate"
    encrypt        = true
  }

  required_version = ">=0.13.0"

  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}
