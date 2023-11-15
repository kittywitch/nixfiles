{config, ...}: {
  # Enable tailscale
  services.tailscale = {
    enable = true;
  };

  # Allow tailscale through firewall
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
