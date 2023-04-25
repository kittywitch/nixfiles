{pkgs, ...}: {
  environment.systemPackages = with pkgs; [pulsemixer];

  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.rate_converter "speexrate_best"
    '';
  };
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    alsa.enable = true;
  };

  home-manager.sharedModules = [
    {
      programs.waybar.settings.main = {
        modules-right = [
          "pulseaudio"
        ];
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          on-click = "${pkgs.wezterm}/bin/wezterm start ${pkgs.pulsemixer}/bin/pulsemixer";
          format-icons = {
            headphone = "";
            headset = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };
      };
    }
  ];
}
