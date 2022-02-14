variable "context" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "environment" {
  type = string
}

variable "vpc-cidr-block" {
  type    = string
  default = "10.0.0.0/16"
  validation {
    condition     = can(regex("((^192\\.168\\.)|(^10\\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.)|(^172\\.1[6-9]\\.)|(^172\\.2[0-9]\\.)|(^172\\.3[0-1]\\.))0\\.0\\/16$", var.vpc-cidr-block))
    error_message = "La subnet deve essere /16."
  }
}

variable "deploymodule-eks-vpc-standard" {
  type    = number
  default = 1
}
