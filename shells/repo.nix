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
        nf-build-system
        nf-update
        lix
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
      echo -e "\e[39m\e[1m$USER@$REPO_HOSTNAME - \e[35m''$(realpath --relative-to=../ ./nixos/)\e[0m"
    '';
  };
in
  repoShell
