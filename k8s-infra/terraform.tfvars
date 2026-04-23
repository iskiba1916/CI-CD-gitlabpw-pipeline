# Where to find each value in Horizon:
#   Compute → Images          → image name
#   Compute → Flavors         → flavor name
#   Compute → Key Pairs       → keypair name
#   Network → Networks        → your private network name
#   Network → Security Groups → your security group name
#   Network → Networks        → external/public network ID

worker_count          = 1
image_name            = "Ubuntu 24.04 LTS"
flavor_worker         = "plast.worker"
flavor_master         = "plast.master"
keypair_name          = "plast1"
network_name          = "plast-network"
security_group_name   = "default"
external_network_name = "public1"
