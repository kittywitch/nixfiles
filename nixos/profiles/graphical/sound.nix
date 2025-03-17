{pkgs, ...}: {
  environment.systemPackages = with pkgs; [pulsemixer];

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
  context.modules = [
    {
      name = "libpipewire-module-protocol-pulse";
      args = {
        pulse.min.req = "32/48000";
        pulse.default.req = "32/48000";
        pulse.max.req = "32/48000";
        pulse.min.quantum = "32/48000";
        pulse.max.quantum = "32/48000";
      };
    }
  ];
  stream.properties = {
    node.latency = "32/48000";
    resample.quality = 1;
  };
};
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 32;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 32;
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
