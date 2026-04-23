variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "image_name" { type = string }
variable "flavor_worker" { type = string }
variable "flavor_master" { type = string }
variable "keypair_name" { type = string }
variable "network_name" { type = string }
variable "security_group_name" { type = string }
variable "external_network_name" { type = string }
