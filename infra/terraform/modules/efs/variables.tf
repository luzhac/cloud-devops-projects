variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "cluster_name"
  type        = string
}



variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to allow NFS (2049)"
  type        = string
}



