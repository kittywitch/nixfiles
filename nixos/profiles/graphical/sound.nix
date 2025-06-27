{pkgs, ...}: {
  environment.systemPackages = with pkgs; [pulsemixer pwvucontrol easyeffects];

  services.pulseaudio.enable = false;
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 256;
      "default.clock.min-quantum" = 256;
      "default.clock.max-quantum" = 256;
    };
  };
  services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
    "context.properties" = [
      {
        name = "libpipewire-module-protocol-pulse";
        args = { };
      }
    ];
    "pulse.properties" = {
      "pulse.min.req" = "512/48000";
      "pulse.default.req" = "512/48000";
      "pulse.max.req" = "512/48000";
      "pulse.min.quantum" = "512/48000";
      "pulse.max.quantum" = "512/48000";
    };
    "stream.properties" = {
      "node.latency" = "256/48000";
      "resample.quality" = 1;
    };
  };
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
