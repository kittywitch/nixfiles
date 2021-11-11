{ config, lib, ... }: with lib; {
  options = {
    home-manager.users = let
      applets = { config, nixos, ... }: {
        xsession.preferStatusNotifierItems = true;
        services = {
          network-manager-applet.enable = true;
          blueman-applet.enable = true;
        };
      };
    in mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = singleton applets;
      });
    };
  };
  config = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    networking = {
      networkmanager = {
        enable = true;
        connectionConfig = {
           "ipv6.ip6-privacy" = mkForce 0;
        };
      };
    };
  };
}
