# 1.Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terra_VPC"
  }
}


# 2.Create the Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terra_Subnet"
  }
}

# 3.Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terra_InternetGateway"
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
    Name = "terra_RouteTable"
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
    for_each = [22, 80, 443,5000]
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
#resource "aws_instance" "example" {
#  ami             = data.aws_ami.ubuntu.id
#  instance_type   = var.instance_type
#  key_name        = var.key_name
#  subnet_id       = aws_subnet.main.id
#  security_groups = [aws_security_group.allow_ssh.id]
#
#  #user_data = file("file.sh")
#  tags = {
#    Name = "web-server"
#  }

  #Enable detailed monitoring
  #monitoring = true
#}

 
#s3 bucket creation
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terra-bucket666"

  versioning {
    enabled = true
  }
}


#community module s3
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15" 

  bucket = "my_bucket895565"

  acl    = "private"

  versioning = {
    enabled = true
  }
}





#resource "null_resource" "post_config" {
#  connection {
#    type        = "ssh"
#    host        = aws_instance.example.public_ip
#    user        = "ubuntu"
#    private_key = file("/home/ncs/Downloads/ansiblekey.pem")
#  }
#  provisioner "file" {
#    source      = "/home/ncs/Anil/web_app_deploy_script/bash/example_deployment.sh"
#    destination = "/tmp/example_deployment.sh"
#  }

#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/example_deployment.sh",
#      "sudo /tmp/example_deployment.sh"
#    ]
#  }


#  triggers = {
#    instance_id = length(aws_instance.example.id) > 0 ? "instance created" : "not created"
#  }
#}



