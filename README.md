###
Information
1. Terraform version > 0.12
2. Terraform provider.aws  => v2.26.0

###
Prior to running this terraform please ensure the following is present.
1. A Public hosted zone in route 53 (For example, gemsapi.io)
2. A Certificate under Amazon Certificate Manager (For example, *.gemsapi.io)
3. AWS access key and secret key
4. Pem file for ssh into the provisioned EC2 Instance (For example, awskong.pem)

###
Steps
1. Download the latest version of Terraform
2. Terraform init
3. Terraform plan
4. Terraform apply
5. Terraform destroy (to remove)