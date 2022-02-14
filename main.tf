# main.tf

module "vpc" {
  source                        = "./modules/vpc"
  context                       = "test"
  region                        = "eu-west-3"
  vpc-cidr-block                = "10.0.0.0/16"
  environment                   = "dev"
  deploymodule-eks-vpc-standard = 1
}

module "eks_aws_module" {
  source                                 = "terraform-aws-modules/eks/aws"
  version                                = "18.6.0"
  cluster_name                           = "eks-aws-tf"
  cluster_version                        = "1.21"
  cluster_endpoint_private_access        = true
  cluster_endpoint_public_access         = true
  cluster_enabled_log_types              = []
  cluster_security_group_name            = "secg1-cluster-eks"
  cluster_endpoint_public_access_cidrs   = ["93.36.185.79/32"]
  cluster_security_group_use_name_prefix = false
  iam_role_use_name_prefix               = false
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }
  eks_managed_node_groups = {
    nodeg1 = {
      # launch template options
      name                            = "nodeg1"
      use_name_prefix                 = false
      create_launch_template          = true
      launch_template_name            = "lt-test1"
      launch_template_use_name_prefix = false
      launch_template_description     = "Launch Template for EKS Cluster Node Group POC eks module"
      instance_types                  = ["t3.medium"]
      # key_name = ""
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            delete_on_termination = true
          }
        }
      }

      # security groups
      create_security_group = false

      # iam role
      iam_role_use_name_prefix     = false
      iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

      # node group options
      min_size                   = 1
      desired_size               = 1
      max_size                   = 2

      # user data
      # enable_bootstrap_user_data = true
      pre_bootstrap_user_data    = <<-EOT
      MIME-Version: 1.0
      Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

      --==MYBOUNDARY==
      Content-Type: text/x-shellscript; charset="us-ascii"

      #!/bin/bash
      # Aggiornamento del sistema
      yum update -y
      # Impostazione timezone corretta
      timedatectl set-timezone Europe/Rome

      # Installazione e attivazione SSM Agent
      yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      systemctl enable amazon-ssm-agent
      systemctl start amazon-ssm-agent

      mkdir example
      cd example
      touch file.txt

      --==MYBOUNDARY==--
      EOT
    }
  }
  vpc_id     = module.vpc.vpc-id
  subnet_ids = [module.vpc.subnet-cp-private-a-id, module.vpc.subnet-cp-private-b-id, module.vpc.subnet-cp-private-c-id]
}

data "aws_eks_cluster" "this" {
  name = "eks-aws-tf"
  depends_on = [
    module.eks_aws_module
  ]
}

data "aws_eks_cluster_auth" "this" {
  name = "eks-aws-tf"
  depends_on = [
    module.eks_aws_module
  ]
}