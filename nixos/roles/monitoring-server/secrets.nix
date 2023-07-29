_: {
  sops.secrets.telegraf_api_key = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };

  scalpels = [
    ./scalpel.nix
  ];
}
