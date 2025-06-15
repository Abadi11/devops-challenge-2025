locals {
  availability_zones = ["a", "b", "c"]
  availability_zone  = "${var.aws_region}${var.availability_zone}"
}