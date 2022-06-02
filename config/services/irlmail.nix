{ config, tf, meta, lib, ... }: with lib; {
  dns.zones."inskip.me." = {
    provider = "dns.katdns";
  };

  resources.gmail-mx = let
    zone = config.dns.zones."inskip.me.";
  in with zone; {
    provider = provider.set;
    type = "mx_record_set";
    inputs = {
      zone = domain;
      ttl = 3600;
      mx = [
        { preference = 1; exchange = "aspmx.l.google.com."; }
        { preference = 5; exchange = "alt1.aspmx.l.google.com."; }
        { preference = 5; exchange = "alt2.aspmx.l.google.com."; }
        { preference = 10; exchange = "alt3.aspmx.l.google.com."; }
        { preference = 10; exchange = "alt4.aspmx.l.google.com."; }
        { preference = 15; exchange = "6uyykkzhqi4zgogxiicbuamoqrxajwo5werga4byh77b2iyx3wma.mx-verification.google.com."; }
      ];
    };
  };

  dns.records = {
    services_inskip_a = {
      zone = "inskip.me.";
      a.address = meta.network.nodes.marisa.network.addresses.public.nixos.ipv4.address;
    };
    services_inskip_aaaa = {
      zone = "inskip.me.";
      aaaa.address = meta.network.nodes.marisa.network.addresses.public.nixos.ipv6.address;
    };
    services_gmail_spf = {
      zone = "inskip.me.";
      txt.value = "v=spf1 include:_spf.google.com ~all";
    };
    services_gmail_dkim = {
      zone = "inskip.me.";
      domain = "google._domainkey";
      txt.value = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkxag/EmXQ89XQmLrBDPpPtZ7EtEJT0hgvWf/+AFiOfBOm902tq9NbTTvRJ2dLeBLPaV+hNvq2Alc7UfkKUDlLTWQjeuiC6aOnRKQQg3LZ2W25U3AlIj0jd2IPiUhg9JGV4c66XiqQ5ylTBniShfUUyeAXxbPhYFBCkBg62LZcO/tFpFsdKWtZzLjgac5vTJID+M4F8duHpkA/ZCNNUEmtt7RNQB/LLI1Gr5yR4GdQl9z7NmwtOTo9pghbZuvljr8phYjdDrwZeFTMKQnvR1l2Eh/dZ8I0C4nP5Bk4QEfmLq666P1HzOxwT6iCU6Tc+P/pkWbrx0HJh39E1aKGyLJMQIDAQAB";
    };
    services_gmail_dmarc = {
      zone = "inskip.me.";
      domain = "_dmarc";
      txt.value = "v=DMARC1; p=none; rua=mailto:dmarc-reports@inskip.me";
    };
  };
}
