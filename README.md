# GEMS

Terraform scripts for Kong EE deployment in AWS. These scripts will help to spin up a set of Kong Enterprise containers deployed in AWS with the necessary resource and service configurations.

## Requirements

1. Go 1.12
2. Terraform 0.10+
3. Download the provider at https://github.com/terraform-providers/terraform-provider-aws

## Usage

1. Insert your aws_access_key and aws_secret_key in vars.tf
1. Just init, plan and apply!

## TODO

1. Add load balancers security group
2. Add load balancers
3. Install Kong into each VM
4. Containerize the terraform runtime
5. Integrate with S3 backend
6. Beef up documentations
