{
  config,
  lib,
  ...
}: {
  security.acme = {
    defaults = {
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials.path;
      email = lib.mkDefault "acme@inskip.me";
    };
    acceptTerms = true;
  };
}
