{
  inputs,
  systems,
  lib,
  ...
}: rec {
  colmenaHive = inputs.colmena.lib.makeHive colmena;
  colmena = let
    inherit (lib.attrsets) mapAttrs filterAttrs;
    colmenaBase = {
      meta = {
        description = "Kat's Infrastructure";
        nodeSpecialArgs = mapAttrs (_k: v: v._module.specialArgs) systems.nixosConfigurations;
        nodeNixpkgs = mapAttrs (_k: v: v.config.pkgs) systems.systems;
        nixpkgs = import inputs.nixpkgs {
          # this upsets me deeply.
          system = "x86_64-linux";
          overlays = [];
        };
      };
    };
    colmenaHosts = mapAttrs (_k: v: {
      config,
      lib,
      ...
    }: let
      inherit (lib.modules) mkDefault;
    in {
      imports = v.config.modules;
      deployment =
        {
          targetPort = mkDefault (builtins.head config.services.openssh.ports);
        }
        // v.config.colmena;
    }) (filterAttrs (_k: v: v.config.folder == "nixos") systems.systems);
  in
    colmenaBase // colmenaHosts;
}
