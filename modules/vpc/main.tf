resource "aws_vpc" "vpc" {
  count                = var.deploymodule-eks-vpc-standard
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.context}-vpc-${var.environment}"
  }
}

### GENERAZIONE 3 SUBNET PUBBLICHE ###

resource "aws_subnet" "public-a" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 0)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.context}-subnet-public-a-${var.environment}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-b" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}b"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 1)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.context}-subnet-public-b-${var.environment}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-c" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 2)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${var.context}-subnet-public-c-${var.environment}"
    "kubernetes.io/role/elb" = "1"
  }
}

### GENERAZIONE 3 SUBNET PRIVATE ###

resource "aws_subnet" "private-a" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 6)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${var.context}-subnet-private-a-${var.environment}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-b" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}b"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 7)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${var.context}-subnet-private-b-${var.environment}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private-c" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 8)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${var.context}-subnet-private-c-${var.environment}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

### GENERAZIONE 3 SUBNET PRIVATE DEDICATE AL CLUSTER EKS ###

resource "aws_subnet" "cp-private-a" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 13)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-cp-private-a-${var.environment}"
  }
}

resource "aws_subnet" "cp-private-b" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}b"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 14)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-cp-private-b-${var.environment}"
  }
}

resource "aws_subnet" "cp-private-c" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 8, 15)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-cp-private-c-${var.environment}"
  }
}

### GENERARE 3 SUBNET PRIVATE PER WORKER NODES E PODS ###

resource "aws_subnet" "worker-private-a" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 4, 1)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-worker-private-a-${var.environment}"
  }
}

resource "aws_subnet" "worker-private-b" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}b"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 4, 2)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-worker-private-b-${var.environment}"
  }
}

resource "aws_subnet" "worker-private-c" {
  count                   = var.deploymodule-eks-vpc-standard
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet("${var.vpc-cidr-block}", 4, 3)
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.context}-subnet-worker-private-c-${var.environment}"
  }
}

### CREAZIONE INTERNET GW E NAT GW ###

resource "aws_internet_gateway" "igw" {
  count  = var.deploymodule-eks-vpc-standard
  vpc_id = aws_vpc.vpc[0].id
  tags = {
    Name = "${var.context}-igw-${var.environment}"
  }
}

resource "aws_eip" "eip" {
  count      = var.deploymodule-eks-vpc-standard
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.context}-natgw-eip-${var.environment}"
  }
}

resource "aws_nat_gateway" "natgw-a" {
  count         = var.deploymodule-eks-vpc-standard
  subnet_id     = aws_subnet.public-a[0].id
  allocation_id = aws_eip.eip[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.context}-natgw-${var.environment}"
  }
}

### CREAZIONE ROUTE TABLE PUBBLICHE ###

resource "aws_route_table" "route-public" {
  count      = var.deploymodule-eks-vpc-standard
  vpc_id     = aws_vpc.vpc[0].id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.context}-route-public-${var.environment}"
  }
}

resource "aws_route" "route-internet-private" {
  count                  = var.deploymodule-eks-vpc-standard
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw-a[0].id
  route_table_id         = aws_vpc.vpc[0].main_route_table_id
}

resource "aws_route" "route-internet-public" {
  count                  = var.deploymodule-eks-vpc-standard
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
  route_table_id         = aws_route_table.route-public[0].id
}

# ROUTE PUBLIC TO PUBLIC SUBNETS

resource "aws_route_table_association" "association-public-a" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_route_table.route-public[0].id
  subnet_id      = aws_subnet.public-a[0].id
}

resource "aws_route_table_association" "association-public-b" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_route_table.route-public[0].id
  subnet_id      = aws_subnet.public-b[0].id
}

resource "aws_route_table_association" "association-public-c" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_route_table.route-public[0].id
  subnet_id      = aws_subnet.public-c[0].id
}

# ROUTE PRIVATE TO PRIVATE SUBNETS

resource "aws_route_table_association" "association-private-a" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.private-a[0].id
}

resource "aws_route_table_association" "association-private-b" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.private-b[0].id
}

resource "aws_route_table_association" "association-private-c" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.private-c[0].id
}

resource "aws_route_table_association" "association-cp-private-a" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.cp-private-a[0].id
}

resource "aws_route_table_association" "association-cp-private-b" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.cp-private-b[0].id
}

resource "aws_route_table_association" "association-cp-private-c" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.cp-private-c[0].id
}

resource "aws_route_table_association" "association-worker-private-a" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.worker-private-a[0].id
}

resource "aws_route_table_association" "association-worker-private-b" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.worker-private-b[0].id
}

resource "aws_route_table_association" "association-worker-private-c" {
  count          = var.deploymodule-eks-vpc-standard
  route_table_id = aws_vpc.vpc[0].main_route_table_id
  subnet_id      = aws_subnet.worker-private-c[0].id
}
