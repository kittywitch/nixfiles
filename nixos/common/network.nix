{ machine, ... }: {
  networking = {
    hostName = machine;
    nftables.enable = true;
  };
  services.tailscale.enable = true;
}
