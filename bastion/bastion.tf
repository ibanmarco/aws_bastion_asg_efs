resource "aws_security_group" "bastion_public_sg" {
  vpc_id      = "${var.VPC_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["${var.Access_IPs[0]}"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["${var.Access_IPs[0]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name            = "bastion_Public_SG"
    Environment     = "${var.PL_ENV}"
    Project         = "bastion Deploy Workshop"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }

}

resource "aws_security_group" "efs_sg" {
  name        = "Bastion-EFS-SG"
  vpc_id      = "${var.VPC_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = ["${aws_security_group.bastion_public_sg.id}"]
  }

  tags {
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_efs_file_system" "bastion_efs" {
  tags {
    Name            = "Bastion_EFS"
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_efs_mount_target" "bastion_efs_mount" {
  count                   = "3"
  file_system_id          = "${aws_efs_file_system.bastion_efs.id}"
  subnet_id               = "${element(var.PubSubnet_Ids, count.index)}"
  security_groups         = ["${aws_security_group.efs_sg.id}"]
}

data "aws_ami" "bastion_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

data "template_file" "bastion_userdata" {
  template = "${file("bastion/bastion_userdata.tpl")}"

  vars {
    efs_id = "${aws_efs_mount_target.bastion_efs_mount.0.file_system_id}"
    efs_dns = "${aws_efs_mount_target.bastion_efs_mount.0.dns_name}"
    mount_dir = "${var.EFS_Mount_Dir}"
  }
}

resource "aws_lb" "bastion_nlb" {
  name                        = "Bastion-NLB"
  internal                    = false
  load_balancer_type          = "network"
  ip_address_type             = "ipv4"
  subnets                     = ["${var.PubSubnet_Ids}"]
  enable_deletion_protection  = false

  tags {
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_lb_target_group" "bastion_nlb_tg" {
  name     = "Bastion-NLB-TargetGroup"
  port     = "22"
  protocol = "TCP"
  vpc_id   = "${var.VPC_id}"
  deregistration_delay = "300"
  health_check {
    interval = "30"
    port = "22"
    protocol = "TCP"
    healthy_threshold = "10"
    unhealthy_threshold= "10"
  }

  tags {
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_lb_listener" "bastion_nlb_listener" {
  load_balancer_arn = "${aws_lb.bastion_nlb.arn}"
  port              = "22"
  protocol          = "TCP"
  default_action {
    target_group_arn = "${aws_lb_target_group.bastion_nlb_tg.arn}"
    type             = "forward"
  }
}

resource "aws_launch_configuration" "bastion_launch_config" {
  name                        = "Bastion-LC"
  image_id                    = "${data.aws_ami.bastion_ami.id}"
  #user_data                   = "${file("bastion/bastion_install.sh")}"
  user_data                   = "${data.template_file.bastion_userdata.rendered}"
  key_name                    = "${var.Key_Name}"
  instance_type               = "${var.Instance_Type}"
  security_groups             = ["${aws_security_group.bastion_public_sg.id}"]
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "asg" {
  name  = "Bastion-ASG"
  min_size  = 1
  desired_capacity  = 1
  max_size  = 2
  launch_configuration = "${aws_launch_configuration.bastion_launch_config.name}"
  target_group_arns = ["${aws_lb_target_group.bastion_nlb_tg.arn}"]
  vpc_zone_identifier = ["${var.PubSubnet_Ids}"]
  default_cooldown= 180
  health_check_grace_period = 180
  termination_policies = ["ClosestToNextInstanceHour", "NewestInstance"]

  tags = [
    {
      key                 = "Environment"
      value               = "${var.PL_ENV}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "Bastion + ASG + EFS"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "Bastion-SSH"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "Iban Marco - ibanmarco@gmail.com"
      propagate_at_launch = true
    },
  ]
}
