output "master_ip" {
  value = openstack_networking_floatingip_v2.master_fip.address
}

output "worker_ips" {
  value = openstack_networking_floatingip_v2.worker_fip[*].address
}

output "runner_ip" {
  value = openstack_networking_floatingip_v2.runner_fip.address
}

output "ansible_inventory" {
  value = <<-EOT
[master]
k8s-master ansible_host=${openstack_networking_floatingip_v2.master_fip.address} ansible_user=ubuntu

[workers]
%{for i, ip in openstack_networking_floatingip_v2.worker_fip[*].address~}
worker-${i + 1} ansible_host=${ip} ansible_user=ubuntu
%{endfor~}

[runners]
runner ansible_host=${openstack_networking_floatingip_v2.runner_fip.address} ansible_user=ubuntu

[k8s:children]
master
workers

[k8s:vars]
ansible_ssh_private_key_file=./openstack_rsa
EOT
}
