variable "aws_region" {
  type        = string
  description = "AWS Region To Deploy The Resources"
  default     = "eu-west-2" # I think this is the closest Zone to Scotland In London
}

variable "ami_id" {
  type        = string
  description = "EC2 Instance ID"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone, a, b or c"
  validation {
    condition     = contains(local.availability_zones, var.availability_zone)
    error_message = "The Value Should Be a, b, or c in lowercase"
  }
}

variable "html_file_path" {
  type        = string
  description = "HTML File To Be Deployed"
  validation {
    condition     = endswith(var.html_file_path, ".html")
    error_message = "The Path File Should End With .html"
  }
}

variable "sg_name" {
  type        = string
  description = "Security Group Name"
}

variable "sg_description" {
  type        = string
  description = "Security Group Description"
}

variable "subnet_tags" {
  type        = object({})
  description = "Subnet Tags, optional"
  default     = {}
}

variable "ami_tags" {
  type        = object({})
  description = "Subnet Tags, optional"
  default     = {}
}

variable "ingress" {
  description = "Allow Inbound Traffic"

  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "egress" {
  description = "Allow Outbound Traffic"

  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}