{ config, lib, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        gpu-context = "wayland";
        vo = "gpu";
        hwdec = "auto";
      };
    };
  };
}
