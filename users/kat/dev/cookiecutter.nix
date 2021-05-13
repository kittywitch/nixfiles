{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ cookiecutter ];

  programs.zsh.initExtra = ''
    katenv () {
      cookiecutter cookiecutters --directory $1
    }
  '';
}
