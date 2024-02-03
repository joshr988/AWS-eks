resource "aws_iam_role" "nodes_general" {
  name               = "eks-node-group_general"
  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
POLICY  
}

resource "aws_iam_role_policy_attachment" "nodes_general-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_general.name

}
resource "aws_iam_role_policy_attachment" "nodes_general-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_general.name
}


resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "nodes-general"
  node_role_arn   = aws_iam_role.nodes_general.arn
  subnet_ids      = [aws_subnet.private1.id, aws_subnet.private2.id]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  ami_type             = "AL2_x86_64"
  capacity_type        = "ON_DEMAND"
  disk_size            = 20
  force_update_version = false
  instance_types       = ["t3.medium"]
  labels = {
    "role" = "general"
  }
  version    = "1.28"
  depends_on = [aws_iam_role_policy_attachment.nodes_general-AmazonEKSWorkerNodePolicy, aws_iam_role_policy_attachment.amazon_eks_cni_policy_general, aws_iam_role_policy_attachment.nodes_general-AmazonEC2ContainerRegistryReadOnly]
}