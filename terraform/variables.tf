variable "region" {
  description = "The AWS region to deploy the cluster"
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "go-tick-tock-bong-cluster"
}
