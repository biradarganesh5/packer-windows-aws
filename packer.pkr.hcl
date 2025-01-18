variable "aws_region" {
  default = "us-east-1"
}

variable "ami_name" {
  default = "custom-windows-ami-new"
}

variable "instance_type" {
  default = "t3.medium"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "windows" {
  region         = var.aws_region
  instance_type  = var.instance_type
  ami_name       = var.ami_name
  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_insecure = true
  winrm_use_ssl  = true
  user_data_file = "winrm_bootstrap.txt"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2025-English-Full-Base-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["801119661308"] # Amazon's official owner ID for Windows AMIs
    most_recent = true
  }

  ami_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name           = "/dev/sdf"
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }
}

build {
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
    script = "install.ps1"
  }
}
