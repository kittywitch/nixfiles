let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  hosts = import ../configuration/hosts;
  nixosHosts = lib.filterAttrs (name: host: host ? ssh) hosts;

  allGroups = lib.unique
    (lib.flatten (lib.mapAttrsToList (name: host: host.groups) hosts));

  hostsInGroup = group:
    lib.filterAttrs (k: v: builtins.elem group v.groups) hosts;

  hostsInAllGroups = lib.listToAttrs
    (map (group: lib.nameValuePair group (lib.attrNames (hostsInGroup group)))
      allGroups);

  mkDeploy = hostnames:
    pkgs.writeScript "deploy-${lib.concatStringsSep "-" hostnames}" ''
      #!${pkgs.stdenv.shell}
      set -e -o pipefail
      export PATH=/run/wrappers/bin/:${
        with pkgs;
        lib.makeBinPath [
          coreutils
          openssh
          nix
          gnutar
          findutils
          nettools
          gzip
          git
        ]
      }

      MODE=$1
      shift || true
      ARGS=$@

      [ "$MODE" == "" ] && MODE="switch"

      ${lib.concatMapStrings (hostname:
        let
          hostAttrs = nixosHosts.${hostname};
          nixosSystem = (import <nixpkgs/nixos/lib/eval-config.nix> {
            modules = [
              "${toString ../configuration}/hosts/${hostname}/configuration.nix"
            ];
            system =
              if hostAttrs ? system then hostAttrs.system else "x86_64-linux";
          }).config.system.build.toplevel;
        in ''
          (
            echo "deploying ${hostname}..."
            nix copy --no-check-sigs --to ssh://${hostAttrs.ssh.host} ${nixosSystem}
            ssh $NIX_SSHOPTS ${hostAttrs.ssh.host} "sudo nix-env -p /nix/var/nix/profiles/system -i ${nixosSystem}"
            ssh $NIX_SSHOPTS ${hostAttrs.ssh.host} "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration $MODE"
          ) &
          PID_LIST+=" $!"
        '') hostnames}

      echo "deploys started, waiting for them to finish..."

      trap "kill $PID_LIST" SIGINT
      wait $PID_LIST
    '';

in {
  deploy =
    (lib.mapAttrs (hostname: hostAttrs: mkDeploy [ hostname ]) nixosHosts)
    // (lib.mapAttrs (group: hosts: mkDeploy hosts) hostsInAllGroups) // {
      all = mkDeploy (lib.attrNames nixosHosts);
    };
}
