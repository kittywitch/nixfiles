{
  pkgs,
  inputs,
  std,
  lib,
  ...
}:
with pkgs; let
  repo = import ../outputs.nix {inherit inputs;};
  inherit (std) set;
  repoShell = mkShell {
    nativeBuildInputs =
      [
        nf-update
        fd # fd, better fine!
        ripgrep # rg, better grep!
        sops
        deadnix # dead-code scanner
        alejandra # code formatter
        statix # anti-pattern finder
        deploy-rs.deploy-rs # deployment system
      ]
      ++ set.values (set.map (name: _: (pkgs.writeShellScriptBin "${name}-rebuild" ''
          ${pkgs.darwin-rebuild}/bin/darwin-rebuild switch --flake $REPO_ROOT#${name} $@
        ''))
        repo.darwinConfigurations);
    shellHook = ''
      export CI_PLATFORM="impure"
      sops
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
