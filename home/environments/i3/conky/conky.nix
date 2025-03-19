{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    jq
    conky
  ];

  xdg.configFile.conky = {
    recursive = true;
    source = config.lib.file.mkOutOfStoreSymlink ./.;
  };

  systemd.user.services.conky = {
    Unit = {
      Description = "Conky - Lightweight system monitor";
      After = [ "graphical-session.target" ];
      X-Restart-Triggers = [
        ./conky.conf
      ];
    };

    Service = {
      Restart = "always";
      RestartSec = "3";
      ExecStart = toString ([ "${pkgs.conky}/bin/conky"]);
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
