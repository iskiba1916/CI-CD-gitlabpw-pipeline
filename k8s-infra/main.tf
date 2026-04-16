terraform {
    required_providers { 
        openstack = { 
            source = "terraform-provider-openstack/openstack" 
            version = "~> 1.54" 
        } 
    } 
} 

provider "openstack" {} #reads credentials from env (sourced openrc)