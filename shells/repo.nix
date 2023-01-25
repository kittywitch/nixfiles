{
  pkgs,
  inputs,
  std,
  ...
}:
with pkgs; let
  repo = import ../outputs.nix { inherit inputs; };
  inherit (std) set list;
  repoShell = mkShell {
    nativeBuildInputs =
      [
        go # Required for pulumi
        pulumi-bin # Infrastructure as code
        deadnix # dead-code scanner
        alejandra # code formatter
        statix # anti-pattern finder
      ]
      ++ set.values (set.map (name: _: (pkgs.writeShellScriptBin "${name}-rebuild" ''
        darwin-rebuild switch --flake $REPO_ROOT#${name}
      ''))
      repo.darwinConfigurations);
  };
in repoShell
