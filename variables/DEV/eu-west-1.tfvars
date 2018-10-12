Main_CIDR = "172.16.16.0/21"

Secondary_CIDRs = {
    CIDR1 = "192.178.6.0/24"
    CIDR2 = "192.178.7.0/24"
    CIDR3 = "192.178.8.0/24"
}

PrivSubnets = [
	{
      name = "01"
      az   = "eu-west-1a"
      cidr = "192.178.6.0/25"
    },
    {
      name = "02"
      az   = "eu-west-1b"
      cidr = "192.178.7.0/25"
    },
    {
      name = "03"
      az   = "eu-west-1c"
      cidr = "192.178.8.0/25"
    },
]

PubSubnets = [
	{
      name = "01"
      az   = "eu-west-1a"
      cidr = "172.16.16.0/25"
    },
    {
      name = "02"
      az   = "eu-west-1b"
      cidr = "172.16.17.0/25"
    },
    {
      name = "03"
      az   = "eu-west-1c"
      cidr = "172.16.18.0/25"
    },
]

VPC_name = "Bastion-ASG-EFS-VPC"

Access_IPs = ["MY_PUBLIC_IP_ADDRESS"]

Instance_Type = "t2.micro"
Key_Name = "terraform"

EFS_Mount_Dir = "/mnt/bastion_efs"
