_: let
  secretConfig = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };
in {
  sops.secrets.cloudflare_email = secretConfig;
  sops.secrets.cloudflare_api_key = secretConfig;

  scalpels = [
    ./scalpel.nix
  ];
}
