module "deploy_web_app" {
  source = "./modules/deploy-app-aws"

  # AMI Resources Arguments
  ami_id             = local.ami_id
  availability_zones = local.availability_zones
  html_file_path     = "${path.module}/index.html"

  ami_tags = {
    provider = "aws"
    service  = "ec2"
  }

  # Security Groups Arguments
  sg_name        = "web-app-sg"
  sg_description = "Allow HTTP Traffic"
  ingress        = var.ingress
  egress         = var.egress

  # Default Subnet Arguments
  subnet_tags = {
    name = "Default subnet for us-west-2a"
  }
}