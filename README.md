### Information
1. Terraform version > 0.12
2. Terraform provider.aws  => v2.26.0

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

#### Running Terraform Plant
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