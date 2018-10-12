################
# General vars #
################

variable "PL_ENV" {}
variable "PL_REGION" {}
variable "TF_AWS_PROFILE" {}

###########################
# VPC infrastructure vars #
###########################

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

variable "Access_IPs" {
  type    = "list"
}

############
# EC2 vars #
############
variable "EFS_Mount_Dir" {}
variable "Instance_Type" {}
variable "Key_Name" {}
