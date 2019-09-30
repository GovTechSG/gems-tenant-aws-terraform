provider "aws" {
  region  = "${var.region}"
  access_key =  "${var.access_key}"
  secret_key = "${var.secret_key}"
}
resource "aws_s3_bucket" "gems-terraform-s3" {
    bucket = "gems-terraform-s3"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = false
    }    
}