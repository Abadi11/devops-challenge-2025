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

variable "availability_zones" {
  type        = list(string)
  description = "Multiple Availability Zones ['a', 'b', 'c'] In Lowercase"
  default     = []

  validation {
    condition = alltrue([
      for zone in var.availability_zones : contains(local.default_availability_zones, zone)
    ])
    error_message = "You Should Set var.enable_multi_availability_zone To Be True and the selected zones should contain a, b, c in lowercases"
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