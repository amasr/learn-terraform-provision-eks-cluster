module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  # vpc_id     = module.vpc.vpc_id
  # subnet_ids = module.vpc.private_subnets
  vpc_id = "vpc-07b7807fdbbc3c3f9"
  subnet_ids = [
    "subnet-0a0ff2a2809256277", "subnet-082507d30ed2ba33d", "subnet-08fffef9d75a1e182", 
    "subnet-0f53da388dd4c3eef", "subnet-04d89fa59fcea4a91", "	subnet-00ba30adbea995e3e"
  ]


  eks_managed_node_group_defaults = {
    ami_type = "AL2_ARM_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name = "manning-eks-nodegroup-qa"

      instance_types = ["t4g.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'manning eks qa'
      EOT

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]
    }

    # two = {
    #   name = "node-group-2"
    #
    #   instance_types = ["t3.medium"]
    #
    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    #
    #   pre_bootstrap_user_data = <<-EOT
    #   echo 'foo bar'
    #   EOT
    #
    #   vpc_security_group_ids = [
    #     aws_security_group.node_group_two.id
    #   ]
    1 }
  }
}
