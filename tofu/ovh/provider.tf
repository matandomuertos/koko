# export OVH_APPLICATION_KEY=123
# export OVH_APPLICATION_SECRET=123
# export OVH_CONSUMER_KEY=123

terraform {
  required_version = "~> 1.10"
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.7"
    }
  }

  backend "local" {
    path = "/bkp/tofu/ovh/terraform.tfstate"
  }
}

provider "ovh" {
  endpoint = "ovh-eu"
}
