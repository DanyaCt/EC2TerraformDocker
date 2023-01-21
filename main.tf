terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web-server-instance" {
  ami               = data.aws_ami.amazon-linux-2.id
  instance_type     = "t2.micro"
  key_name          = "MyKey"
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  associate_public_ip_address = true
  user_data = file("UserData.sh")
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_eip" "eip_manager" {
  instance = aws_instance.web-server-instance.id
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web-server-instance.id
  allocation_id = aws_eip.eip_manager.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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


resource "aws_cloudwatch_metric_alarm" "MyAlarm" {
  alarm_name                = "MyNewAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}

output "instance_ip" {
  value = aws_instance.web-server-instance.public_ip
}