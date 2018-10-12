output "NLB_DNS_Name" {
  description = "The DNS name of the NLB"
  value       = "${aws_lb.bastion_nlb.dns_name}"
}

output "EFS_id" {
  description = "EFS Id"
  value       = "${aws_efs_mount_target.bastion_efs_mount.0.file_system_id}"
}

output "EFS_DNS_Name" {
  description = "EFS DNS Name"
  value       = "${aws_efs_mount_target.bastion_efs_mount.0.dns_name}"
}
