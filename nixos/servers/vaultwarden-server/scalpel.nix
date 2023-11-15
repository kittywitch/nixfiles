_: {
  secrets.files.vaultwarden-env = {
    owner = "bitwarden_rs";
    group = "bitwarden_rs";
  };

  services.vaultwarden = {
    environmentFile = config.secrets.files.vaultwarden-env.path;
  };

  scalpel.trafos."environment_file" = {
    source = "/etc/vaultwarden/environment_file_template";
    matchers."VAULTWARDEN_ADMIN_TOKEN".secret = config.sops.secrets.vaultwarden_admin_token.path;
    owner = "acme";
    group = "acme";
    mode = "0440";
  };

  services.vaultwarden.environmentFile = config.scalpel.trafos."environment_file".destination;
}
