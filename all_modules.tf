module "vpc_infra" {
  source          = "./vpc_infra"
  PL_ENV              = "${var.PL_ENV}"
  Main_CIDR           = "${var.Main_CIDR}"
  Secondary_CIDRs     = "${var.Secondary_CIDRs}"
  PrivSubnets         = "${var.PrivSubnets}"
  PubSubnets          = "${var.PubSubnets}"
  VPC_name            = "${var.VPC_name}"
}

module "bastion" {
  source              = "./bastion"
  PL_ENV              = "${var.PL_ENV}"
  VPC_id              = "${module.vpc_infra.VPC_id}"
  PubSubnet_Ids       = "${module.vpc_infra.PubSubnets}"
  PubSubnets          = "${var.PubSubnets}"
  EFS_Mount_Dir       = "${var.EFS_Mount_Dir}"
  Instance_Type       = "${var.Instance_Type}"
  Key_Name            = "${var.Key_Name}"
  Access_IPs          = "${var.Access_IPs}"
}
