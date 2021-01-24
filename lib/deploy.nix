{ pkgs, hosts, profiles }:

with pkgs.lib;

(mapAttrs (name: hosts:
  pkgs.writeScript "deploy-profile-${name}" ''
    #!${pkgs.runtimeShell}
    export PATH=
    ${concatMapStrings (host: ''
      echo "deploying ${host.config.networking.hostName}..."
      ${host.config.system.build.deployScript} $1 &
      PID_LIST+=" $!"
    '') hosts}
    # FIXME: remove jobs from PIDLIST once they finish
    trap "kill $PID_LIST" SIGINT
    wait $PID_LIST
  '') profiles)
// (mapAttrs (name: host: host.config.system.build.deployScript) hosts)
