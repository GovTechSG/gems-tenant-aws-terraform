# GEMS AWS Terraform Blueprint

Terraform scripts for Kong EE deployment in AWS. These scripts will help to spin up a set of Kong Enterprise containers deployed in AWS with the necessarycd resource and service configurations.

## Requirements

1. Go 1.12
2. Terraform 0.10+
3. Download the provider at https://github.com/terraform-providers/terraform-provider-aws

## Usage

1. Insert your aws_access_key and aws_secret_key in vars.tf
2. Just init, plan and apply!

```
terraform init -var-file="secret.tfvars"
terraform plan -var-file="secret.tfvars"

# Running with local vars that store secrets
terraform apply -var-file=secret.tfvars
```

3. Shutting down EC2 instance

If you decided to bring down the EC2 instance after testing, just destroy it by running this :

```
terraform destroy -var-file="secret.tfvars"
```

## TODO
1. Containerize the terraform runtime
2. Integrate with S3 backend
3. Beef up documentations

## License

Government Technology Agency of Singapore (c) [MIT LICENSE ](https://github.com/robincher/gems-tenant-aws-terraform/blob/master/LICENSE)
