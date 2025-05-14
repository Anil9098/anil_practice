output "instance_public_ip" {
  description = "public IP of the EC2 instance"
  value       = aws_instance.example.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "ec2_instance_arn" {
  value = aws_instance.example.arn
}


output "ami_id" {
  value = data.aws_ami.ubuntu.id
}









