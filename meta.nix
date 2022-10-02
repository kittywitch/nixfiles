{ inputs, system ? builtins.currentSystem or "x86_64-linux" , ... }: let
  patchedInputs = import ./patchedInputs.nix { inherit inputs system; };
  pkgs = import ./overlays { inherit system; inputs = patchedInputs; };
  inherit (pkgs) lib;
  tree = import ./tree.nix { inherit lib; inputs = patchedInputs; };
  root = ./.; # Required for modules/meta/imports.nix to find hosts
  nixfiles = tree.impure;

  eval = let
    esphomeNodes = (map
    (node: {
      network.nodes.esphome.${node} = {
        imports = config.lib.kw.esphomeImport node;
        esphome = {
          name = node;
        };
      };
    })
    (lib.attrNames nixfiles.esphome.boards));
    nixosNodes = (map
    (node: {
      network.nodes.nixos.${node} = {
        imports = config.lib.kw.nixosImport node;
        networking = {
          hostName = node;
        };
      };
    })
    (lib.attrNames nixfiles.nixos.systems));
    darwinNodes = (map
    (node: {
      network.nodes.darwin.${node} = {
        imports = config.lib.kw.darwinImport node;
        networking = {
          hostName = node;
        };
      };
    })
    (lib.attrNames nixfiles.darwin.systems));
  in lib.evalModules {
    modules = [
      nixfiles.modules.meta
      {
        _module.args.pkgs = lib.mkDefault pkgs;
      }
    ]
    ++ lib.attrValues nixfiles.targets
    ++ nixosNodes
    ++ darwinNodes
    ++ esphomeNodes;

    specialArgs = {
      inherit root tree;
      inputs = patchedInputs;
      meta = self;
    } // nixfiles;
  };

  inherit (eval) config;
  self = config // { inherit pkgs lib tree; inputs = patchedInputs; } // nixfiles;
in self
