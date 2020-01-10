provider "aws" {
  region  = "${var.region}"
  access_key =  "${var.access_key}"
  secret_key = "${var.secret_key}"
}


terraform {
    backend "s3" {
        bucket = "gems-terraform-s3"
        region = "ap-southeast-1"
        key = "./terraform.tfstate"
    }
}