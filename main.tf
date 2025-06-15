terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {}
provider "random" {}

variable "postmarkServerKey" {
  description = "server key for postmark"
  type        = string
}

resource "random_pet" "postmark_server_key" {
  length = 2
}

resource "aws_ssm_parameter" "postmark_server_key" {
  name        = "/postmark_client/${random_pet.postmark_server_key.id}/server_key"
  description = "server key for postmark"
  type        = "SecureString"
  value       = var.postmarkServerKey
}

data "aws_region" "current" {}

output "postmarkServerKey" {
  value = aws_ssm_parameter.postmark_server_key.arn
}

output "POSTMARK_SERVER_KEY" {
  value = aws_ssm_parameter.postmark_server_key.arn
}

