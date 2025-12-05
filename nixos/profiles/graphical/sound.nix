{pkgs, ...}: let
  bitrate_int = 48 * 1000;
  bitrate = toString bitrate_int;
  ll_quant_int = 512;
  ll_quant = toString ll_quant_int;
  ml_quant_int = 1024;
  ml_quant = toString hl_quant_int;
  hl_quant_int = 2048;
  hl_quant = toString hl_quant_int;
  minQuant = "${ll_quant}/${bitrate}";
  midQuant = "${ml_quant}/${bitrate}";
  maxQuant = "${hl_quant}/${bitrate}";
in {
  environment.systemPackages = with pkgs; [pulsemixer pwvucontrol easyeffects];

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      alsa.enable = true;
      extraConfig = {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = bitrate_int;
            "default.clock.quantum" = ml_quant_int;
            "default.clock.min-quantum" = ll_quant_int;
            "default.clock.max-quantum" = hl_quant_int;
          };
          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              flags = [
                "ifexists"
                "nofail"
              ];
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
          ];
        };
        pipewire-pulse = {
          "91-discord-latency" = {
            pulse.rules = [
              {
                matches = [{"application.process.binary" = "Discord";}];
                actions = {
                  update-props = {
                    "pulse.min.quantum" = midQuant;
                  };
                };
              }
            ];
          };
          "92-low-latency" = {
            "context.properties" = [
              {
                name = "libpipewire-module-protocol-pulse";
                args = {};
              }
            ];
            "pulse.properties" = {
              "pulse.min.req" = minQuant;
              "pulse.default.req" = midQuant;
              "pulse.max.req" = maxQuant;
              "pulse.min.quantum" = minQuant;
              "pulse.max.quantum" = maxQuant;
            };
            "stream.properties" = {
              "node.latency" = minQuant;
              "resample.quality" = 1;
            };
          };
        };
      };
    };
  };
  security.rtkit.enable = true;
}
