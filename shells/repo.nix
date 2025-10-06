{
  pkgs,
  inputs,
  ...
}:
with pkgs; let
  systemless-git-hooks = system: inputs.self.checks.${system}.git-hooks;
  git-hooks = systemless-git-hooks pkgs.system;
  repoShell = mkShell {
    nativeBuildInputs = [
      nf-build-system
      nf-update
      pkgs.lix
      fd # fd, better fine!
      ripgrep # rg, better grep!
      sops
      deadnix # dead-code scanner
      alejandra # code formatter
      statix # anti-pattern finder
      deploy-rs.deploy-rs # deployment system
    ];
    inherit (git-hooks) buildInputs;
    shellHook = ''
      ${git-hooks.shellHook}
      export CI_PLATFORM="impure"
      echo -e "\e[39m\e[1m$USER@$REPO_HOSTNAME - \e[35m''$(realpath --relative-to=../ ./nixos/)\e[0m"
    '';
  };
in
  repoShell
