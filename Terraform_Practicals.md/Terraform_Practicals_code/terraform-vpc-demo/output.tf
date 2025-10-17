output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.first_vpc.id
  
}

output "vpc_cidr" {
    description = "The CIDR block of the VPC"
    value       = aws_vpc.first_vpc.cidr_block
  
}

output "public_subnet1_id" {
  description = "The ID of the first public subnet"
  value       = [aws_subnet.tf_public_subnet1.id, aws_subnet.tf_public_subnet2.id]
  
}

output "private_subnet1_id" {
  description = "The ID of the first private subnet"
  value       = [aws_subnet.tf_private_subnet1.id, aws_subnet.tf_private_subnet2.id]
  
}