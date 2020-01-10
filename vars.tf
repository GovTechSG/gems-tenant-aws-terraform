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

//insert tag to be used for tagging the instances/loadbalancers and other aws resources
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
  default = "gemsapi.io."
}
//insert kong gateway uri e.g. gateway.example.io
variable "gateway_uri"{
  default = "gateway.gemsapi.io"
}

//insert kong admin api uri e.g. admin.example.io
variable "admin_api_uri"{
  default = "adminapi.gemsapi.io"
}

//insert kong manager uri e.g. manager.example.io
variable "manager_uri"{
  default = "manager.gemsapi.io"
}

//insert kong dev portal ay uri e.g. devportal.example.io
variable "dev_portal_uri"{
  default = "devportal.gemsapi.io"
}

//insert kong dev portal api uri e.g. devapi.example.io
variable "dev_portal_api_uri"{
  default = "devportalapi.gemsapi.io"
}
//the ip of your current machine or the source to which access to it is allowed for both SSH and browser access
variable "provider_ip"{
  default = "129.126.72.14"
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
  default = "'{\"leeway\": 100,\"issuer\": \"https://cognito-idp.ap-southeast-1.amazonaws.com/ap-southeast-1_LdD2g2BG3/.well-known/openid-configuration\",\"client_secret\": [\"17931tfpo3ee126i194qk1rji3tq5b1jote16n92easbcht7mp7l\"],\"consumer_by\": [\"username\",\"custom_id\",\"id\"],\"scopes\": [\"openid\",\"profile\",\"email\"],\"logout_query_arg\": \"logout\",\"ssl_verify\": false,\"login_action\": \"redirect\",\"logout_redirect_uri\": [\"https://kongtest4.auth.ap-southeast-1.amazoncognito.com/logout?client_id=m2klbb9tn65roiml6flvj025q&logout_uri=devportal.gemsapi.io/default\"],\"login_tokens\": {},\"login_redirect_uri\": [\"https://devportal.gemsapi.io/default\"],\"forbidden_redirect_uri\": [\"https://devportal.gemsapi.io/default/unauthorized\"],\"client_id\": [\"m2klbb9tn65roiml6flvj025q\"],\"logout_methods\": [\"GET\"],\"consumer_claim\": [\"email\"],\"login_redirect_mode\": \"query\"}'"
}
