locals {
  dkims = {
    inskip     = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkxag/EmXQ89XQmLrBDPpPtZ7EtEJT0hgvWf/+AFiOfBOm902tq9NbTTvRJ2dLeBLPaV+hNvq2Alc7UfkKUDlLTWQjeuiC6aOnRKQQg3LZ2W25U3AlIj0jd2IPiUhg9JGV4c66XiqQ5ylTBniShfUUyeAXxbPhYFBCkBg62LZcO/tFpFsdKWtZzLjgac5vTJID+M4F8duHpkA/ZCNNUEmtt7RNQB/LLI1Gr5yR4GdQl9z7NmwtOTo9pghbZuvljr8phYjdDrwZeFTMKQnvR1l2Eh/dZ8I0C4nP5Bk4QEfmLq666P1HzOxwT6iCU6Tc+P/pkWbrx0HJh39E1aKGyLJMQIDAQAB"
    dork       = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAziwoHJbM1rmeUiIXOgg0cujTL5BFW9PQOksUhKza1XpDP2rpzTlQr21NFYMJMc08xiE3AbvScMTX0jX3gc7+XoIYLD1VigRRvkyTubVfRmatqj+Pk41Fle1jWXHv5vNIYjjcsUTrpnrXYKoYrz34TtsmYHnu0G9MgmmcQGmbRU+WY+1R/ukhavlgXasfEW6r4tjLgVxQnser1Zjr80AUcu23od/+o+m6C9rDGMMnv6NIc2DOT7Ei6o60458f2Iwcpg38te22dy46A8AeGynbpB9+jF33Se0m22eKk5qZN5mfju/wxWMsl7ifCY/eqLZXRxJaEd5bMI8px5KvZp1TWwIDAQAB"
    kittywitch = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApdmyA2+/si8UV3bodFZhtv5y68QnYr/kk9wnDHnk3JfJKusbrctXfETVu/9GXQ/U8tRquesF7aXKYHM/K3O6H58gAgIFm8JVnr9EUFh5PWBTKJxHgDo/6pprhpdAJg8k4f4p5yvqE0nUI6TC0UpN+ZmQMimgxvGGwQ6mpl7qmc7JxmTOiJbO1yz6eokU27S0NHfpdiE3TGG93i2r/LwAnHuhT/4weGO+vcXwKRTFGFFjvMo0XgjL2JnP01nk6dpDFwkkt5I26J4DkuNMkLefgDiGOoxDmG5EgPu0YwAm7Vk2/kX0W6rLe16lHGDkB0/atQ/IB9uch31GQrLP9etmdwIDAQAB"
  }
}

module "inskip-gmail" {
  source             = "./gmail_dns"
  cloudflare_api_key = var.cloudflare_api_key
  zone_id            = local.zone_ids.inskip
  zone_name          = local.zones.inskip
  dkim               = local.dkims.inskip
}
module "dork-gmail" {
  source             = "./gmail_dns"
  cloudflare_api_key = var.cloudflare_api_key
  zone_id            = local.zone_ids.dork
  zone_name          = local.zones.dork
  dkim               = local.dkims.dork
}
module "kittywitch-gmail" {
  source             = "./gmail_dns"
  cloudflare_api_key = var.cloudflare_api_key
  zone_id            = local.zone_ids.kittywitch
  zone_name          = local.zones.kittywitch
  dkim               = local.dkims.kittywitch
}
