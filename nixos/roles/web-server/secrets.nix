_: let
  secretConfig = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };
in {
  sops.secrets.cloudflare_email = secretConfig;
  sops.secrets.cloudflare_token = secretConfig;

  scalpels = [
    ./scalpel.nix
  ];
}
