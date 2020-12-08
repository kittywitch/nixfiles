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
          ExecStart = "${pkgs.runtimeShell} ${./kaede-thermals.sh} start";
          ExecStop = "${pkgs.runtimeShell} ${./kaede-thermals.sh} stop";
          User = "root";
        };
      };
      kaede-power = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.bash pkgs.linuxPackages.cpupower ];
        serviceConfig = {
          RemainAfterExit = "yes";
          Type = "oneshot";
          ExecStart = "${pkgs.runtimeShell} ${./kaede-power.sh} start";
          ExecStop = "${pkgs.runtimeShell} ${./kaede-power.sh} stop";
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
