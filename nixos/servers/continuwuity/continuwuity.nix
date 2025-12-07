{config, ...}: {
  sops.secrets.registrationToken = {
    sopsFile = ./secrets.yaml;
    owner = "continuwuity";
    group = "continuwuity";
  };
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        allow_registration = true;
        server_name = "kittywit.ch";
        registration_token_file = config.sops.secrets.registrationToken.path;
      };
    };
  };
}
