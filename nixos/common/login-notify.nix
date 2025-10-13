{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkAfter mkDefault;
in {
  sops.secrets.ssh-notify = {
    sopsFile = ./secrets.yaml;
  };
  security.pam.services.sshd.text = let
    notify = pkgs.writeShellScript "notify" ''
      set -o allexport
      source ${config.sops.secrets.ssh-notify.path}
      set +o allexport
      if [ "''${PAM_TYPE}" = "open_session" ]; then
        curl -s -X POST \
          -H "Authorization: Bearer ''${SSH_NOTIFY_TOKEN}" \
          -H prio:high \
          -H tags:warning \
          -d "SSH login to ${config.networking.hostName}: ''${PAM_USER} from ''${PAM_RHOST}" \
          https://ntfy.kittywit.ch/alerts
      fi
    '';
  in
    mkDefault (mkAfter ''
      session optional pam_exec.so seteuid ${notify}
    '');
}
