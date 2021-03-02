{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (lib.elem "desktop" config.meta.deploy.profiles) {
    sound.extraConfig = ''
        defaults.pcm.rate_converter "speexrate_best"
    '';
    hardware.pulseaudio.daemon.config = {
        default-sample-format = "s24le";
        default-sample-rate = 192000;
        resample-method = "soxr-vhq";
    };
  };
}
