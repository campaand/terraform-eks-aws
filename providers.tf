# providers.tf

provider "aws" {
  profile = "gardaland"
  region  = "eu-west-3"
  ignore_tags {
    key_prefixes = ["AutoTag_"]
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}