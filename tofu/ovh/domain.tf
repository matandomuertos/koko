data "terraform_remote_state" "cloudflare" {
  backend = "local"
  config = {
    path = "/bkp/tofu/cloudflare/terraform.tfstate"
  }
}

resource "ovh_domain_name" "wyppu" {
  domain_name = var.domain_name

  target_spec = {
    dns_configuration = {
      name_server = data.terraform_remote_state.cloudflare.outputs.cloudflare_name_servers
    }
  }
}
