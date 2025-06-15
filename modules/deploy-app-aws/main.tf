# AWS Instance
resource "aws_instance" "web_app" {
  count             = length(var.availability_zones)
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = "${var.aws_region}${var.availability_zones[count.index]}"
  subnet_id         = aws_default_subnet.default_subnet[count.index].id

  user_data = templatefile("${path.module}/scripts/user_data.sh.tpl", {
    htmlPage = file(var.html_file_path)
  })

  vpc_security_group_ids = [aws_security_group.web_app_sg.id]

  tags = var.ami_tags
}

# Security Group
resource "aws_security_group" "web_app_sg" {
  name        = var.sg_name
  description = var.sg_description

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
}

# Default Subnet
resource "aws_default_subnet" "default_subnet" {
  count             = length(var.availability_zones)
  availability_zone = "${var.aws_region}${var.availability_zones[count.index]}"

  tags = var.subnet_tags
}