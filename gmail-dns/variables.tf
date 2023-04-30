variable "cloudflare_api_key" {
	sensitive = true
}
variable "zone_id" {
    type = string
}

variable "dkim" {
    type = string
}

variable "zone_name" {
    type = string
}