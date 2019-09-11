variable "region" {
  default = "ap-southeast-1"
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "gems_tag" {
  default = "Gems_Tenant_Dev"
}

variable "vpc_id" {
  default = ""
}

variable "vpc_cidr_ip" {
  default = "172.70"
}

variable "aws_ami_id" {
  default = "ami-0b4dd9d65556cac22"
}

variable "cert_id" {
  default = "arn:aws:acm:ap-southeast-1:146253758342:certificate/8a089a5c-a833-4ef1-b63f-7516e07c91df"
}

variable "database_admin_username"{
  default = "postgres"
}

variable "database_admin_password"{
  default = "Pass1234"
}

variable "portal_admin_password"{
  default = "Pass1234"
}

variable "portal_license"{
  default = "'{\"license\":{\"signature\":\"200b7ce3879831fb8f9ccbdbc72f05aeea1ace05dd6d1643765ef77e221ac1f87accb9ff4ab8ffa2c88b28b95569bf4cd7706ef0f7ea258a55056f929e5b7583\",\"payload\":{\"customer\":\"Govtech_Eval\",\"license_creation_date\":\"2019-07-30\",\"product_subscription\":\"Kong Enterprise Edition\",\"admin_seats\":\"5\",\"support_plan\":\"None\",\"license_expiration_date\":\"2019-08-31\",\"license_key\":\"0011K000029bt6rQAA_a1V1K000007JuyDUAS\"},\"version\":1}}'"
}

variable "manager_auth_conf"{
  default = "'{\"cookie_name\":\"04tm34l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'"
}

variable "dev_portal_auth_conf"{
  default = "'{\"cookie_name\":\"04tm35l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'"
}

variable "gateway_uri"{
  default = "gateway.gemsapi.io"
}

variable "admin_api_uri"{
  default = "adminapi.gemsapi.io"
}

variable "manager_uri"{
  default = "manager.gemsapi.io"
}

variable "dev_portal_uri"{
  default = "devportal.gemsapi.io"
}

variable "dev_portal_api_uri"{
  default = "devportalapi.gemsapi.io"
}

variable "provider_ip"{
  default = "129.126.72.14"
}

variable "key_name"{
  default = "awsgems"
}

variable "path_to_pem_file"{
  default = "~/.ssh/awsgems.pem"
}