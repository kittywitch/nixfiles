_: {
  environment.etc."ssl/credentials_template".text = ''
    CF_API_EMAIL=!!CLOUDFLARE_EMAIL!!
    CLOUDFLARE_API_KEY=!!CLOUDFLARE_API_KEY!!
  '';

  security.acme = {
    defaults = {
      dnsProvider = "cloudflare";
      email = "acme@inskip.me";
    };
    acceptTerms = true;
  };
}
