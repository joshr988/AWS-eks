resource "aws_security_group" "eks-cluster" {
  name        = "eks-cluster-security-group"
  description = "Security group for the EKS cluster"
  vpc_id      = data.aws_vpc.main.id

  # Define the ingress and egress rules for the security group
  # ...

  tags = {
    Name = "eks-cluster-security-group"
  }
}