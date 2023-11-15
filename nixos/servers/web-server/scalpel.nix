{config, ...}: {
  scalpel.trafos."credentials_file" = {
    source = "/etc/ssl/credentials_template";
    matchers."CLOUDFLARE_EMAIL".secret = config.sops.secrets.cloudflare_email.path;
    matchers."CLOUDFLARE_API_KEY".secret = config.sops.secrets.cloudflare_api_key.path;
    owner = "acme";
    group = "acme";
    mode = "0440";
  };

  security.acme.defaults.credentialsFile = config.scalpel.trafos."credentials_file".destination;
}
