# NACL
resource "aws_network_acl" "main-nacl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
}