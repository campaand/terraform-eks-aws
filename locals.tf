locals {
  test = {
    rolearn  = "arn:aws:iam::xx:role/workers"
    username = "system:node:{{EC2PrivateDNSName}}"
    groups = [
      "system:bootstrappers",
      "system:nodes"
    ]
  }
}