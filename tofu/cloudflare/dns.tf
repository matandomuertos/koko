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

resource "cloudflare_dns_record" "all_private_k3d" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "*.k3d"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_k3d_ip
  proxied = false
}

resource "cloudflare_dns_record" "all_private_k3d_dev" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "*.k3d.dev"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_k3d_dev_ip
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

resource "cloudflare_dns_record" "proton_mail_txt" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "@"
  ttl     = 1 #auto
  type    = "TXT"
  content = "\"protonmail-verification=9b8f1870044059bf761f1527c61ece0ecada728f\""
}

resource "cloudflare_dns_record" "proton_mail_mx" {
  zone_id  = cloudflare_zone.wyppu.id
  name     = "@"
  ttl      = 1 #auto
  type     = "MX"
  content  = "mail.protonmail.ch"
  priority = 10
}

resource "cloudflare_dns_record" "proton_mail_mx2" {
  zone_id  = cloudflare_zone.wyppu.id
  name     = "@"
  ttl      = 1 #auto
  type     = "MX"
  content  = "mailsec.protonmail.ch"
  priority = 20
}

resource "cloudflare_dns_record" "proton_spf" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "@"
  ttl     = 1 #auto
  type    = "TXT"
  content = "\"v=spf1 include:_spf.protonmail.ch ~all\""
}

resource "cloudflare_dns_record" "proton_dkim" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "protonmail._domainkey"
  ttl     = 1 #auto
  type    = "CNAME"
  content = "protonmail.domainkey.d7dn3gsssmknuw3ir5qzpusy5de2yuysxwln7o4uwwwxylnpxw2fa.domains.proton.ch"
  proxied = false
}

resource "cloudflare_dns_record" "proton_dkim2" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "protonmail2._domainkey"
  ttl     = 1 #auto
  type    = "CNAME"
  content = "protonmail2.domainkey.d7dn3gsssmknuw3ir5qzpusy5de2yuysxwln7o4uwwwxylnpxw2fa.domains.proton.ch"
  proxied = false
}

resource "cloudflare_dns_record" "proton_dkim3" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "protonmail3._domainkey"
  ttl     = 1 #auto
  type    = "CNAME"
  content = "protonmail3.domainkey.d7dn3gsssmknuw3ir5qzpusy5de2yuysxwln7o4uwwwxylnpxw2fa.domains.proton.ch"
  proxied = false
}

resource "cloudflare_dns_record" "proton_dmarc" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "_dmarc"
  ttl     = 1 #auto
  type    = "TXT"
  content = "\"v=DMARC1; p=quarantine\""
}
