terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }


  backend "s3" {
    profile = "default"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    bucket  = "YOUR-BUCKET-NAME"   # create an s3 bucket using the aws cli or the console, then type its name here
  }

}
provider "aws" {
  region = "us-east-1"

}