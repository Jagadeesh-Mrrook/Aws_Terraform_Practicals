terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.0"
}

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "first_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"

    tags = {
        Name = "Terraform-VPC"
        environment = "Dev"
        Owner = "Jagadeesh"
    }
  
}

resource "aws_subnet" "tf_public_subnet1" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.public_subnet_cidr1
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = true


  tags = {
    Name = "terrafrom-public-subnet1"
  }
}

resource "aws_subnet" "tf_public_subnet2" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.public_subnet_cidr2
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet2"
  }
  
}

resource "aws_subnet" "tf_private_subnet1" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.private_subnet_cidr1
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = false

  tags = {
    Name = "terrafrom-private-subnet1"
  }
  
}

resource "aws_subnet" "tf_private_subnet2" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.private_subnet_cidr2
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "terrafrom-private-subnet2"
  }
  
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "terraform-public-rt" {
  vpc_id = aws_vpc.first_vpc.id
 tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route" "Public-Internet" {
  route_table_id = aws_route_table.terraform-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.terraform-igw.id
}

resource "aws_route_table_association" "rta-public-subnet1" {
  subnet_id      = aws_subnet.tf_public_subnet1.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

resource "aws_route_table_association" "rta-public-subnet2" {
  subnet_id      = aws_subnet.tf_public_subnet2.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

resource "aws_route_table" "terraform-private-rt" {
  vpc_id = aws_vpc.first_vpc.id
 tags = {
    Name = "terraform-private-rt"
  }
}

# resource "aws_route" "Public-Internet1" {
#   route_table_id = aws_route_table.terraform-public-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.terraform-nat-gateway1.id
# }

# resource "aws_route" "Public-Internet2" {
#   route_table_id = aws_route_table.terraform-public-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.terraform-nat-gateway2.id
# }
resource "aws_route_table_association" "rta-private-subnet1" {
  subnet_id      = aws_subnet.tf_private_subnet1.id
  route_table_id = aws_route_table.terraform-private-rt.id
}

resource "aws_route_table_association" "rta-private-subnet2" {
  subnet_id      = aws_subnet.tf_private_subnet2.id
  route_table_id = aws_route_table.terraform-private-rt.id
}

# ##Elastic IP-1 for NAT Gateway
# resource "aws_eip" "eip_nat_gateway" {
#   domain = "vpc"

#   tags = {
#     Name = "terraform-eip-nat-gateway1"
#   }
# }

# #NAT Gateway-1 Creation

# resource "aws_nat_gateway" "terraform-nat-gateway1" {
#   allocation_id = aws_eip.eip_nat_gateway.id
#   subnet_id     = aws_subnet.tf_public_subnet1.id

#   tags = {
#     Name = "Terraform-nat-gateway-Subnet1"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.terraform-igw]
# }

# ##Elastic IP-1 for NAT Gateway
# resource "aws_eip" "eip_nat_gateway2" {
#   domain = "vpc"

#   tags = {
#     Name = "terraform-eip-nat-gateway2"
#   }
# }

# #NAT Gateway-2 Creation

# resource "aws_nat_gateway" "terraform-nat-gateway2" {
#   allocation_id = aws_eip.eip_nat_gateway2.id
#   subnet_id     = aws_subnet.tf_public_subnet2.id

#   tags = {
#     Name = "Terraform-nat-gateway-Subnet2"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.terraform-igw]
# }

#Security Group Creation
resource "aws_security_group" "terraform_sg" {
  name        = "Terraform-SG"
  vpc_id      = aws_vpc.first_vpc.id
  tags = {
    Name = "Terraform-SG"
  }
}

#Ingress Rule to allow SSH from within VPC
resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg.id
  description       = "Allow SSH from within VPC"  
}

#Ingress Rule to allow http from anywhere
resource "aws_security_group_rule" "http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg.id
  description       = "Allow SSH from within VPC"  
}

#Ingress Rule to allow https from anywhere
resource "aws_security_group_rule" "https_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg.id
  description       = "Allow SSH from within VPC"  
}


resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_sg.id
  description       = "Allow all outbound traffic"
}


resource "aws_network_acl" "terraform_nacl" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "terraform-nacl"
  }
}

resource "aws_network_acl_rule" "ssh_rule_inbound" {
  network_acl_id = aws_network_acl.terraform_nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "http_rule_inbound" {
  network_acl_id = aws_network_acl.terraform_nacl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "ssh_rule_outbound" {
  network_acl_id = aws_network_acl.terraform_nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "http_rule_outbound" {
  network_acl_id = aws_network_acl.terraform_nacl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}