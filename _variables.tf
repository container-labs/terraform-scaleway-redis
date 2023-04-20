variable "name" {
  type        = string
  description = "The name of the Redis cluster"
}

variable "tags" {
  type = map(any)
}

variable "private_network_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "cluster_mode" {
  type    = string
  default = "standalone"
}

variable "node_type" {
  type = string
}
