{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    sound = {
      enable = true;
      extraConfig = ''
        defaults.pcm.rate_converter "speexrate_best"
      '';
    };
    hardware.pulseaudio = {
      enable = true;
      daemon.config = {
        default-sample-format = "s24le";
        default-sample-rate = 96000;
        resample-method = "soxr-vhq";
      };
    };
  };
}
