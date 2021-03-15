{ config, pkgs, lib, options, ... }:

with lib;

let
  cfg = config.deploy;
  secretsScript = concatMapStrings (file:
    ''
      ssh $NIX_SSHOPTS root@${cfg.ssh.host} "mkdir -p ${toString file.out.dir}
      cat > ${file.path}
      chmod ${file.mode} ${file.path}
        chown ${file.owner}:${file.group} ${file.path}"''
    + (if file.source != null then ''
      < ${toString file.source}
    '' else ''
      <<'EOF'
      ${file.text}
      EOF
    '')) (attrValues config.secrets.files);
in {
  options = {
    deploy = {
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
      groups = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    deploy.profile = mkMerge (map (prof: {
      ${if options ? deploy.profile.${prof} then prof else null} = true;
    }) config.deploy.profiles);
    deploy.groups = [ "all" ];

    system.build.deployScript = ''
        #!${pkgs.runtimeShell}
        set -xeo pipefail
        export PATH=${with pkgs; lib.makeBinPath [ coreutils openssh nix ]}
        export NIX_SSHOPTS="$NIX_SSHOPTS -p${toString cfg.ssh.port} -T"
        nix copy ${
          if cfg.substitute then "-s" else ""
        } --no-check-sigs --to ssh://root@${cfg.ssh.host} ${config.system.build.toplevel}
        ${secretsScript}
        ssh $NIX_SSHOPTS root@${cfg.ssh.host} "nix-env -p /nix/var/nix/profiles/system -i ${config.system.build.toplevel}" 
        ssh $NIX_SSHOPTS root@${cfg.ssh.host} "/nix/var/nix/profiles/system/bin/switch-to-configuration $1" 
      '';
  };
}
