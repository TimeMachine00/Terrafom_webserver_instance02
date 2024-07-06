# Webserver

provider "aws" {

  region = "ap-south-1"

}

resource "aws_instance" "web_server" {

  ami           = "ami-04f8d7ed2f1a54b14"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><body><h1>Hello, Users</h1></body></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServerInstance"
  }

  security_groups = [aws_security_group.web_server_sg1.name]

}

resource "aws_security_group" "web_server_sg1" {

  name        = "web_server_sg1"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
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