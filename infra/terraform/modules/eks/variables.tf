

variable "cluster_name" {
  description = "Cluster name prefix"
  type        = string
}

variable "cluster_role_arn" {
  description = "cluster_role_arn"
  type        = string
}

variable "node_role_arn" {
  description = "node_role_arn"
  type        = string
}

variable "subnet_ids" {
  description = "subnet_ids"
  type        = list(string)
}
