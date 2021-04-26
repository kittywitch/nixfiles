{ config, lib, pkgs, ... }:

{
  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.rate_converter "speexrate_best"
    '';
  };

  /* hardware.pulseaudio = {
       enable = true;
       extraConfig = "unload-module module-role-cork";
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
  */

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    alsa.enable = true;
  };
}
