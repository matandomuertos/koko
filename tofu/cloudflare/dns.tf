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

resource "cloudflare_dns_record" "cname" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "www"
  ttl     = 1 #auto
  type    = "CNAME"
  content = var.zone_name
  proxied = false
}
