resource "cloudflare_zone" "wyppu" {
  account = {
    id = var.cloudflare_account_id
  }
  name = var.zone_name
  type = "full"
}

# resource "cloudflare_dns_record" "example_dns_record" {
#   zone_id = cloudflare_zone.wyppu.id
#   name    = "example.com"
#   ttl     = 3600
#   type    = "A"
#   comment = "Domain verification record"
#   content = "198.51.100.4"
#   proxied = true
#   settings = {
#     ipv4_only = true
#     ipv6_only = true
#   }
#   tags = ["owner:dns-team"]
# }
