resource "ovh_domain_name" "wyppu" {
  domain_name = var.domain_name

  target_spec = {
    dns_configuration = {
      name_server = var.name_servers
      # name_servers = [
      #   {
      #     name_server = "hal.ns.cloudflare.com"
      #   },
      #   {
      #     name_server = "lady.ns.cloudflare.com"
      #   }
      # ]
    }
  }
}
