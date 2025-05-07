#
# Create Custom Volume
#

# Create custom volume.
resource "lxd_volume" "volume" {
  name = "myvol"
  pool = lxd_storage_pool.pool.local

  # Set content_type to "filesystem" (default) to create a filesystem.
  # Set content_type to "block" to create a block device without a filesystem.
  # Note: Block volumes can only be attached to virtual machines.
  content_type = "filesystem"

  config = {
    # Some drivers support block-backed filesystem volumes.
    # Note: This is a storage driver specific option.
    "zfs.block_mode" = true

    size = "5GiB"
  }
}

#
# LXD Instances
#

resource "lxd_instance" "instance" {
  name      = var.instance_name
  image     = "almalinux/8/cloud"
  profiles  = ["default"]
  ephemeral = false
  target    = var.instance_target

  limits = {
    cpu    = var.cpu_limits
    memory = var.memory_limits
  }

  config = {
    "boot.autostart" = true
  }
  device {
    name = "vol-01"
    type = "disk"
    properties = {
      path   = "/var/lib/docker"           # Path where volume is mounted within an instance.
      pool   = lxd_storage_pool.pool.name  # Storage pool name where volume is created.
      source = lxd_volume.volume.name      # Volume name.
    }
  }

  device {
    name = "http"
    type = "proxy"
    properties = {
      # Listen on LXD host's TCP port 80
      listen = "tcp:0.0.0.0:80"
      # And connect to the instance's TCP port 80
      connect = "tcp:127.0.0.1:80"
    }
  }
}

# lxc init images:almalinux/8/cloud scl1-e1-acs-dev \
#   --vm \
#   -c limits.cpu=4 \
#   -c limits.memory=16GiB \
#   --target scl1-host04 \
#   --storage remote \
#   --config boot.autostart=true

# lxc config device set scl1-e1-acs-dev root size 512GiB

# lxc config device add scl1-e1-acs-dev eth1 nic \
#     nictype=bridged \
#     parent=br0.3000 \
#     name=eth1

locals {
  context = var.context
}

module "submodule" {
  source = "./modules/submodule"

  message = "Hello, submodule"
}
