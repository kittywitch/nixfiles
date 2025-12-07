{config, ...}: {
  security.acme = {
    defaults = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials.path;
    };
    acceptTerms = true;
  };
}
