{
  lib,
  config,
  channels,
  pkgs,
  ...
}:
with lib; let
  inherit (channels.std) string list set;
  enabledNixosSystems = filterAttrs (_: system: system.config.ci.enable && system.config.type == "NixOS") channels.nixfiles.systems;
  exportsSystems = let
    warnSystems = set.filter (_: system: system.ci.allowFailure) enabledNixosSystems;
    toSystems = systems: string.concatMapSep " " string.escapeShellArg (set.keys systems);
  in ''
    NF_NIX_SYSTEMS=(${toSystems nixosSystems})
    NF_NIX_SYSTEMS_WARN=(${toSystems warnSystems})
  '';
  buildAllSystems = pkgs.writeShellScriptBin "build-systems" ''
      ${exportsSystems}
      nix run .#nf-actions-test";
  '';
in {
  imports = [./common.nix];
  config = {
    name = "flake-update";

    gh-actions = {
      env = {
        CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
        DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
      };
      on = let
        paths = [
          "default.nix" # sourceCache
          "ci/flake-cron.nix"
          config.ci.gh-actions.path
        ];
      in {
        push = {
          inherit paths;
        };
        pull_request = {
          inherit paths;
        };
        schedule = [
          {
            cron = "0 0 * * *";
          }
        ];
        workflow_dispatch = {};
      };
      jobs.flake-update = {
        step.flake-update = {
          name = "flake update build";
          order = 500;
          run = "${buildAllSystems}/bin/build-systems";
  env = {
            CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
            DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
            NF_UPDATE_GIT_COMMIT = "1";
            NF_UPDATE_CACHIX_PUSH = "1";
            NF_CONFIG_ROOT = "\${{ github.workspace }}";
          };
        };
      };
    };

    jobs = {
      flake-update = {...}: {
        imports = [./packages.nix];
      };
    };

    ci.gh-actions.checkoutOptions = {
      fetch-depth = 0;
    };
  };
}
