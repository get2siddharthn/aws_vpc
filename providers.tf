terraform {
  required_providers {
    #select provider as AWS
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  #Mention access key for aws user in credential file --> /.aws/conf
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terra"
}