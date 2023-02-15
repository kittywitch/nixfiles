{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ bluez5-experimental ];

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
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

  services = {
    blueman.enable = true;
    pipewire.media-session.config.bluez-monitor = {
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
  };

  home-manager.sharedModules = [
    {
      xsession.preferStatusNotifierItems = true;
      services.blueman-applet.enable = true;
    }
  ];
}
