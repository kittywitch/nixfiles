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
      enabledSystems = filterAttrs (_: system: system.config.ci.enable) channels.nixfiles.lib.systems;
      mkSystemJob = name: system: nameValuePair "${name}" {
        tasks.system = {
          inputs = channels.nixfiles.nixosConfigurations.${name}.config.system.build.toplevel;
          warn = system.config.ci.allowFailure;
        };
      };
      systemJobs = mapAttrs' mkSystemJob enabledSystems;
    in {
      packages = { ... }: {
        imports = [ ./packages.nix ];
      };
    } // systemJobs;
  };
}
