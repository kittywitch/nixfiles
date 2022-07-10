{ config, lib, pkgs, ... }:

{
  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.rate_converter "speexrate_best"
    '';
  };

  environment.systemPackages = with pkgs; [ pulsemixer ];

  security.rtkit.enable = true;

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
