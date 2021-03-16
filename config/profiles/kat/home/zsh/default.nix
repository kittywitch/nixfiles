{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.kat {
    programs.zsh = {
      enable = true;
      shellAliases = { nixdirfmt = "fd --color=never .nix | xargs nixfmt"; };
      initExtra = ''
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3,bold"          
        source ${./zshrc-title}
      '';
      plugins = [{
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.4";
          sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
        };
      }];
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "adb" "cargo" "emoji" ];
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
  };
}
