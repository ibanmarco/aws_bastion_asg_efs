#!/bin/bash
yum -y update
yum -y install nfs-utils.x86_64 amazon-efs-utils
mkdir -p ${mount_dir}
echo "${efs_dns}:/ ${mount_dir} efs tls,_netdev" >> /etc/fstab
mount -a -t efs defaults
mount > /root/efs.txt && df -ha >> /root/efx.txt
