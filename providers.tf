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
  region                   = "ap-south-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terra"
}