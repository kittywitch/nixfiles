{pkgs, ...}: {
  environment.systemPackages = with pkgs; [pulsemixer];

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire.extraConfig.pipewire-pulse."92-subpar-latency" = {
    pulse.properties = {
        pulse.min.req = "1024/48000";
        pulse.default.req = "1024/48000";
        pulse.min.quantum = "1024/48000";
    };
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    alsa.enable = true;
  };
}
