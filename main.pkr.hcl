packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "myimage"{
    ami_name = "myimage_{{timestamp}}"
    source_ami_filter {
        filters = {
            virtualization-type = "hvm"
            name = "amzn2-ami-kernel-5.10-hvm-2.*.1-x86_64-gp2"
            root-device-type = "ebs"
        }
        owners = ["137112412989"]
        most_recent = true
    }    
    instance_type = "${var.instance_type}"
    region = "${var.region}"
    ssh_username = "ec2-user"
}

build {
    sources = ["source.amazon-ebs.myimage"]
    provisioner "shell" {
        inline = ["sudo touch /root/myfile "]
    }
    provisioner "shell" {
        script       = "./script.sh"
        pause_before = "10s"
        timeout      = "10s"
    }
} 