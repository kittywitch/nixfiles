_: let
  secretConfig = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };
in {
  sops.secrets.acme_credentials = secretConfig;
}
