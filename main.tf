# https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/redis_cluster
# https://www.scaleway.com/en/docs/managed-databases/redis/how-to/create-a-database-for-redis
# Note: Managed Database for Redis™ are available in PAR1, PAR2, AMS1 and WAW1.

# password does not respect constraint, password must be
# between 8 and 128 characters, contain at least one digit, one uppercase, one lowercase and one special character
resource "random_password" "root_user_password" {
  length      = 10
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

resource "scaleway_redis_cluster" "main" {
  name      = var.name
  version   = "6.2.7"
  node_type = var.node_type
  user_name = "root"
  password  = random_password.root_user_password.result
  tags      = [for k, v in var.tags : "${k}::${v}"]
  # You cannot set cluster_size to 2, you either have to choose Standalone mode (1 node)
  #  or Cluster mode which is minimum 3 (1 main node + 2 secondary nodes)
  cluster_size = var.cluster_mode == "standalone" ? 1 : 5
  tls_enabled  = "false"
  private_network {
    id = var.private_network_id
    service_ips = [
      "10.12.1.1/20",
    ]
  }

  # acl {
  #   ip          = "0.0.0.0/0"
  #   description = "Allow all"
  # }
}
