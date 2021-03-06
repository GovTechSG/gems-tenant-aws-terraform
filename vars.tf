variable "region" {
  default = "ap-southeast-1"
}
//insert aws access key here
variable "access_key" {
  default = ""
}

//insert aws secret key here
variable "secret_key" {
  default = ""
}

variable "instance_sizes" {
  default = "t2.micro"
}

variable "db_size" {
  default = "t2.micro"
}

//insert tag to be used for tagging the instances/loadbalancers and other aws resources. You can name it to
// anything like project_tag etc..
variable "gems_tag" {
  default = "gems"
}

variable "vpc_cidr_ip" {
  default = "172.70"
}

variable "aws_ami_id" {
  default = "ami-0b4dd9d65556cac22"
}
//insert ARN of cert to be used for load balancer
variable "cert_id" {
  default = ""
}
//insert kong database admin username
variable "database_admin_username"{
  default = ""
}
//insert kong database admin password
variable "database_admin_password"{
  default = ""
}
//insert kong manager superadmin password
variable "portal_admin_password"{
  default = ""
}
//insert kong license for enterprise edition
variable "portal_license"{
  default = ""
}

variable "manager_auth_conf"{
  default = "'{\"cookie_name\":\"04tm34l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'"
}

variable "dev_portal_auth_conf"{
  default = "'{\"cookie_name\":\"04tm35l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'"
}
//insert the route53 domain to be used e.g. example.io
variable "route53_domain" {
  default = ""
}
//insert kong gateway uri e.g. gateway.example.io
variable "gateway_uri"{
  default = ""
}

//insert kong admin api uri e.g. admin.example.io
variable "admin_api_uri"{
  default = ""
}

//insert kong manager uri e.g. manager.example.io
variable "manager_uri"{
  default = ""
}

//insert kong dev portal ay uri e.g. devportal.example.io
variable "dev_portal_uri"{
  default = ""
}

//insert kong dev portal api uri e.g. devapi.example.io
variable "dev_portal_api_uri"{
  default = ""
}
//the ip of your current machine or the source to which access to it is allowed for both SSH and browser access
variable "provider_ip"{
  default = ""
}
//name of the key used to SSH into the instances e.g. awskong
variable "key_name"{
  default = ""
}
//path to the pem file used for SSH into instances e.g. ~/awskong.pem
variable "path_to_pem_file"{
  default = ""
}

variable "dev_portal_auth_config" {
  default = ""
}
