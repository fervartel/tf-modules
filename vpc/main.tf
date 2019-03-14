# VPC creation
resource "aws_vpc" "tf-vpc"{
  cidr_block            = "${var.vpc_cidr}"
  instance_tenancy      = "${var.vpc_tenancy}"
  enable_dns_hostnames  = true

  tags = {
    Name = "tf-vpc-${var.vpc_env}"
  }
}
# VPC Main ACL association (For layout purposes only. No rules created)
resource "aws_default_network_acl" "tf-acl-vpc" {
  default_network_acl_id = "${aws_vpc.tf-vpc.default_network_acl_id}"

  ingress {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }

    egress {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  
  tags = {
    Name = "tf-acl-vpc-${var.vpc_env}"
  }
}
# VPC Main Route Table association (For layout purposes only. No rules created)
resource "aws_default_route_table" "tf-rt-vpc" {
  default_route_table_id = "${aws_vpc.tf-vpc.default_route_table_id}"
/* 
  route {
    # ...
  }
 */
  tags = {
    Name = "tf-rt-vpc-${var.vpc_env}"
  }
}
# VPC Main Security Group association (For layout purposes only. No rules created)
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.tf-vpc.id}"
  
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-sg-vpc-${var.vpc_env}"
  }
}
# Public subnets creation
resource "aws_subnet" "tf-subnet-pub" {
  count = "${length(var.subnet_cidr_pub)}"
  #availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  vpc_id     = "${aws_vpc.tf-vpc.id}"
  #cidr_block = "${element(var.subnet_cidr_pub, count.index)}"
  cidr_block = "${var.subnet_cidr_pub[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-pub-${count.index + 1}-${var.vpc_env}"
  }
}
# Private subnets creation
resource "aws_subnet" "tf-subnet-pri" {
  count = "${length(var.subnet_cidr_pri)}"
  #availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"
  availability_zone = "${data.aws_availability_zones.azs.names[count.index]}"
  vpc_id     = "${aws_vpc.tf-vpc.id}"
  #cidr_block = "${element(var.subnet_cidr_pri, count.index)}"
  cidr_block = "${var.subnet_cidr_pri[count.index]}"

  tags = {
    Name = "tf-subnet-pri-${count.index + 1}-${var.vpc_env}"
  }
}
# Internet Gateway creation
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = "${aws_vpc.tf-vpc.id}"

  tags = {
    Name = "tf-igw-${var.vpc_env}"
  }
}
# Public Routing Table creation
resource "aws_route_table" "tf-rt-pub" {
    vpc_id = "${aws_vpc.tf-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.tf-igw.id}"
    }

    tags {
        Name = "tf-rt-pub-${var.vpc_env}"
    }
}
# Private Routing Table creation (For layout purposes only. No NAT instance or NAT gateway created)
resource "aws_route_table" "tf-rt-pri" {
    vpc_id = "${aws_vpc.tf-vpc.id}"
/* 
    # Creates the route to use a NAT Instance with the Pri subnets
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
 */
    tags {
        Name = "tf-rt-pri-${var.vpc_env}"
    }
}
# Route Table association with Public Subnets
resource "aws_route_table_association" "tf-rt-pub" {
    count = "${length(var.subnet_cidr_pub)}"
    #subnet_id = "${element(aws_subnet.tf-subnet-pub.*.id, count.index)}"
    subnet_id = "${aws_subnet.tf-subnet-pub.*.id[count.index]}"
    route_table_id = "${aws_route_table.tf-rt-pub.id}"
}
# Route Table association with Private Subnets
resource "aws_route_table_association" "tf-rt-pri" {
    count = "${length(var.subnet_cidr_pri)}"
    #subnet_id = "${element(aws_subnet.tf-subnet-pri.*.id, count.index)}"
    subnet_id = "${aws_subnet.tf-subnet-pri.*.id[count.index]}"
    route_table_id = "${aws_route_table.tf-rt-pri.id}"
}