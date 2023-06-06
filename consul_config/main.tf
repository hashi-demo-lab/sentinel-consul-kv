terraform {
  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.17.0"
    }
  }
}

provider "consul" {
  # Configuration options
  address = "consul-cluster.consul.8f401e26-b086-451f-b61a-4ffb6dd26304.aws.hashicorp.cloud"
  scheme = "https"
}

locals {
   yaml_files = flatten([for policy in fileset(path.module, "config/*.yaml") : yamldecode(file(policy))])
   policies   = { for policy in local.yaml_files : policy.path_prefix => policy }
}

resource "consul_key_prefix" "myapp_config" {
  for_each = local.policies
  # Extract the path_prefix from the YAML file
  path_prefix = each.value.path_prefix
  # Extract the subkeys and their values from the YAML file
  subkeys = each.value.subkeys
}

resource "consul_acl_policy" "readpolicy" {
  name        = "read_cloud_policy"
  rules       = <<-RULE
    key_prefix "policy" {
        policy = "read"
    }
    RULE
}


output "yaml_files" {
  value = local.yaml_files
} 

output "policies" {
  value = local.policies
} 