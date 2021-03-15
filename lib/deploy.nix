{ pkgs, hosts, groups }:

with pkgs.lib;

(mapAttrs (name: hosts:
  ''
    #!${pkgs.runtimeShell}
    export PATH=
    nix build --no-link ${concatMapStringsSep " " (host: builtins.unsafeDiscardStringContext host.config.system.build.toplevel.drvPath) hosts}
    ${concatMapStrings (host: ''
      echo "deploying ${host.config.networking.hostName}..."
      ${host.config.system.build.deployScript} $1 &
      PID_LIST+=" $!"
    '') hosts}
    # FIXME: remove jobs from PIDLIST once they finish
    trap "kill $PID_LIST" SIGINT
    wait $PID_LIST
  '') groups)
// (mapAttrs (name: host: host.config.system.build.deployScript) hosts)
