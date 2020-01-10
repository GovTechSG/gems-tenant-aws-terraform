## Kong Terraform Quickstart with AWS

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Terraform template to install Kong with AWS resources and Docker.

### Information
1. Terraform version > 0.12
2. Terraform provider.aws  => v2.26.0

### Docker Images

This template is tested with Kong enterprise, thus we hosted the pre-baked image in our own dockerhub repository. 

**Disclaimer** : Please purchase a valid license if you intend to run Kong Enterprise

For your testing, You can retrive the latest Kong CE docker images @ https://hub.docker.com/_/kong.

### Variables
Please refer to secret.tfvars.example for the required variables.

### Prerequisite 
Prior to running this terraform please ensure the following is present.
1. A Public hosted zone in route 53 (For example, gemsapi.io)
2. A Certificate under Amazon Certificate Manager (For example, *.gemsapi.io)
3. AWS access key and secret key
4. Pem file for ssh into the provisioned EC2 Instance (For example, awskong.pem)

### Summary of Steps
1. Download the latest version of Terraform
2. Terraform init
3. Terraform plan
4. Terraform apply
5. Terraform destroy (to remove)

#### Running Terraform Init
To init terraform run the following command :

```
terraform init -backend-config="access_key=<access key here>" -backend-config="secret_key=<secret key here>"
```

#### Running Terraform Plan
For plan ,apply and destroy run with the flag ```-var-file=secret.tfvars``` where your local secret.tfvars will override default values in vars.tf

Examples :

```
terraform plan -var-file=secret.tfvars
```

```
terraform apply -var-file=secret.tfvars
````

```
terraform destroy -var-file=secret.tfvars
````