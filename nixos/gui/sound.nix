{ pkgs, ... }: {
  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.rate_converter "speexrate_best"
      '';
  };

  environment.systemPackages = with pkgs; [ pulsemixer bluez5-experimental ];

  security.rtkit.enable = true;

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

  services.pipewire = {
    enable = true;
    config = {
      pipewire = {
        "context.properties" = {
          "log.level" = 2;
          "default.clock.min-quantum" =
            32; # default; going lower may cause crackles and distorted audio
        };
        pipewire-pulse = {
          "context.modules" = [{
            name = "libpipewire-module-protocol-pulse";
            args = {
              "pulse.min.quantum" = 32; # controls minimum playback quant
                "pulse.min.req" = 32; # controls minimum recording quant
                "pulse.min.frag" = 32; # controls minimum fragment size
                "server.address" =
                [ "unix:native" ]; # the default address of the server
            };
          }];
        };
      };
    };
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    alsa.enable = true;
  };
}
