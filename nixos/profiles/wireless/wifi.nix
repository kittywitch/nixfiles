{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  systemd.services.NetworkManager-wait-online = {
    serviceConfig.ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      connectionConfig = {
        "ipv6.ip6-privacy" = mkForce 0;
      };
    };
  };

  home-manager.sharedModules = [
    {
      xsession.preferStatusNotifierItems = true;
      #services.network-manager-applet.enable = true;
    }
  ];
}
