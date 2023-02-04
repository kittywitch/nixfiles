{ lib, config, inputs, ... }: let
  # TODO: convert to nix-std
  inherit (lib.attrsets) mapAttrsToList mapAttrs filterAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.options) mkOption;
  inherit (lib.types) int attrsOf submodule;
  buildMachines = mapAttrsToList (name: extern_: let
    extern = extern_.config;
  in {
    hostName = "${name}.inskip.me";
    sshUser = "deploy";
    systems = [ extern.nixpkgs.system ] ++ optionals (extern.nix.settings ? extra-platforms) extern.nix.settings.extra-platforms;
    maxJobs = 100;
    speedFactor = config.distributed.outputs.${name};
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  } ) (filterAttrs (n: _: n != config.networking.hostName) (inputs.self.nixosConfigurations // inputs.self.darwinConfigurations));
  daiyousei = {
    hostName = "daiyousei.inskip.me";
    sshUser = "root";
    system = "aarch64-linux";
    maxJobs = 100;
    speedFactor = 1;
    supportedFeatures = ["benchmark" "big-parallel" "kvm"];
    mandatoryFeatures = [];
  };
in {
  options.distributed = let
    baseOptions = {
      options.preference = mkOption {
        type = int;
        default = 1;
      };
    };
  in baseOptions.options // {
    systems = mkOption {
      type = attrsOf (submodule baseOptions);
      default = {};
    };
    outputs = mkOption {
      type = attrsOf int;
      default = {};
    };
  };
  config = {
    distributed.outputs = mapAttrs (name: extern: extern.config.distributed.preference +
      (if config.distributed.systems ? ${name} && config.distributed.systems.${name} ? preference then
        config.distributed.systems.${name}.preference
      else 0)
    ) (inputs.self.nixosConfigurations // inputs.self.darwinConfigurations);
    nix = {
      inherit buildMachines;
      distributedBuilds = true;
    };
  };
}
