resource "cloudflare_zone" "wyppu" {
  account = {
    id = var.cloudflare_account_id
  }
  name = var.zone_name
  type = "full"
}

resource "cloudflare_dns_record" "main_domain" {
  zone_id = cloudflare_zone.wyppu.id
  name    = var.zone_name
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_ip
  proxied = false
}

resource "cloudflare_dns_record" "all_private" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "*"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_ip
  proxied = false
}

resource "cloudflare_dns_record" "all_private_dev" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "*.dev"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_dev_ip
  proxied = false
}

resource "cloudflare_dns_record" "proxmox" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "proxmox"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_pve1_ip
  proxied = false
}

resource "cloudflare_dns_record" "proxmox2" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "proxmox2"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_pve2_ip
  proxied = false
}

resource "cloudflare_dns_record" "pbs" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "pbs"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_pbs_ip
  proxied = false
}

resource "cloudflare_dns_record" "cname" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "www"
  ttl     = 1 #auto
  type    = "CNAME"
  content = var.zone_name
  proxied = false
}
