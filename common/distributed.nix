{ lib, config, inputs, ... }: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) optionals;
  buildMachines = mapAttrsToList (name: config_: let
    config = config_.config;
  in {
    hostName = "${config.networking.hostName}.inskip.me";
    sshUser = "deploy";
    systems = [ config.nixpkgs.system ] ++ optionals (config.nix.settings ? extra-platforms) config.nix.settings.extra-platforms;
    maxJobs = 100;
    speedFactor = 1; # TODO: provide adjustment factor
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  } ) inputs.self.nixosConfigurations;
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
    nix = {
      inherit buildMachines;
      distributedBuilds = true;
    };
}
