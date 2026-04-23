terraform {
  backend "http" {
  }
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
  }
}

provider "openstack" {
  use_octavia = true
} #reads credentials from env (sourced openrc)

# Master

# Floating IP — allocated from the external network pool
resource "openstack_networking_floatingip_v2" "master_fip" {
  pool = var.external_network_name
}

# VM instance
resource "openstack_compute_instance_v2" "master" {
  name            = "k8s-master"
  image_name      = var.image_name
  flavor_name     = var.flavor_master
  key_pair        = var.keypair_name
  security_groups = [var.security_group_name]

  network {
    name = var.network_name
    # private IP assigned automatically by OpenStack DHCP
  }
}

# Associate Floating IP to the VM

resource "openstack_compute_floatingip_associate_v2" "master_assoc" {
  floating_ip = openstack_networking_floatingip_v2.master_fip.address
  instance_id = openstack_compute_instance_v2.master.id
}

# Workers

resource "openstack_networking_floatingip_v2" "worker_fip" {
  count = var.worker_count
  pool  = var.external_network_name
}

resource "openstack_compute_instance_v2" "worker" {
  count = var.worker_count

  name            = "worker-${count.index + 1}"
  image_name      = var.image_name
  flavor_name     = var.flavor_worker
  key_pair        = var.keypair_name
  security_groups = [var.security_group_name]

  network {
    name = var.network_name
  }
}

resource "openstack_compute_floatingip_associate_v2" "worker_assoc" {
  count = var.worker_count

  floating_ip = openstack_networking_floatingip_v2.worker_fip[count.index].address
  instance_id = openstack_compute_instance_v2.worker[count.index].id
}

# Runner

resource "openstack_networking_floatingip_v2" "runner_fip" {
  pool = var.external_network_name
}

resource "openstack_compute_instance_v2" "runner" {
  name            = "runner"
  image_name      = var.image_name
  flavor_name     = var.flavor_worker
  key_pair        = var.keypair_name
  security_groups = [var.security_group_name]

  network {
    name = var.network_name
  }
}

resource "openstack_compute_floatingip_associate_v2" "runner_assoc" {
  floating_ip = openstack_networking_floatingip_v2.runner_fip.address
  instance_id = openstack_compute_instance_v2.runner.id
}
