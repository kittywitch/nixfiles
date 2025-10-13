{
  lib,
  channels,
  config,
  ...
}:
with lib; let
  enabledNixosSystems = filterAttrs (_: system: system.config.ci.enable && system.config.type == "NixOS") channels.nixfiles.systems;
  enabledHomeSystems = filterAttrs (_: system: system.config.ci.enable && system.config.type == "Home") channels.nixfiles.systems;
in {
  imports = [./common.nix];
  config = {
    name = "nodes";

    gh-actions = {
      env = {
        CACHIX_AUTH_TOKEN = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
        DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
        NIX_CONFIG = "\${{ secrets.NIX_CONFIG }}";
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
        genericNixosBuildJob = name: _system:
          nameValuePair "nixos-${name}" {
            step.nix-install."with" = {
              daemon = true;
              #github-access-token = "\${{ secrets.GITHUB_TOKEN }}";
            };
            step.${name} = {
              name = "build system closure for ${name}";
              order = 500;
              run = "nix run .#nf-build-system -- nixosConfigurations.${name}.config.system.build.toplevel ${name} NixOS";
              env = {
                NF_UPDATE_CACHIX_PUSH = "1";
                NF_CONFIG_ROOT = "\${{ github.workspace }}";
              };
            };
          };
        genericHomeBuildJob = name: _system:
          nameValuePair "home-${name}" {
            step.nix-install."with".daemon = true;
            step.${name} = {
              name = "build home closure for ${name}";
              order = 500;
              run = "nix run .#nf-build-system -- homeConfigurations.${name}.activationPackage ${name} Home";
              env = {
                NF_UPDATE_CACHIX_PUSH = "1";
                NF_CONFIG_ROOT = "\${{ github.workspace }}";
              };
            };
          };
        nixosBuildJobs = mapAttrs' genericNixosBuildJob enabledNixosSystems;
        homeBuildJobs = mapAttrs' genericHomeBuildJob enabledHomeSystems;
      in
        nixosBuildJobs // homeBuildJobs;
    };

    jobs = let
      genericNixosBuildJob = name: _system:
        nameValuePair "nixos-${name}" (_: {
          imports = [./packages.nix];
        });
      genericHomeBuildJob = name: _system:
        nameValuePair "home-${name}" (_: {
          imports = [
            ./packages.nix
          ];
        });
      nixosBuildJobs = mapAttrs' genericNixosBuildJob enabledNixosSystems;
      homeBuildJobs = mapAttrs' genericHomeBuildJob enabledHomeSystems;
    in
      nixosBuildJobs // homeBuildJobs;

    ci.gh-actions.checkoutOptions = {
      fetch-depth = 0;
    };
  };
}
