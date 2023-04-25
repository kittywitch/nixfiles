_: {
  sops.secrets.matrix_shared_registration_secret = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };

  scalpels = [
    ./scalpel.nix
  ];
}
