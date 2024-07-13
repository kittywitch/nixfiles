{
  lib,
  config,
  channels,
  env,
  ...
}:
with lib; {
  imports = [ ./common.nix ];
  config = {
    name = "nodes";

    jobs = let
      enabledNixOSSystems = filterAttrs (_: system: system.config.ci.enable) channels.nixfiles.systems;
      mkNixOSSystemJob = name: system: nameValuePair "${name}" {
        step.build-system-wrapper = {
          name = "Build ${name} system closure";
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
        tasks = {
            system = {
              inputs = channels.nixfiles.nixosConfigurations.${name}.config.system.build.toplevel;
              warn = system.config.ci.allowFailure;
            };
        };
      };
      nixOSSystemJobs = mapAttrs' mkNixOSSystemJob enabledNixOSSystems;
    in {
      packages = { ... }: {
        imports = [ ./packages.nix ];
      };
    } // nixOSSystemJobs;
  };
}
