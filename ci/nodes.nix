{
  lib,
  channels,
  config,
  ...
}:
with lib; let
  pkgs = channels.nixpkgs;
in {
  imports = [ ./common.nix ];
  config = {
    name = "nodes";

    gh-actions = {
      env = {
          CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
          DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
      };
      on = let
        paths = [
          "*"
          "ci/nodes.nix"
          config.ci.gh-actions.path
        ];
      in {
        push = {
          inherit paths;
        };
        pull_request = {
          inherit paths;
        };
        workflow_dispatch = {};
      };
      jobs = let
         genericNixosBuildJob = name: system: nameValuePair "${name}" {
            step.${name} = {
                  name = "build system closure for ${name}";
                  order = 500;
                  run = "nix run .#nf-build-system -- nixosConfigurations.${name}.config.system.build.topLevel ${name} NixOS";
                  env = {
                    CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
                    DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
                    NF_UPDATE_GIT_COMMIT = "1";
                    NF_UPDATE_CACHIX_PUSH = "1";
                    NF_CONFIG_ROOT = "\${{ github.workspace }}";
                  };
             };
         };
         enabledNixosSystems = filterAttrs (_: system: system.config.ci.enable) channels.nixfiles.systems;
         nixosBuildJobs = mapAttrs' genericNixosBuildJob enabledNixosSystems;
        in nixosBuildJobs;
    };

    jobs = {
      flake-update = { ... }: {
        imports = [ ./packages.nix ];
      };
    };

    ci.gh-actions.checkoutOptions = {
      fetch-depth = 0;
    };
  };
}
