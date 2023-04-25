{
  std,
  config,
  ...
}: let
  inherit (std) set;
in {
  systemd.tmpfiles.rules = set.mapToValues (username: _: "f /var/lib/systemd/linger/${username}") config.users.users;

  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  services.tailscale = {
    enable = true;
  };
}
