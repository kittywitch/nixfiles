{ inputs, lib, pkgs, config, ... }: let
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) submodule path nullOr;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe';
  cfg = config.programs.konawall-py;
in {
  options.programs.konawall-py = {
    enable = mkEnableOption "konawall, the wallpaper manager";
    package = mkPackageOption inputs.konawall-py.packages.${pkgs.system} "konawall-py" {};
    settings = mkOption {
      type = submodule {
        freeformType = (pkgs.formats.toml {}).type;
      };
      default = {};
    };
    environmentFile = mkOption {
      type = nullOr path;
      default = null;
    };
  };
  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];
    xdg.configFile."konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" cfg.settings;

    systemd.user.services.konawall-py = {
      Unit = {
        Description = "konawall-py";
        X-Restart-Triggers = [(toString config.xdg.configFile."konawall/config.toml".source)];
        After = ["graphical-session.target" "network-online.target"];
      };
      Service = {
        ExecStart = "${getExe' cfg.package "gui"}";
        Restart = "on-failure";
        RestartSec = "1s";
        EnvironmentFile = cfg.environmentFile;
      };
      Install = {WantedBy = ["graphical-session.target"];};
    };
  };
}
