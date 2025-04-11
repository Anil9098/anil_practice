# 1.Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MainVPC"
  }
}


# 2.Create the Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "MainSubnet"
  }
}

# 3.Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# 4.Create Route Table and Add Route to Internet Gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "MainRouteTable"
  }
}

# 5.Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# 6. Create Security Group for SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 7. Create EC2 Instance within the VPC
resource "aws_instance" "example" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.id]

  #user_data = file("file.sh")
  tags = {
    Name = "web"
  }

  #Enable detailed monitoring
  #monitoring = true
}


#s3 bucket creation
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terra-bucket666"

  versioning {
    enabled = true
  }
}


#fetch an ec2
data "aws_instances" "example" {
  filter {
    name   = "tag:Name"
    values = ["test"]
  }
}



resource "null_resource" "post_config" {
  connection {
    type        = "ssh"
    host        = aws_instance.example.public_ip
    user        = "ubuntu"
    private_key = file("/home/ncs/Downloads/ansiblekey.pem")
  }
  provisioner "file" {
    source      = "/home/ncs/Anil/web_app_deploy_script/bash/example_deployment.sh"
    destination = "/tmp/example_deployment.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/example_deployment.sh",
      "sudo /tmp/example_deployment.sh"
    ]
  }


  triggers = {
    instance_id = aws_instance.example.id
  }
}
























