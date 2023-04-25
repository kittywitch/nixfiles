{config, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:kittywitch/kittywitch#${config.networking.hostName}";
  };
}
