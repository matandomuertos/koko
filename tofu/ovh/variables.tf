variable "domain_name" {
  type        = string
  description = "The name of the domain"
}

variable "name_servers" {
  type        = list(string)
  description = "List of name servers for the domain"
}
