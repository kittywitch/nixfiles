{
  tree,
  config,
  ...
}: {
  imports = with tree.nixos; [
    microvm.default
    servers.syncthing
  ];
  sops.secrets."${config.networking.hostName}-sops-age-key" = {
    sopsFile = ./. + "${config.networking.hostName}.yaml";
  };
  microvm.credentialFiles = {
    SOPS_AGE_KEY = sops.secrets."${config.networking.hostName}-sops-age-key".path;
  };
  networking.hostName = "syncthing";
  services.syncthing.device_name = "daiyousei-syncthing";
}
