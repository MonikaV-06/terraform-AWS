# NACL
resource "aws_network_acl" "main-nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
}

# NACL Rules - Inbound
resource "aws_network_acl_rule" "main-ingress" {
  network_acl_id = aws_network_acl.main-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# NACL Rules - outbound
resource "aws_network_acl_rule" "main-egress" {
  network_acl_id = aws_network_acl.main-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# NACL - Subnet - Association
resource "aws_network_acl_association" "nacl-subnet" {
  network_acl_id = aws_network_acl.main-nacl.id
  subnet_id      = aws_subnet.main-subnet.id
}

# Security Group
resource "aws_security_group" "main-web-sg" {
  name        = "allow-ssh-http"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "main-web-sg"
  }
}

# Security Group Rules
resource "aws_security_group_rule" "main-ssh-rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main-web-sg.id
}

resource "aws_security_group_rule" "main-http-rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main-web-sg.id
}