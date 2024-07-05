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
            #!/usr/bin/env bash
            set -euo pipefail

            # Helper functions
            send_discord_message() {
                local message="$1"
                local escaped_message=$(printf '%s' "$message" | ${pkgs.jq}/bin/jq -R -s '.')
                ${pkgs.curl}/bin/curl -s -H "Accept: application/json" -H "Content-Type: application/json" \
                     -X POST --data "{\"content\": $escaped_message}" "$DISCORD_WEBHOOK_LINK"
            }

            get_filesystem_usage() {
                ${pkgs.coreutils}/bin/df -h / | ${pkgs.gawk}/bin/awk 'NR==2 {print $5 " (" $3 ")"}' | tr -d '\n'
            }

            calculate_ratio() {
                local before="$1"
                local after="$2"
                ${pkgs.gawk}/bin/awk "BEGIN {printf \"%.2f\", ($after / $before) * 100}"
            }

            # Initial filesystem usage
            FS_BEFORE_USAGE=$(get_filesystem_usage)

            send_discord_message "Beginning nix garbage collection on ${config.networking.hostName} - Filesystem usage before: $FS_BEFORE_USAGE"

            # Perform garbage collection
            OUTPUT=$(${config.nix.package.out}/bin/nix-collect-garbage ${cfg.options})

            # Get filesystem usage after garbage collection
            FS_AFTER_USAGE=$(get_filesystem_usage)

            # Extract numeric values for calculation (assuming format like "75% (15G)")
            BEFORE_PERCENT=$(echo $FS_BEFORE_USAGE | ${pkgs.coreutils}/bin/cut -d'%' -f1)
            AFTER_PERCENT=$(echo $FS_AFTER_USAGE | ${pkgs.coreutils}/bin/cut -d'%' -f1)

            # Calculate ratio
            RATIO=$(calculate_ratio $BEFORE_PERCENT $AFTER_PERCENT)

            send_discord_message "Finished nix garbage collection on ${config.networking.hostName} - Filesystem usage: $FS_BEFORE_USAGE -> $FS_AFTER_USAGE ($RATIO%)"

            # Send the output of nix-collect-garbage
            send_discord_message "$OUTPUT"
        '';

        serviceConfig = {
            EnvironmentFile = config.sops.secrets.nix-gc-environment.path;
            Type = "oneshot";
        };
    };
}
