
output "PubSubnets" {
  value = "${join(", ", module.vpc_infra.PubSubnets)}"
}

output "PrivSubnets" {
  value = "${join(", ", module.vpc_infra.PrivSubnets)}"
}

output "VPC_id" {
  value = "${module.vpc_infra.VPC_id}"
}

output "NLB_DNS_Name" {
  value = "${module.bastion.NLB_DNS_Name}"
}

output "EFS_id" {
  value = "${module.bastion.EFS_id}"
}

output "EFS_DNS_Name" {
  value = "${module.bastion.EFS_DNS_Name}"
}
