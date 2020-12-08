{ config, pkgs, ... }:

{
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
    powerManagement = {
        enable = true;
        cpuFreqGovernor = "conservative";
    };
    systemd = {
        services = {
            kaede-thermals = let kaede-thermals-script = pkgs.writeScriptBin "script" (builtins.readFile ./kaede-thermals.sh); in {
                wantedBy = [ "multi-user.target" ];
                path = [pkgs.bash pkgs.coreutils-full];
                serviceConfig = {
                    RemainAfterExit = "no";
                    Type = "simple";
                    ExecStart = "${kaede-thermals-script}/bin/script start";
                    ExecStop = "${kaede-thermals-script}/bin/script stop";
                    User = "root";
                };
            };
            kaede-power = let kaede-power-script = pkgs.writeScriptBin "script" (builtins.readFile ./kaede-power.sh); in {
                wantedBy = [ "multi-user.target" ];
                path = [pkgs.bash pkgs.linuxPackages.cpupower];
                serviceConfig = {
                    RemainAfterExit = "yes";
                    Type = "oneshot";
                    ExecStart = "${kaede-power-script}/bin/script start";
                    ExecStop = "${kaede-power-script}/bin/script stop";
                    User = "root";
                };
            };
        };
    };
    services.thermald = let cfg_file = pkgs.writeTextFile {
        name = "cfg";
        text = (builtins.readFile ./kaede-thermald.xml); 
        }; in {
        enable = true;
        configFile = "${cfg_file}";
    };
}