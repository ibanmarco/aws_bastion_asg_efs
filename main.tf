provider "aws" {
  region = "${var.PL_REGION}"
  profile = "${var.TF_AWS_PROFILE}"
}
