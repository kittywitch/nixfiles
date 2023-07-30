_: {
  users.users.vaultwarden.name = "bitwarden_rs";
  users.groups.vaultwarden.name = "bitwarden_rs";

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      rocketPort = 4000;
      websocketEnabled = true;
      signupsAllowed = false;
      domain = "https://vault.kittywit.ch";
      databaseUrl = "postgresql://bitwarden_rs@/bitwarden_rs";
    };
  };

  environment.etc."vaultwarden/environment_file_template".text = ''
    ADMIN_TOKEN=!!VAULTWARDEN_ADMIN_TOKEN!!
  '';
}
