{config, ...}: {
  security.acme = {
    defaults = {
      dnsProvider = "cloudflare";
      email = "acme@inskip.me";
      credentialsFile = config.sops.secrets.acme_credentials.path;
    };
    acceptTerms = true;
  };
}
