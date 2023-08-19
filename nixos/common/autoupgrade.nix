{config, ...}: {
  system.autoUpgrade = {
    enable = false;
    flake = "github:kittywitch/infrastructure#${config.networking.hostName}";
  };
}
