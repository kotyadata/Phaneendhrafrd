# Provider
provider "aws" {
  region = "us‑east‑1"
}

# SSH Key Pair (upload your public key)
resource "aws_key_pair" "deployer" {
  key_name   = "phaneendhra‑key"
  public_key = file("${path.module}/phaneendhra.pub")
}

# Security Group to allow HTTP, SSH, ICMP
resource "aws_security_group" "web_access" {
  name        = "allow_http_icmp_ssh"
  description = "Allow HTTP, ICMP, and SSH inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP (Ping)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami‑0157af9aea2eef346"  # Amazon Linux 2023 AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  security_groups        = [aws_security_group.web_access.name]

  user_data = <<‑EOF
              #!/bin/bash
              yum update -y
              # Install Docker
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              # Install Git
              yum install -y git
              # Clone your app repo
              cd /home/ec2-user
              git clone https://github.com/kotyadata/Phaneendhrafrd.git app
              cd app
              docker build -t node-app .
              docker run -d -p 80:3000 node-app
              EOF

  tags = {
    Name = "Terraform‑EC2‑NodeApp"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  description = "Public IP of web instance"
  value       = aws_instance.web.public_ip
}
