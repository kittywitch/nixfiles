{ config, pkgs, ... }:

{
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "conservative";
  };
  systemd = {
    services = {
      kaede-thermals = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.bash pkgs.coreutils-full ];
        serviceConfig = {
          RemainAfterExit = "no";
          Type = "simple";
          ExecStart = "/usr/bin/env bash ${./kaede-thermals.sh} start";
          ExecStop = "/usr/bin/env bash ${./kaede-thermals.sh} stop";
          User = "root";
        };
      };
      kaede-power = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.bash pkgs.linuxPackages.cpupower ];
        serviceConfig = {
          RemainAfterExit = "yes";
          Type = "oneshot";
          ExecStart = "/usr/bin/env bash ${./kaede-power.sh} start";
          ExecStop = "/usr/bin/env bash ${./kaede-power.sh} stop";
          User = "root";
        };
      };
    };
  };
  services.thermald = let
    cfg_file = pkgs.writeTextFile {
      name = "cfg";
      text = (builtins.readFile ./kaede-thermald.xml);
    };
  in {
    enable = true;
    configFile = "${cfg_file}";
  };
}
