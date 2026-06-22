packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "bpftrace-lab-ubuntu-24-04-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]  # Canonical
  }
  ssh_username = "ubuntu"
}

build {
  name = "bpftrace-lab"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y --no-install-recommends bpftrace linux-headers-$(uname -r) linux-tools-$(uname -r) bpfcc-tools clang llvm jq",
      "sudo sysctl -w kernel.unprivileged_bpf_disabled=1",
      "sudo sysctl -w kernel.perf_event_paranoid=1"
    ]
  }
}
