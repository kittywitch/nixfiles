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
      exit-idle-time = 5;
      resample-method = "speex-float-5";
      avoid-resampling = "true";
      flat-volumes = "no";
      default-sample-format = "s32le";
      default-sample-rate = 48000;
      alternate-sample-rate = 44100;
      default-sample-channels = 2;
      };
    };
  };
}
