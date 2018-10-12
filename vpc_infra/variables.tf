variable "PL_ENV" {}

variable "Main_CIDR" {}
variable "Secondary_CIDRs" {
    default ={}
}

variable "PrivSubnets" {
  type    = "list"
}

variable "PubSubnets" {
  type    = "list"
}

variable "VPC_name" {}
