{ pkgs, lib, config, ... }: let
    inherit (lib.modules) mkAfter mkDefault;
in {
    sops.secrets.sshd-environment = {
        sopsFile = ./secrets.yaml;
    };
security.pam.services.sshd.text = let
    notify = pkgs.writeShellScriptBin "notify" ''
        export $(cat ${config.sops.secrets.sshd-environment.path} | xargs)

        if [ "$PAM_USER" = "deploy" ]; then
            if [ "$PAM_TYPE" = "open_session" ]; then
                message="''${PAM_RHOST} has opened an SSH session as part of doing a Nix deployment on ${config.networking.hostName}."
            elif [ "$PAM_TYPE" = "close_session" ]; then
                message="''${PAM_RHOST} has closed an SSH session as part of doing a Nix deployment on ${config.networking.hostName}."
            fi
        else
            if [ "$PAM_TYPE" = "open_session" ]; then
                message="''${PAM_RHOST} opened an SSH session with ${config.networking.hostName} as user ''${PAM_USER}."
            elif [ "$PAM_TYPE" = "close_session" ]; then
                message="''${PAM_RHOST} closed their SSH session with ${config.networking.hostName} for user ''${PAM_USER}."
            fi
        fi

        if [ -n "$message" ]; then
            ${pkgs.curl}/bin/curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"$message\"}" $DISCORD_WEBHOOK_LINK
        fi
    '';
in mkDefault (mkAfter ''
    session required pam_exec.so seteuid ${notify}/bin/notify
'');
}