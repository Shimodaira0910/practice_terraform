# -----------------------
# TerraForm configuration
# -----------------------

terraform {
  required_version = ">=1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------
# Provider
# -----------------------

provider "aws" {
  profile = "terraform-shimodaira"
  region  = "ap-northeast-1"
}

# Variables
# -----------------------
# -----------------------
variable "project" {
  type = string
}

variable "enviroment" {
  type = string
}