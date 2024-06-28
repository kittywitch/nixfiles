{ config, lib, pkgs, ... }: let
    inherit (lib.modules) mkForce;
in {
    nix.gc = {
        automatic = true;
        dates = "weekly";
    };
    sops.secrets.nix-gc-environment = {
        sopsFile = ./secrets.yaml;
    };
    systemd.services.nix-gc = {
        script = let
            cfg = config.nix.gc;
        in mkForce ''
            ${pkgs.curl}/bin/curl -vvvv -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Beginning nix garbage collection on ${config.networking.hostName}.${config.networking.domain}\"}" $DISCORD_WEBHOOK_LINK
            OUTPUT=$(${config.nix.package.out}/bin/nix-collect-garbage ${cfg.options});
            ${pkgs.curl}/bin/curl -vvvv -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"Finished nix garbage collection on ${config.networking.hostName}.${config.networking.domain}\"}" $DISCORD_WEBHOOK_LINK
            ${pkgs.curl}/bin/curl -vvvv -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \''${OUTPUT}\"}" $DISCORD_WEBHOOK_LINK
        '';
        serviceConfig = {
            EnvironmentFile = config.sops.secrets.nix-gc-environment.path;
        };
    };
}