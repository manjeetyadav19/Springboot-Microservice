provider "aws" {
  region = "us-east-2"
  access_key = "xxxxxxxxxxxxxx"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxx"

}

resource "aws_instance" "Manjeet-Cloud" {
  ami = "ami-03a0c45ebc70f98ea"
  instance_type = "t2.medium"
  key_name = "AWSkey1"
  vpc_security_group_ids = [aws_security_group.cloudsg.id]
  tags = {
    Name = "1st_Linux_Machine"
  }
  provisioner "file" {
    source      = "/home/Terraform/script1.sh"
    destination = "/tmp/script1.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/AWSkey1.pem")}"
      host        = "${self.public_dns}"
    }
  }

  # Change permissions on bash script and execute from ec2-user.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script1.sh",
      "sudo sh /tmp/script1.sh",
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/AWSkey1.pem")}"
      host        = "${self.public_dns}"
    }
  }

}

resource "aws_key_pair" "AWSkey2" {
  key_name   = "AWSkey2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0ZwznowT2y7di87LHGzN0ubbxFMls1I5Yv441P1wfl1t+VpI6YBs1tmSOaeEArTJIzGggKUZCXdAbCGqz6ynIeJKvBsXf6Cz0/lA6mxjf3RS9H3pPO0LZfRyiVSekRjV09mdKHMhFIsov8p6wfTLY7t1CW4AlTTkADqMCh4/OIwG+b2Vv1wNr98q2uWeWX2cbtMyKH6AKD+6mlmjKj8Dx2x4q18uEK/PNiHwCt6pHeh6Dh1dKtzPvn7Gu/IiGemFbxTYdAzDWXour3BtE4UuydErcYE9B5AGTrUpENzqEw7BG1rQtfh5jnfLHoQFc/BZwwYMWtKgUv9kiq4eQMy2l"
}

resource "aws_eip" "cloudknowledgeeip" {
  instance = aws_instance.Manjeet-Cloud.id
  vpc = true
}


resource "aws_security_group" "cloudsg" {
  name = "cloudsg"
  description = "Allow TLS Inbound traffic"
  vpc_id = "vpc-75f5741e"

  ingress {
    description = "Tls from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

