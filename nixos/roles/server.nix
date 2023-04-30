{
  std,
  config,
  tree,
  ...
}: let
  inherit (std) set;
in {
  imports = with tree.nixos.roles; [
    bootable
  ];

  systemd.tmpfiles.rules = set.mapToValues (username: _: "f /var/lib/systemd/linger/${username}") config.users.users;

  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  services.tailscale = {
    enable = true;
  };

  programs.mosh.enable = true;
}
