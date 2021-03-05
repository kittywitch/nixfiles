{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        ${if (config.deploy.profile.gui) then
          "export SSH_AUTH_SOCK=(gpgconf --list-dirs agent-ssh-socket)"
        else
          ""}
        fish_vi_key_bindings
        set -g fish_greeting ""
      '';
      shellAliases = { nixdirfmt = "fd --color=never .nix | xargs nixfmt"; };
      plugins = [{
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "d63054b24c2f63aaa3a08fb9ec9d0da4c70ab922";
          sha256 = "0pwci5xxm8308nrb52s5nyxijk0svar8nqrdfvkk2y34z1cg319b";
        };
      }];
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      enableNixDirenvIntegration = true;
    };
    programs.bat.enable = true;
  };
}
