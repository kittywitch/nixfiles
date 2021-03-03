{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (lib.elem "desktop" config.deploy.profiles) {
    sound.extraConfig = ''
      defaults.pcm.rate_converter "speexrate_best"
    '';
    hardware.pulseaudio.daemon.config = {
      default-sample-format = "s24le";
      default-sample-rate = 96000;
      resample-method = "soxr-vhq";
    };
  };
}
