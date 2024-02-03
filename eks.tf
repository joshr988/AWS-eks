resource "aws_iam_role" "cluster" {
  name               = "eks-cluster"
  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids              = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.private1.id, aws_subnet.private2.id]
    security_group_ids      = [aws_security_group.eks-cluster.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }
  depends_on = [aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy]
}

