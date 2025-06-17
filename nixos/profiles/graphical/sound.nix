{pkgs, ...}: {
  environment.systemPackages = with pkgs; [pulsemixer pwvucontrol];

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire.extraConfig.pipewire-pulse."91-discord-latency" = {
    pulse.rules = [
      {
        matches = [ { "application.process.binary" = "Discord"; } ];
        actions = {
            update-props = {
              "pulse.min.quantum" = "1024/48000";
            };
        };
      }
    ];
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    alsa.enable = true;
  };
}
