{config, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:kittywitch/infrastructure#${config.networking.hostName}";
  };
}
