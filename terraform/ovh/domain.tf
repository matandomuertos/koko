resource "ovh_domain_name" "wyppu" {
  domain_name = "wyppu.ovh"

  target_spec = {
    dns_configuration = {
      name_servers = [
        {
          name_server = "hal.ns.cloudflare.com"
        },
        {
          name_server = "lady.ns.cloudflare.com"
        }
      ]
    }
  }
}
