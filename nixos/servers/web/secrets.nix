_: let
  secretConfig = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
    owner = "acme";
    group = "acme";
  };
in {
  sops.secrets.acme_credentials = secretConfig;
}
