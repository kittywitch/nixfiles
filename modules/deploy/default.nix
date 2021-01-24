{ config, pkgs, lib, ... }:

with lib;

let cfg = config.meta.deploy;

in {
  options = {
    meta.deploy = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      ssh.host = mkOption {
        type = types.str;
        default = "${config.networking.hostName}.${config.networking.domain}";
      };
      ssh.port = mkOption {
        type = types.int;
        default = head config.services.openssh.ports;
      };
      substitute = mkOption {
        type = types.bool;
        default = true;
      };
      profiles = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    meta.deploy.profiles = [ "all" ];

    system.build.deployScript =
      pkgs.writeScript "deploy-${config.networking.hostName}" ''
        #!${pkgs.runtimeShell}
        set -xeo pipefail
        export PATH=${with pkgs; lib.makeBinPath [ coreutils openssh nix ]}
        export NIX_SSHOPTS="$NIX_SSHOPTS -p${toString cfg.ssh.port}"
        nix copy ${
          if cfg.substitute then "-s" else ""
        } --no-check-sigs --to ssh://${cfg.ssh.host} ${config.system.build.toplevel}
        ssh $NIX_SSHOPTS ${cfg.ssh.host} "sudo nix-env -p /nix/var/nix/profiles/system -i ${config.system.build.toplevel}" 
        ssh $NIX_SSHOPTS ${cfg.ssh.host} "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration $1" 
      '';
  };
}
