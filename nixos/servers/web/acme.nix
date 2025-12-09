{
  config,
  lib,
  ...
}: {
  security.acme = {
    defaults = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets.acme_credentials.path;
      email = lib.mkDefault "acme@inskip.me";
    };
    acceptTerms = true;
  };
}
