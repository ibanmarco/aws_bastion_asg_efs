output "PubSubnets" {
  value = "${aws_subnet.pub_subnets.*.id}"
}

output "PrivSubnets" {
  value = "${aws_subnet.priv_subnets.*.id}"
}

output "VPC_id" {
  value = "${aws_vpc.bastion_vpc.id}"
}
