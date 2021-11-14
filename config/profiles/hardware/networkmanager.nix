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
    hardware.bluetooth = {
      enable = true;
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
           "ipv6.ip6-privacy" = mkForce 0;
        };
      };
    };
  };
}
