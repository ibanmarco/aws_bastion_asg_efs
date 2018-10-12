variable "PL_ENV" {}

variable "VPC_id" {}
variable "PubSubnet_Ids"  {
  type    = "list"
}
variable "PubSubnets" {
  type    = "list"
}

variable "Instance_Type" {}
variable "Key_Name" {}

variable "EFS_Mount_Dir" {}

variable "Access_IPs" {
  type    = "list"
}
