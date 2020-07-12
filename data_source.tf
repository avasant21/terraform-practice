# AMI Lookup
data "aws_ami" "CENTOS7_BASE" {
  most_recent = true
  owners      = ["161831738826"]
  filter {
    name      = "name"
    values    = ["centos-7-base-*"]
  }
}

# VPC Lookup
data "aws_vpc" "VPC_ID" {
  default     = true
}