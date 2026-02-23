variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}

variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}

variable "app_name" {
  default = "global-app"
}

variable "container_port" {
  default = 3000
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  sensitive = true
}