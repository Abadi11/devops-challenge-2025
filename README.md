# 💪 DevOps Challenge 2025 – AWS + Terraform + GitHub Actions

DevOps Challenge June 2025.

## ✅ Check The Status of Runs

### Check The Status Of Deployment
- [![Deploy Web Application To AWS](https://github.com/Abadi11/devops-challenge-2025/actions/workflows/deploy-aws.yml/badge.svg?branch=main)](https://github.com/Abadi11/devops-challenge-2025/actions/workflows/deploy-aws.yml)

### Check The Status of Test
- [![Test Deploy Web Application To AWS](https://github.com/Abadi11/devops-challenge-2025/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/Abadi11/devops-challenge-2025/actions/workflows/test.yml)

## ☁️ Cloud Platform
**AWS** – Chosen for its popularity and beginner-friendly free tier with EC2.

### 🏗️ Infrastructure Services
- **EC2 Instance:** Amazon Linux 2, lightweight, cost-effective, and compatible with Apache.
- **Security Group:** Allows HTTP traffic (port 80) from anywhere.
- **User Data Script:** Automatically installs Apache and deploys a static `index.html`. 

## 🔧 Infrastructure Tool
- **Terraform** – Used for defining reproducible, version-controlled infrastructure.
- **Module** - The infrastructure built in a local module. Then the module has been called in the root.

### 🖥️ Resources Defined In The Module
- EC2 instance (Amazon Linux 2) With User data script to serve a static HTML file via Apache.
- The module supports multi availability zones.

```terraform
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

```
- Security Group allowing port 80 from anywhere:

```terraform
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

```
- Default Subnet as it is required in terraform:

```terraform
 resource "aws_default_subnet" "default_subnet" {
  count             = length(var.availability_zones)
  availability_zone = "${var.aws_region}${var.availability_zones[count.index]}"

  tags = var.subnet_tags
}
```

### 🤙 Call The Module

```terraform
 module "deploy_web_app" {
  source = "./modules/deploy-app-aws"

  # AMI Resources Arguments
  ami_id            = "..."
  availability_zones = ["..."]
  html_file_path    = "..."

  ami_tags = {
    tag1  = "..."
  }

  # Security Groups Argument
  sg_name        = "..."
  sg_description = "..."
  ingress        = var.ingress
  egress         = var.egress

  # Default Subnet
  subnet_tags = {
    tag1 = "..."
  }
}
```

## 🧪 Terraform Test

- Add terraform native test (main.tftest.hcl) using terraform test.

```hcl
  run "test_web_app_deploy" {
  command = apply

  # Test the availability_zone is in lower case and one of a, b, and c.
  assert {
    condition = alltrue([
      for zone in local.availability_zones : contains(local.default_availability_zones, zone)
    ])
    error_message = "availability_zone should be a, b or c in lowercase"
  }


  # Test the public_ip output of the module.
  assert {
    condition = alltrue([
      for ip in module.deploy_web_app.web_app_public_ip : strcontains(ip, ".")
    ])
    error_message = "Public IP output is not valid"
  }
}
```

- run `terraform test` to test the infrastructure

## 🚀 How to Deploy

[View GitHub Actions Deploy Workflow](.github/workflows/deploy-aws.yml)

or locally:

```bash
terraform init
terraform plan
terraform apply
```