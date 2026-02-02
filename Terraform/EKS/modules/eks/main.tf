# Role for EKS cluster

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

## Policy attachment for EKS cluster Role

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

## EKS cluster

locals {

  common_tags = {

    managed_by = "terraform"
    project    = "otel"

  }
}

resource "aws_eks_cluster" "prod_cluster" {


  name    = var.cluster_name
  version = var.cluster_version

  role_arn = aws_iam_role.cluster.arn


  vpc_config {

    subnet_ids = var.subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = false


  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]


  tags = local.common_tags


}




## Role for Node group


resource "aws_iam_role" "node_gp_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}



## Policy for node group role

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {

  for_each = toset([

    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  ])


  policy_arn = each.value

  role = aws_iam_role.node_gp_role.name
}



## Node Group

resource "aws_eks_node_group" "eks-ng" {
  for_each = var.node_gp_config

  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-node-gp-${each.key}"
  node_role_arn   = aws_iam_role.node_gp_role.arn
  subnet_ids      = var.subnet_ids

  instance_types = each.value.instance_type
  capacity_type  = each.value.capacity_type

  scaling_config {

    desired_size = each.value.scaling_config.desired_size
    max_size     = each.value.scaling_config.max_size
    min_size     = each.value.scaling_config.min_size

  }

  depends_on = [
    aws_eks_cluster.prod_cluster,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
  ]

}
