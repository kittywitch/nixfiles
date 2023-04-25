_: {
  environment.etc."ssl/credentials_template".text = ''
    CF_API_EMAIL=!!CLOUDFLARE_EMAIL!!
    CF_DNS_API_TOKEN=!!CLOUDFLARE_TOKEN!!
    CF_ZONE_API_TOKEN=!!CLOUDFLARE_TOKEN!!
  '';

  security.acme = {
    defaults = {
      dnsProvider = "cloudflare";
      email = "acme@inskip.me";
    };
    acceptTerms = true;
  };
}
