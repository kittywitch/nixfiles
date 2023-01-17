{
  pkgs,
  inputs,
  system,
  ...
}:
with pkgs; let
  repo = import ../outputs.nix (inputs // {inherit inputs system;});
  inherit (lib.attrsets) mapAttrsToList;
in
  mkShell {
    nativeBuildInputs =
      [
        deadnix # dead-code scanner
        alejandra # code formatter
        statix # anti-pattern finder
      ]
      ++ mapAttrsToList (name: _: (pkgs.writeShellScriptBin "${name}-rebuild" ''
        darwin-rebuild switch --flake $REPO_ROOT#${name}
      ''))
      repo.darwinConfigurations;
  }
