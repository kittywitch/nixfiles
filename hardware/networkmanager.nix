{ config, lib, pkgs, ... }: {
  options = {
    home-manager.users = let
      applets = { config, nixos, ... }: {
        xsession.preferStatusNotifierItems = true;
        services = {
          network-manager-applet.enable = true;
          blueman-applet.enable = true;
        };
      };
    in lib.mkOption {
      type = lib.types.attrsOf (lib.types.submoduleWith {
        modules = lib.singleton applets;
      });
    };
  };
  config = {
    systemd.services.NetworkManager-wait-online = {
      serviceConfig.ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;
    services.pipewire.media-session.config.bluez-monitor = {
      properties = { };
      rules = [
        {
          actions = {
            update-props = {
              "bluez5.a2dp-source-role" = "input";
              "bluez5.auto-connect"  = [ "hfp_hf" "hsp_hs" "a2dp_sink" "a2dp_source" "hsp_ag" "hfp_ag" ];
            };
          };
          matches = [ { "device.name" = "~bluez_card.*"; } ];
        }
        {
          actions = {
            update-props = { "node.pause-on-idle" = false; };
          };
          matches = [ { "node.name" = "~bluez_input.*"; } { "node.name" = "~bluez_output.*"; } ];
        }
      ];
    };
    networking = {
      networkmanager = {
        enable = true;
        connectionConfig = {
           "ipv6.ip6-privacy" = lib.mkForce 0;
        };
      };
    };
  };
}
