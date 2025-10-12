output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.first_vpc.id
  
}

output "vpc_cidr" {
    description = "The CIDR block of the VPC"
    value       = aws_vpc.first_vpc.cidr_block
  
}