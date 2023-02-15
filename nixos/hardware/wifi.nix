{ lib, pkgs, ... }: let
inherit (lib.modules) mkForce;
in {
  systemd.services.NetworkManager-wait-online = {
    serviceConfig.ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
  };
  networking = {
    firewall = {
      allowedUDPPorts = [ 5353 ]; # MDNS
      allowedUDPPortRanges = [ { from = 32768; to=60999; } ]; # Ephemeral / Chromecast
    };
    networkmanager = {
      enable = true;
      connectionConfig = {
        "ipv6.ip6-privacy" = mkForce 0;
      };
    };
  };

  home-manager.sharedModules = [
    {
      xsession.preferStatusNotifierItems = true;
      services.network-manager-applet.enable = true;
    }
  ];
}
