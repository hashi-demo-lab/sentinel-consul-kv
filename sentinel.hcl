
policy "consul-kv-example" {
    enforcement_level = "soft-mandatory"
}

import "module" "kv" {
  source = "./modules/kv.sentinel"
}