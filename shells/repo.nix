{
  pkgs,
  inputs,
  std,
  ...
}:
with pkgs; let
  repo = import ../outputs.nix {inherit inputs;};
  inherit (std) set;
  repoShell = mkShell {
    nativeBuildInputs =
      [
        fd # fd, better fine!
        ripgrep # rg, better grep!
        go # Required for pulumi
        gopls
        pulumi-bin # Infrastructure as code
        deadnix # dead-code scanner
        alejandra # code formatter
        statix # anti-pattern finder
        deploy-rs.deploy-rs # deployment system
      ]
      ++ set.values (set.map (name: _: (pkgs.writeShellScriptBin "${name}-rebuild" ''
          darwin-rebuild switch --flake $REPO_ROOT#${name} $@
        ''))
        repo.darwinConfigurations);
    shellHook = ''
      echo -e "\e[39m\e[1m$USER@$REPO_HOSTNAME - \e[35m''$(realpath --relative-to=../ ./nixos/)\e[0m"
      echo -e "\e[35mRunning alejandra\e[0m"
      alejandra -cq $(fd -e nix)
      echo -e "\e[35mRunning statix\e[0m"
      statix check
      echo -e "\e[35mRunning deadnix\e[0m"
      deadnix
    '';
  };
in
  repoShell
